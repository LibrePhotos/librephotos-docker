FROM reallibrephotos/librephotos-base:dev
# actual project
ARG DEBUG
WORKDIR /code
RUN curl -SL https://github.com/LibrePhotos/librephotos/archive/refs/heads/dev.tar.gz | tar --strip-components=1 -zxC .
RUN pip install --break-system-packages --no-cache-dir -r requirements.txt
RUN if [ "$DEBUG" = 1 ] ; then \
  pip install --break-system-packages -r requirements.dev.txt; \
  fi
EXPOSE 8001

COPY entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]
