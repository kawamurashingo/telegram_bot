# Google Calender Notification to Telegram
Retrieve Google Calendar appointments and notify Telegram groups

# Requirement (Dockerfile)
* Rocky Linux 8.5
* Python > 3.6.8

## Installation
```
sudo yum update
sudo yum install epel-release
sudo yum install git
sudo yum install jq
sudo yum install langpacks-ja
sudo pip3 install google-api-python-client google-auth gspread oauth2client
sudo localectl set-locale LANG=ja_JP.UTF-8
sudo timedatectl set-timezone Asia/Tokyo
sudo reboot
```

# Preparation
1. Create Google Cloud Platform Account
2. Enable Google Calendar Drive and Sheets API
3. Create Service account
4. Create Service account key (type json)
5. Add Service account in google calender and sheet
6. Create Telegram bot account
7. Create Telegram group


## GCP Compute Engine Setup with Container-Optimized OS

This guide details the steps to set up a Docker container running `pannakoota/telegram_bot` on a GCP Compute Engine instance using Container-Optimized OS.

### Step 1: Launch the VM Instance
- Choose the `pannakoota/telegram_bot` for the instance startup.
- Set the reboot policy to "Do not delete".

### Step 2: Check Running Containers
- Once the instance is up, check the running Docker containers:
  ```
  kawamurashingo@instance-1 ~ $ docker ps
  ```

### Step 3: Access the Docker Container
- Access the running container using the following command:
  ```
  docker exec -it [CONTAINER ID] /bin/bash
  ```

### Step 4: Inside the Docker Container
- Verify that cron is running:
  ```
  ps -ef | grep cron
  ```
- Check the current cron jobs:
  ```
  crontab -l
  ```

### Step 5: Edit Configurations
- Navigate to the `telegram_bot` directory:
  ```
  cd telegram_bot
  ```
- Edit the necessary configuration files (`credentials.json`, `get_events.py`, `main.sh`) as per your requirements.

### Step 6: Update Crontab
- Update the crontab to enable or disable specific cron jobs:
  ```
  crontab -e
  ```
- Save and exit the editor.

### Step 7: Save Changes to Docker Image
- After exiting the Docker container, save the changes made to a new Docker image:
  ```
  docker commit [CONTAINER ID] telegram_custom
  ```

### Step 8: Stop Original Container
- Stop the original Docker container:
  ```
  docker stop [CONTAINER ID]
  docker rm [CONTAINER ID]
  docker run -d --name [CONTAINER ID] --restart=no pannakoota/telegram_bot
  docker stop [CONTAINER ID]
  docker inspect [CONTAINER ID] --format '{{ .HostConfig.RestartPolicy.Name }}'
  ## 元のdockerコンテナは再起動されても起動してこないようにする。起動してるとanacronのプロセスが溜まっていく。
  ## OCI runtime exec failed: exec failed: unable to start container process: read init-p: connection reset by peer: unknown
  ```

### Step 9: Launch Custom Container
- Launch the customized Docker container:
  ```
  docker run --name telegram_custom -d telegram_custom
  ```

### Step 10: Set Container to Auto-restart
- Ensure the custom container automatically restarts, especially after VM reboots:
  ```
  docker update --restart=always telegram_custom
  ```
- Verify the auto-restart setting:
  ```
  docker inspect -f "{{.Name}} {{.HostConfig.RestartPolicy.Name}}" $(docker ps -aq) | grep always
  ```

### Step 11: Reboot Test
- Perform a reboot test to ensure everything is set up correctly:
  ```
  sudo reboot
  docker run -i -t telegram_custom /bin/bash
  ```


