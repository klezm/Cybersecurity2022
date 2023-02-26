#!/bin/bash

# https://blog.apnic.net/2022/04/06/how-to-installing-an-rpki-validator-2/


# Preparations

sudo apt update
# sudo apt update && sudo apt -y dist-upgrade
# sudo apt install -y curl wget git gcc rsync build-essential
sudo apt install -y bat


# 1. Installing Routinator

git clone --depth 1 https://github.com/NLnetLabs/routinator


# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# source $HOME/.cargo/env

cargo install --locked routinator
# Note: If an error occurs, try installing a previous version by using the command:
# cargo install --force routinator --version 0.8.3

# # Initiate the new Routinator. This will prepare both the directory for the local RPKI cache, as well as the directory where the TAL files reside.
# routinator init --accept-arin-rpa # routinator vrps --format csv
# # Note: The extra parameter means that you agree to the ARIN RPA. Make sure to read the agreement before proceeding.

# # Confirm the five TAL files exist.
# ls -lha ~/.rpki-cache/tals/
# # View the contents of the APNIC TAL file.
# more ~/.rpki-cache/tals/apnic.tal

# # To get an overview of all available TALs use the --list-tals option.
# routinator init --list-tals
routinator --tal=list

# # View the current/default configuration of Routinator.
# routinator config

# # As a test run, use the following command to pull all the validated ROA payloads. Note that this sync process may take some time.
# routinator -v vrps
# # Note: There may be some messages about validation failed or other types of error messages. These can be ignored.

# # Once the update has finished, a list of Autonomous System numbers (ASNs), IP prefixes, Max Lengths and Trust Anchors will be displayed.

# # To check the RPKI origin validation status of the BGP announcement, use the validate option.
# routinator validate --noupdate --asn 135533 --prefix 61.45.248.0/24

# # To get the results in json format add the --json option to the command.
# routinator validate --noupdate --asn 135533 --prefix 61.45.248.0/24 --json

# # In addition to the various validated ROA payloads (VRPs) output formats, Routinator’s HTTP server also provides a user interface, an API, monitoring and logging endpoints, assuming the server’s IP address is in the range of 192.168.30.XX. Use the following command to start the HTTP server:
# routinator server --http 192.168.30.XX:8080
# # Note: This service is intended to run on the internal network and doesn’t offer HTTPS natively.

# # To view the VRP in JSON format authorizing AS135533, open a new terminal window and type the following command:
# curl http://192.168.30.XX:8080/json?select-asn=135533

# # The HTTP server can also be used to view the status and other metrics.
# curl --silent http://192.168.30.XX:8080/status | more

# # To view the metrics, type the following command:
# curl --silent http://192.168.30.XX:8080/metrics | more

# # Use a browser to open the Routinator HTTP server http://192.168.30.XX:8080 page.
# # Note: Browse the web interface, then search for ASN: 135533 and Prefix: 61.45.248.0/24
# # Go back to the terminal window where the Routinator’s HTTP server is running and stop the server by pressing ctrl+c.


# # Setting up an RTR session — validator side


# # Routinator can act as an RPKI to Router Protocol (RTR) server to allow RPKI-enabled routers to connect to it and fetch the validated cache (ROA cache).
# # The Internet Assigned Numbers Authority (IANA) has specified a standard port 323 for the RTR, which would require running Routinator as a root. In the following example we use port 3323, which is greater than 1024, and means Routinator doesn’t need to be logged in as the root.
# # Run the Routinator as an RTR server listening on port 3323.

# # To listen to a specific IP address, use:
# routinator server --rtr 192.168.30.X:3323 --refresh=900

# # If you don’t specify the refresh time, by default the local repo will be updated and re-validated every one hour (as per RFC 8210). The example above uses a 15-minute (900secs) refresh time.
# # Note: If you have IPv6 address configured on Routinator, you can listen on both:

# routinator server --rtr 192.168.30.X:3323 --rtr [2001:0DB8::X]:3323 --refresh=900
# # Now the validator is ready to feed the validated cache to BGP speaking routers through the RTR protocol.

# # Confirm that Routinator is running using the following commands:

# ps aux | grep routinator
# netstat -tulnp | grep 3323
