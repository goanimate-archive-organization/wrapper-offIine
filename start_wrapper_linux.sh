#!/bin/bash 
# Wrapper: Offline launcher (Linux)
# Original Author: xomdjl_#1337 (ytpmaker1000@gmail.com)
# Additional comments: This is untested. Don't expect it to work perfectly just yet.

# Load any necessary variables and stuff
CD=dirname $0

# Flash Player
echo "Checking for Flash Player (NPAPI) installation..."
if [ -f "/usr/lib/mozilla/plugins/libflashplayer.so"]; then
    echo "Flash Player detected."
else
    echo "Could not detect Flash Player."
    echo " "
    echo "Checking if the file is being run as root..."
    if [ "$EUID" -ne 0 ] then
        echo "ERROR: Wrapper: Offline is not running as root."
        echo "It's necessary in order to install any missing things."
        echo "Please run this bash file as root, and then try again."
    else
        if [ -d "/usr/lib/mozilla/plugins"]; then
            echo "Directory exists."
        else
            echo "Directory does not exist. Making directory..." 
            mkdir "/usr/lib/mozilla/plugins"
        fi
        echo "Installing Flash Player..."
        sudo cp "$CD/utilities/linux/libflashplayer.so" "/usr/lib/mozilla/plugins"
        echo "Successfully installed Flash Player!"
    fi
fi

# Node.js
echo "Checking for Node.js installation..."
if ! command -v 'npm --version' &> /dev/null then
    echo "Could not detect Node.js."
    echo " "
    echo "Checking if the file is being run as root..."
    if [ "$EUID" -ne 0 ] then
        echo "ERROR: Wrapper: Offline is not running as root."
        echo "It's necessary in order to install any missing things."
        echo "Please run this bash file as root, and then try again."
    else
        echo Installing Node.js...
        sudo apt install nodejs
        if ! command -v 'npm --version' &> /dev/null then
            echo "Sorry bud, looks like you'll have to do it manually."
            echo " "
            echo 'Open another terminal window and type "sudo apt install nodejs".'
            exit
        else
            echo "Successfully installed Node.js!"
        fi
    fi
else
    echo "Node.js detected."
    echo " "
    echo "Installing any necessary dependencies..."
    cd $CD/wrapper
    npm install
    cd -
    echo "Checking for http-server..."
    if [ -f "/usr/local/bin/http-server" ]; then
        echo "http-server detected."
    else
        echo "Could not detect http-server."
        echo " "
        echo "Checking if the file is being run as root..."
        if [ "$EUID" -ne 0 ] then
            echo "ERROR: Wrapper: Offline is not running as root."
            echo "It's necessary in order to install any missing things."
            echo "Please run this bash file as root, and then try again."
        else
            echo Installing http-server...
            sudo npm install http-server -g
            echo "Successfully installed http-server!"
        fi
    fi
fi

# Pale Moon
echo "Checking for Pale Moon installation..."
if [ -d "/usr/lib/palemoon"]; then
    echo "Pale Moon detected."
else
    echo "Could not detect Pale Moon."
    echo " "
    echo "Checking if the file is being run as root..."
    if [ "$EUID" -ne 0 ] then
        echo "ERROR: Wrapper: Offline is not running as root."
        echo "It's necessary in order to install any missing things."
        echo "Please run this bash file as root, and then try again."
    else
        echo "Installing Pale Moon..."
        echo 'deb http://download.opensuse.org/repositories/home:/stevenpusser/xUbuntu_20.04/ /' | sudo tee /etc/apt/sources.list.d/home:stevenpusser.list
        wget -O - https://download.opensuse.org/repositories/home:stevenpusser/xUbuntu_20.04/Release.key | sudo apt-key add -
        sudo apt update
        sudo apt install palemoon
        if [ -d "/usr/lib/palemoon"]; then
            echo "Successfully installed Pale Moon!"
        else
            echo "That's strange. The installation didn't work."
            echo " "
            echo "Follow the instructions over at this link:"
            echo "https://ubuntuhandbook.org/index.php/2020/07/install-pale-moon-ubuntu-20-04/"
            exit
        fi
    fi
fi

# Certificate
echo "Checking for the HTTPS/SSL certificate for the server..."
if [ -f "/usr/local/share/ca-certificates/the.crt"]; then
    echo "Certificate detected."
else
    echo "Could not find the certificate."
    echo " "
    echo "Checking if the file is being run as root..."
    if [ "$EUID" -ne 0 ] then
        echo "ERROR: Wrapper: Offline is not running as root."
        echo "It's necessary in order to install any missing things."
        echo "Please run this bash file as root, and then try again."
    else
        echo "Registering the certificate..."
        sudo cp "$CD/server/the.crt" "/usr/local/share/ca-certificates"
        echo "Successfully registered certificate!"
    fi
fi

# Launcher
echo "Launching Node.js..."
xterm -e 'npm start'
echo "Launching http-server..."
xterm -e 'http-server -p 4664 -c-1 -S -C the.crt -K the.key --trace-deprecation'
echo "Launching Pale Moon..."
palemoon "http://localhost:4343"
echo "Everything is up and running!"
echo " "
echo "(NOTE: If you end up closing Pale Moon by accident,"
echo "go to Applications, select Pale Moon, navigate to"
echo '"http://localhost:4343" in the URL box, and there!)'
echo " "
-p "You may press any key to close this window out if you want."
exit
