# Google calender notification to Telegram
google calender schedule remind

# Requirement
* CentOS > 7
* Python > 3.6

# Installation
```
sudo yum install git
sudo yum install python3
sudo pip3 install google-api-python-client google-auth
sudo yum install epel-release
sudo yum install jq
#sudo yum -y install ibus-kkc vlgothic-* 
#sudo localectl set-locale LANG=ja_JP.UTF-8
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
curl -s -X GET https://api.telegram.org/botXXXXXXX:YYYYY/getUpdates |jq .result[].message.chat.id

# edit member and client file
vi member
vi client

# run
sh ./telegram.sh
```

# Note
how to use google api 
https://zuqqhi2.com/how-to-get-my-plans-using-google-calendar-api

how to create telegram bot account
https://www.youtube.com/watch?v=NwBWW8cNCP4

how to get group chat id
https://stackoverflow.com/questions/32423837/telegram-bot-how-to-get-a-group-chat-id
