#!/bin/bash

set -e

# set odoo database host, port, user and password
#: ${PGHOST:=$DB_PORT_5432_TCP_ADDR}
#: ${PGPORT:=$DB_PORT_5432_TCP_PORT}
#: ${PGUSER:=${DB_ENV_POSTGRES_USER:='postgres'}}
#: ${PGPASSWORD:=$DB_ENV_POSTGRES_PASSWORD}

: ${PGHOST:='172.21.0.2'}
: ${PGPORT:=5432}
: ${PGUSER:=${DB_ENV_POSTGRES_USER:='postgres'}}
: ${PGPASSWORD:=${DB_ENV_POSTGRES_PASSWORD:='postgres'}}
export ODOO_CONF PGHOST PGPORT PGUSER PGPASSWORD

case "$1" in
	--)
		shift
		exec openerp-server -c /etc/odoo/openerp-server.conf "$@"
		;;
	-*)
		exec openerp-server -c /etc/odoo/openerp-server.conf "$@"
		;;
	*)
		exec "$@"
esac

exit 1
