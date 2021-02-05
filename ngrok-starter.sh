#! /bin/bash


if [ "$1" = "" ] ; then
    echo "オプションを指定してください(help,install,uninstall)"
    exit 1
fi

if [ $1 = "help" ] ; then
    echo "使い方"
    echo "インストールの場合は"install"オプションを使ってください"
    echo "アンインストールの場合は"uninstall"オプションを使ってください"
    exit 1
fi

if [ $1 = "install" ] ; then
    echo "インストールを開始します"
    echo "パスワードを入力してください"
    sudo echo "パスワードを確認しました" || exit 0
    wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip
    unzip ngrok-stable-linux-arm.zip
    sudo mv ngrok /usr/local/bin/
    sudo rm ngrok-stable-linux-arm.zip
    sudo tee /etc/systemd/system/ngrok.service << SERVICE_SCRIPT
    [Unit]
    Description=ngrok

    [Service]
    ExecStart=/usr/local/bin/ngrok tcp -authtoken $2 -region=jp -log=stdout 22

    [Install]
    WantedBy=multi-user.target
SERVICE_SCRIPT
    sudo systemctl enable ngrok.service
    sudo systemctl start ngrok.service
    exit 1
fi

if [ $1 = "uninstall" ] ; then
    echo "アンインストールを開始します"
    echo "インストールを開始します"
    echo "パスワードを入力してください"
    sudo echo "パスワードを確認しました" || exit 0
    sudo systemctl disable ngrok.service
    sudo rm /usr/local/bin/ngrok
    sudo rm /etc/systemd/system/ngrok.service
    echo "アンインストールが完了しました"
    exit 1
fi