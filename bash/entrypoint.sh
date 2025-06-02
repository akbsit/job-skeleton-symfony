#!/usr/bin/env bash

composer install

bin/console cache:warmup

supervisord -c /etc/supervisor/conf.d/supervisord.conf
