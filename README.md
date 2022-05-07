# Google calender notification to Telegram
google calender schedule remind

# Requirement
* CentOS > 7
* Python > 3.6

# Installation
```
pip install google-api-python-client google-auth
```

# Preparation
1. Create Google Cloud Platform account
2. Enable Google Calendar API
3. Create service account
4. Create service account key (type json)
5. Add service account in google calender
6. Create telegram bot account

# Usage
```
# get telegram id
curl -X GET https://api.telegram.org/botXXXXX:XXXXXXXXX/getMe

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
