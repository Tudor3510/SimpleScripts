#!/bin/bash

# The code below should be added to the shell script that launches Visual Studio Code(the one used in the environment variables) 
# in order to copy required files(extensions and configurations) where they should be, on its first startup
# !!! On my setup, the live user does not have a root password, so pkexec does not display a dialog asking for password

if [ -d "$HOME/.vscode" ]
then
    if [ ! -d "$HOME/.vscode/extensions" ]
    then
        mkdir $HOME/.vscode/extensions
        unzip /opt/VSCode/extensions.zip -d $HOME/.vscode/extensions/
        pkexec rm /opt/VSCode/extensions.zip
    fi
else
    mkdir $HOME/.vscode

    mkdir $HOME/.vscode/extensions
    unzip /opt/VSCode/extensions.zip -d $HOME/.vscode/extensions/
    pkexec rm /opt/VSCode/extensions.zip
fi


if [ -d "$HOME/.config/Code" ]
then
    if [ ! -d "$HOME/.config/Code/User" ]
    then
        mkdir $HOME/.config/Code/User
        pkexec mv /opt/VSCode/settings.json $HOME/.config/Code/User/settings.json
        pkexec rmdir /opt/VSCode
        pkexec chown $USER:$USER $HOME/.config/Code/User/settings.json
    fi
else
    mkdir $HOME/.config/Code

    mkdir $HOME/.config/Code/User
    pkexec mv /opt/VSCode/settings.json $HOME/.config/Code/User/settings.json
    pkexec rmdir /opt/VSCode
    pkexec chown $USER:$USER $HOME/.config/Code/User/settings.json
fi