FROM msoap/shell2http

ARG CONFDIR=/config
ENV CONFDIR=${CONFDIR}
COPY config ${CONFDIR}

COPY pac.sh /usr/local/bin/pac.sh
RUN chmod -R +x /usr/local/bin

ENV PORT=8080

ENV DEFAULTCONFIG=default
ENV ROUTE=/

ENTRYPOINT /app/shell2http -form -no-index -export-vars=CONFDIR,DEFAULTCONFIG -port ${PORT} \
    ${ROUTE} 'CONF=${v_conf} IP=${v_ip} PORT=${v_port} pac.sh'

