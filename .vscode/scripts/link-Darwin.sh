#!/bin/sh

defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

rm -rf ${HOME}/Library/Application\ Support/Code/User
ln -s ${HOME}/.vscode/vscode_settings/snippets/ ${HOME}/Library/Application\ Support/Code/User

rm ${HOME}/Library/Application\ Support/Code/User/settings.json
ln -s ${HOME}/.vscode/vscode_settings/settings.json ${HOME}/Library/Application\ Support/Code/User/settings.json

rm ${HOME}/Library/Application\ Support/Code/User/keybindings.json
ln -s ${HOME}/.vscode/vscode_settings/keybindings.json ${HOME}/Library/Application\ Support/Code/User/keybindings.json

