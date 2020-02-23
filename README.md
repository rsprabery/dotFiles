# dotFiles #

These are my config files for tmux, zsh, vim, and ruby's gem.

They are pretty specific to my setup, but feel free to use them as a starting point for your own setup.

## Tmux
- The config file has been modified to be more like GNU SCREEN
- CTRL-A is the main key as opposed to CTRL-B
- Also, in general things are more like vi
 - You can move from one pane to another with CTRL-A then directions (hjkl)

## Zshrc
This has numerous plugins enabled, and assumes you are using [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh).
I have different sections for OS X specific customizations and Linux specific customizations.

## Gemrc
The only thing I do with this is remove the installation of documentation.

## Setup.sh
Just run the setup script to sym. link all the files.  It will also setup your user name and email for git.

### VSCode

VSCode config files can't live in place like other dotFiles, and must be
sym linked. Run the following:

`./.vscode/scripts/link-$(uname -s).sh`

## Additional Script Files

I have some additional scripts in `install_scripts` that I use on Ubuntu systems for installing things like oracle-java,
the basic programs I use (git, curl, tmux, zsh, etc.) and some things to aid in python development.
