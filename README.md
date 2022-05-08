# Google Calender Notification to Telegram
Retrieve Google Calendar appointments and notify Telegram groups

# Requirement
* Rocky Linux 8
* Python > 3.6.8

# Installation
```
sudo yum update
sudo yum install epel-release
sudo yum install git
sudo yum install jq
sudo yum install langpacks-ja
sudo localectl set-locale LANG=ja_JP.UTF-8
sudo pip3 install google-api-python-client google-auth
sudo timedatectl set-timezone Asia/Tokyo
sudo reboot
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
# git clone
git clone https://github.com/kawamurashingo/telegram_bot.git

# get telegram group id
BOT_ID="XXXXXXX"
curl -s -X GET https://api.telegram.org/bot${BOT_ID}/getUpdates | jq -r '.result[] | .message.chat.id, .message.chat.title'

# edit member and client file
cd ./telegram_bot
vi member
vi client

# edit calendar_id and credentials.json path in get_events.py
vi get_events.py

# edit credentials.json
vi credentials.json

# edit env of BOT_ID
vi ./telegram.sh

# run
chmod 755 ./telegram.sh
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
