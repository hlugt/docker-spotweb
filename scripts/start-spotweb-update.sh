#!/bin/bash
exec crontab /cron.conf
exec cron -f -L 15