# detail usage
```
# docker
docker run -i -t pannakoota/telegram_bot /bin/bash
or
# git clone
git clone https://github.com/kawamurashingo/telegram_bot.git

# get telegram group
BOT_ID="XXXXXXX"
curl -s -X GET https://api.telegram.org/bot${BOT_ID}/getUpdates | jq -r '.result[] | .message.chat.id, .message.chat.title'

# or blowser access
# add addon json formatter https://chrome.google.com/webstore/detail/json-formatter/bcjindcccaagfpapjjmafapmmgkkhgoa/related
https://api.telegram.org/bot######/getUpdates

# edit BOT_ID in main.sh

# edit {SHEET NAME} in spredsheet_client.py(default "client") and spredsheet_member.py(default "member")
cd ./telegram_bot
#vi spreadsheet_client.py
#vi spreadsheet_member.py

# edit calendar_id(calendar account(mail address)) in get_events.py
vi get_events.py

# edit credentials.json
vi credentials.json

# edit env of BOT_ID
vi ./telegram.sh

# run
chmod 755 ./telegram.sh
sh ./telegram.sh

# set cron
*/10 8-23 * * * sh /home/xxxx/telegram_bot/telegram.sh

```

# docker stop/start
Systemd Timerを使用して毎朝7時に特定のDockerコンテナを再起動するための手順を以下に示します。このプロセスは、基本的には2つのファイルを作成し、Systemdにこれらのファイルを認識させることで構成されます。

1. **Serviceファイルの作成**: まず、Dockerコンテナを停止して再起動するコマンドを実行するSystemdのサービスファイルを作成します。

2. **Timerファイルの作成**: 次に、このサービスをいつ実行するかを定義するタイマーファイルを作成します。

### Serviceファイルの作成

`/etc/systemd/system` ディレクトリ内にサービスファイル（例：`docker-restart.service`）を作成します。

```bash
sudo nano /etc/systemd/system/docker-restart.service
```

以下の内容をファイルに追加します。

```ini
[Unit]
Description=Docker Restart Service

[Service]
Type=oneshot
ExecStart=/usr/bin/docker stop telegram_custom
ExecStart=/usr/bin/docker start telegram_custom
```

### Timerファイルの作成

次に、同じディレクトリ内にタイマーファイル（例：`docker-restart.timer`）を作成します。

```bash
sudo nano /etc/systemd/system/docker-restart.timer
```

以下の内容をファイルに追加します。

```ini
[Unit]
Description=Run Docker Restart Service at 07:00 daily

[Timer]
OnCalendar=*-*-* 07:00:00
Persistent=true

[Install]
WantedBy=timers.target
```

### Systemdにサービスとタイマーを登録

作成したサービスとタイマーをSystemdに登録します。

```bash
sudo systemctl daemon-reload
sudo systemctl start docker-restart.timer
sudo systemctl enable docker-restart.timer
```

これで、毎朝7時に`docker stop telegram_custom` と `docker start telegram_custom` が実行されるようになります。

### 確認

タイマーが正しく設定されているかを確認するには、以下のコマンドを実行します。

```bash
systemctl list-timers
```

これにより、次にタイマーがトリガーされる時間やその他の詳細が表示されます。

### 注意点

- このプロセスはContainer-Optimized OSで動作することを前提としています。他のLinuxディストリビューションではファイルパスやコマンドが異なる場合があります。
- Systemdのタイマーは、非常に柔軟で強力ですが、構成が間違っていると予期しない動作をする可能性があります。したがって、実際の環境で使用する前に、テスト環境で十分に検証することをお勧めします。

  
# Note
docker image
 - <https://hub.docker.com/r/pannakoota/telegram_bot>

how to use google api 
 - <https://zuqqhi2.com/how-to-get-my-plans-using-google-calendar-api>

how to create telegram bot account(BotFather)
 - <https://www.youtube.com/watch?v=NwBWW8cNCP4>
 - <https://yuis-programming.com/?p=1241>
 - <https://telegram.me/BotFather>

how to get group chat id
 - <https://stackoverflow.com/questions/32423837/telegram-bot-how-to-get-a-group-chat-id>

how to edit google sheets
 - <https://www.twilio.com/blog/an-easy-way-to-read-and-write-to-a-google-spreadsheet-in-python-jp>

Dockerを使用してローカルでのコンテナ作成からGCEへのデプロイまでの手順
 - <https://qiita.com/pannakoota/items/bd19a160edcddc2ff1b6>
