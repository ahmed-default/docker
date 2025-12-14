FROM ubuntu:resolute-20251130

RUN apt update && \
    apt install nginx -y && \
    rm -rf /var/www/hmtl/* && \
    rm -rf /var/lib/apt/lists/*

COPY 2136_kool_form_pack/ /var/www/html/

EXPOSE 80

CMD [ "nginx", "-g", "daemon off;" ]

