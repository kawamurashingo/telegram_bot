FROM rockylinux:8.5

RUN yum update -y 
RUN yum install -y \
 epel-release \
 git \
 jq \
 langpacks-ja \
 cronie \
 python3

RUN pip3 install google-api-python-client google-auth gspread oauth2client

RUN dnf -y install langpacks-ja \
 && cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

ENV LANG="ja_JP.UTF-8" \
    LANGUAGE="ja_JP:ja" \
    LC_ALL="ja_JP.UTF-8"

RUN git clone https://github.com/kawamurashingo/telegram_bot
RUN chmod 775 /telegram_bot/telegram.sh
RUN chmod 775 /telegram_bot/logrotate.sh
RUN /usr/bin/crontab /telegram_bot/crontab.txt

CMD crond && tail -f /dev/null
