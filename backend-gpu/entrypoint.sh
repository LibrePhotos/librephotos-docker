#!/bin/bash
export PYTHONUNBUFFERED=TRUE
export PYTHONFAULTHANDLER=1
nvidia-smi
export CUDA_VISIBLE_DEVICES=0
if [[ "$(uname -m)" == "aarch64"* ]]; then
    export OPENBLAS_CORETYPE=ARMV8
    echo "ARM architecture detected. OPENBLAS_CORETYPE set to ARMV8"
fi
export OPENBLAS_NUM_THREADS=1
export OPENBLAS_MAIN_FREE=1

mkdir -p /logs
python manage.py showmigrations | tee /logs/show_migrate.log
python manage.py migrate | tee /logs/command_migrate.log
python manage.py showmigrations | tee /logs/show_migrate.log
python manage.py collectstatic --no-input
python manage.py start_service all
python manage.py start_cleaning_service
python manage.py clear_cache 
python manage.py build_similarity_index 2>&1 | tee /logs/command_build_similarity_index.log

if [[ -n "$ADMIN_USERNAME" ]]; then
    python manage.py createadmin -u "$ADMIN_USERNAME" "$ADMIN_EMAIL" 2>&1 | tee /logs/command_createadmin.log
fi

echo "Running backend server..."

python manage.py qcluster 2>&1 | tee /logs/qcluster.log &

if [[ "$DEBUG" = 1 ]]; then
    echo "development backend starting"
    gunicorn --worker-class=gevent --max-requests 50 --reload --bind 0.0.0.0:8001 --log-level=info librephotos.wsgi 2>&1 | tee /logs/gunicorn_django.log
else
    echo "production backend starting"
    gunicorn --worker-class=gevent --max-requests 50 --bind 0.0.0.0:8001 --log-level=info librephotos.wsgi 2>&1 | tee /logs/gunicorn_django.log
fi
