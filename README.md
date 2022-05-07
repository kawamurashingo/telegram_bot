# Google Calender Notification to Telegram
Retrieve Google Calendar appointments and notify Telegram groups

# Requirement
* Rocky Linux 8
* Python > 3.6.8

# Installation
```
sudo yum -y update
sudo yum -y install epel-release
sudo yum -y install git
sudo yum -y install jq
sudo yum -y install langpacks-ja
sudo localectl set-locale LANG=ja_JP.UTF-8
sudo pip3 install google-api-python-client google-auth
git clone https://github.com/kawamurashingo/telegram_bot.git
```

# Preparation
1. Create Google Cloud Platform Account
2. Enable Google Calendar API
3. Create Service account
4. Create Service account key (type json)
5. Add Service account in google calender
6. Create Telegram bot account
7. Create Telegram group

# Usage
```
# get telegram group id
curl -s -X GET https://api.telegram.org/botXXXXXXX:YYYYY | jq -r '.result[] | .message.chat.id, .message.chat.title'

# edit member and client file
cd ./telegram_bot
vi member
vi client

# edit calendar_id in get_events.py
vi get_events.py

# edit credentials.json
vi credentials.json

# run
sh ./telegram.sh
```

# Note
how to use google api 
 - <https://zuqqhi2.com/how-to-get-my-plans-using-google-calendar-api>

how to create telegram bot account
 - <https://www.youtube.com/watch?v=NwBWW8cNCP4>
 - <https://yuis-programming.com/?p=1241>

how to get group chat id
 - <https://stackoverflow.com/questions/32423837/telegram-bot-how-to-get-a-group-chat-id>
