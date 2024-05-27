FROM nginx
RUN useradd -ms /bin/bash appuser
WORKDIR /home/
COPY ./server/nginx.conf /etc/nginx/nginx.conf
COPY ./server/server.c .
COPY ./run.sh .
RUN chmod +x run.sh \
    && apt update \
    && apt install -y gcc spawn-fcgi libfcgi-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && chown -R appuser:appuser /home \
    && chown -R appuser:appuser /etc/nginx/nginx.conf \
    && chown -R appuser:appuser /var/cache/nginx \
    && touch /var/run/nginx.pid \
    && chown -R appuser:appuser /var/run/nginx.pid
USER appuser
ENTRYPOINT ["./run.sh"]