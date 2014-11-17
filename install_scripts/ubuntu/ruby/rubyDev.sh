#!/bin/bash

sudo apt-get install --yes libpq-dev nodejs sqlite3 libsqlite3-dev libmysqld-dev
gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable --ruby

