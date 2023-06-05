FROM node:18-slim as builder

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
ENV CLI_WIDTH 80
RUN curl -SL https://github.com/LibrePhotos/librephotos-frontend/archive/refs/heads/dev.tar.gz | tar --strip-components=1 -zxC .
RUN npm install --legacy-peer-deps
RUN npm run postinstall
RUN npm run build

FROM halverneus/static-file-server
ENV PORT 3000
EXPOSE 3000

COPY --from=builder /usr/src/app/build /web

ENTRYPOINT ["/serve"]
CMD []
