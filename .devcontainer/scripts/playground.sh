#!/bin/bash

sudo apt update
sudo apt install ca-certificates curl gnupg lsb-release

# Add the GPG key from NLnet Labs:
curl -fsSL https://packages.nlnetlabs.nl/aptkey.asc | sudo gpg --dearmor -o /usr/share/keyrings/nlnetlabs-archive-keyring.gpg

# Now, use the following command to set up the main repository:
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/nlnetlabs-archive-keyring.gpg] https://packages.nlnetlabs.nl/linux/ubuntu \
    $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/nlnetlabs.list > /dev/null

# Update the apt package index once more:
sudo apt update

# You can now install Routinator with:
sudo apt install routinator
# After installation Routinator will run immediately as the user routinator and be configured to start at boot.
# By default, it will run the RTR server on port 3323 and the HTTP server on port 8323.
# These,and other values can be changed in the configuration file located in /etc/routinator/routinator.conf.

# # You can check the status of Routinator with:
# sudo systemctl status routinator

# # You can view the logs with:
# sudo journalctl --unit=routinator
