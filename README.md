List of shell scripts for creating a 4G LTE proxy farm on a Linux Machine.

I used the program for a proxy farm myself that was going to be used for Black SEO.
The hardware was multiple ZTE MF79U 4G Dongles connected to a Debian box via a Powered USB Hub.

The scripts facilitate creating routing tables, configuring interfaces, generating slave and master proxy config files and starting those proxies as well.
The master proxy works via rotating requests with round robin throught the dongle proxies

Things i have to do in the future:
 - Automatically create the routing tables if they do not exist or there aren't enough of them in the Linux rt_tables file

Things i might add in the future:
 - Containerize the application with a docker image
 - Add scripts for automatic login to Dongle Web Interface
