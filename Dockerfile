FROM redis
COPY healthcheck /usr/local/bin/
HEALTHCHECK CMD ["healthcheck"]
