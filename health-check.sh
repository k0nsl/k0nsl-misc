#!/bin/bash
#
# Health-check our services and restart them as needed
#
# Usage: {0} <service>

set -eo pipefail

KNOWN_SERVICES='service1, service2, service3'

function _info () { echo -e "[health] INFO - $*" 1>&2; }
function _warn () { echo -e "[health] WARN - $*" 1>&2; }

function check_health () {
  _info "checking '$1'..."
  curl -s --head "$1" | head -n1 | grep '200 OK' > /dev/nul || {
    _warn "$1 appears to be down!"
    return 1
  }
  _info "$1 appears to be up!"
}

function check_shop () {
  check_health 'https://subdomain.domain.tld/' || {
    _warn 'service1 is down. restarting!'
    service shop restart
  }
}

function check_service2 () {
  check_health 'http://domain.tld/' || {
    _warn 'service2 is down. restarting!'
    service codoh restart
  }
}

function service3 () {
  check_health 'https://domain.tld/somepage.ext' || {
    _warn 'service3 is down. restarting!'
    service nginx restart
    service php5-fpm restart
  }
}

case "$1" in
  service1) check_service1;  ;;
  service2) check_service2; ;;
  service3) check_service3; ;;
  '')
    _warn "Missing required argument <service>."
    _warn "Must be one of: $KNOWN_SERVICES"
    ;;
  *)
      _warn "unknown service: $1."
    _warn "Must be one of: $KNOWN_SERVICES";
    ;;
esac
