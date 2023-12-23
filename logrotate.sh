#!/bin/bash
LOG_FILE="/telegram_bot/cron.log"
MAX_SIZE=1000000 # 1MB

if [ $(stat -c%s "$LOG_FILE") -ge $MAX_SIZE ]; then
    mv $LOG_FILE $LOG_FILE.$(date +%Y%m%d)
    touch $LOG_FILE
fi
