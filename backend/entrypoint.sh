#! /bin/bash
export PYTHONUNBUFFERED=TRUE
mkdir -p /logs
service statd start
python image_similarity/main.py 2>&1 | tee /logs/gunicorn_image_similarity.log &
python manage.py showmigrations | tee /logs/show_migrate.log
python manage.py migrate | tee /logs/command_migrate.log
python manage.py showmigrations | tee /logs/show_migrate.log
python manage.py build_similarity_index 2>&1 | tee /logs/command_build_similarity_index.log
python manage.py clear_cache
python manage.py createadmin -u $ADMIN_USERNAME $ADMIN_EMAIL 2>&1 | tee /logs/command_createadmin.log

echo "Running backend server..."

python manage.py rqworker default 2>&1 | tee /logs/rqworker.log &

echo "Installing crontab..."

if [ -z "$IMAGE_SCAN_SCHEDULE" ]
then
    IMAGE_SCAN_SCHEDULE="0 */6 * * *"
fi

echo "$IMAGE_SCAN_SCHEDULE python3 manage.py scan 2>&1" > crontab
supercronic crontab &

if [ "$DEBUG" = 1 ]
then
    echo "develompent backend starting"
    gunicorn --worker-class=gevent --timeout 36000 --reload --bind backend:8001 --log-level=info ownphotos.wsgi 2>&1 | tee /logs/gunicorn_django.log
else
    echo "production backend starting"
    gunicorn --worker-class=gevent --timeout 3600 --bind backend:8001 --log-level=info ownphotos.wsgi 2>&1 | tee /logs/gunicorn_django.log
fi
