FROM ubuntu:14.04
# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
# avoid stuck build due to user prompt
RUN adduser --system --group --no-create-home odoo

ARG DEBIAN_FRONTEND=noninteractive

RUN set -x; \
        apt-get update \
        && apt-get install -y --no-install-recommends \
            ca-certificates \
            curl \
            node-less \
            node-clean-css \
            wget \
            git \
            gcc \
            nano

RUN set -x; \
        apt-get install -y --no-install-recommends \
            build-essential \
            python-gevent \
            python-pip \
            python-pyinotify \
            python-renderpm \
            python-support \
            python-dateutil \
            python-feedparser \
            python-gdata \
            python-ldap \
            python-libxslt1 \
            python-lxml \
            python-mako \
            python-openid \
            python-psycopg2 \
            python-pybabel \
            python-pychart \
            python-pydot \
            python-pyparsing \
            python-reportlab \
            python-simplejson \
            python-tz \
            python-vatnumber \
            python-vobject \
            python-webdav \
            python-werkzeug \
            python-xlwt \
            python-yaml \
            python-zsi \
            python-docutils \
            python-psutil \
            python-unittest2 \
            python-mock \
            python-jinja2 \
            python-dev \
            libpq-dev \
            poppler-utils \
            python-pdftools \
            antiword \
            python-setuptools \
            python-requests \
            python-pypdf \
            python-decorator \
            python-passlib \
            python-pil 
            
RUN apt-get update \
    && rm -rf /var/lib/apt/lists/*
    
RUN mkdir /opt/odoo \
    && chown -R odoo /opt/odoo \
    && mkdir -p /mnt/extra-addons \
    && chown -R odoo /mnt/extra-addons \
    && mkdir -p /log \
    && chown -R odoo /log \
    && mkdir -p /etc/odoo \
    && chown -R odoo /etc/odoo \
    && mkdir -p /home/odoo_data \
    && chown -R odoo /home/odoo_data \
    && mkdir -p /opt/odoo \
    && chown -R odoo /mnt/extra-addons

# Copy entrypoint script and Odoo configuration file
COPY ./entrypoint.sh /  
COPY ./openerp-server.conf /etc/odoo/
COPY ./requirements.txt /  
COPY ./odoo /opt/odoo
#RUN chown odoo /etc/odoo/openerp-server.conf

#RUN pip install --upgrade "pip < 21.0"
#RUN pip install --no-cache-dir -r requirements.txt

# Mount /var/lib/odoo to allow restoring filestore and /mnt/extra-addons for users addons
VOLUME ["/mnt/odoo", "/mnt/extra-addons"]
VOLUME ["/log", "/log"]

# Install Odoo
ENV ODOO_VERSION 8.0
ENV DBHOST 172.21.0.2
ENV DBPORT 5432
ENV DBNAME postgres
ENV DBUSER odoo
ENV DBPASSWORD odoo

WORKDIR /opt/odoo
#RUN git clone https://github.com/odoo/odoo.git /opt/odoo -b 8.0 --depth=1

#RUN ./odoo.py setup_pg

# Expose Odoo services
EXPOSE 8069 8071

# Set the default config file
ENV OPENERP_SERVER /etc/odoo/openerp-server.conf

# Set default user when running the container
#USER odoo
CMD ["openerp-server", "-c", "/etc/odoo/openerp-server.conf", "--db_host=", "$DBHOST", "--db_port=", "$DBPORT", "--database=", "$DBNAME", "--db_user=", "$DBUSER", "--db_password=", "$DBPASSWORD"]

