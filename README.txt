This script sets up weekly auto updates for linux using apt-get. 

It is compatible with linux distributions that use apt-get for
their package management such as debian and ubuntu. 

This script depends on and set up ssmtp to send emails about the 
status of update using a gmail account. It also uses cron.weekly 
to update the system once per week. 

Instructions:
1) cd linux-auto-update
2) chmod +x install.sh
3) sudo ./install.sh
4) Follow the prompts! :)
