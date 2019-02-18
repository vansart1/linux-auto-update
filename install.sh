#!/usr/bin/env bash

# This script sets up auto-updates using apt-get on a linux distribution.
# It also installs and configures ssmtp to send emails from a gmail account
# to update the user on the status of the update

echo "Installing and setting up linux automatic updates..."

#install ssmtp if needed
if  command -v ssmtp 2>/dev/null			#check if ssmtp is installed
then
	echo "ssmtp is already installed!"
	echo -n "Would you like to reconfigure ssmtp? (y/n)? "
	read response
else
	echo "Installing ssmtp..."
	apt-get update
	apt-get install ssmtp
	response="y"
fi
#done installing ssmtp


#set up config for ssmtp if needed
if [[ $response =~ ^(N|n) ]]
then
	echo "Skipping ssmtp configuration..."
elif [[ $response =~ ^(Y|y) ]]
then
	echo "Setting up ssmtp config to use gmail..."
	mv /etc/ssmtp/ssmtp.conf /etc/ssmtp/ssmtp.conf.original
	echo "Please enter the username of the account you would like to send mail from (ex. myaccount@gmail.com):"
	read username
	echo "Please enter the password of the account you just provided:"
	read pass
	#create ssmtp.conf file in /etc/ssmtp
	echo "#ssmtp conf file created by linux-auto-update installer

root=${username}
mailhub=smtp.gmail.com:587
rewriteDomain=gmail.com

FromLineOverride=Yes

UseTLS=Yes
UseSTARTTLS=Yes

AuthUser=server.notifier.service@gmail.com
AuthPass=${pass}
AuthMethod=LOGIN

" > /etc/ssmtp/ssmtp.conf
	echo "ssmtp.conf created in /etc/ssmtp/"
else
	echo "Please type 'Y' or 'N' as an answer"
	echo "Quitting installation."
	exit 1
fi
#done configuring ssmtp


#installing linux-auto-update
echo "Installing linux-auto-update to cron.weekly..."
echo "Please enter the email address you would like to send mail to:"
read toemail
sed -i -e "s/myemail@gmail.com/$toemail/" auto-update		#replave generic email with email to send to
cp auto-update /etc/cron.weekly/
chmod +x /etc/cron.weekly/auto-update
echo "Done installing auto-update"
#done installing linux-auto-update

#printing messages
echo ""
echo "IMPORTANT: For ssmtp to be able to send emails from gmail, \"Less secure app
access\" must be enabled. Due to this, it is recommeneded to create an gmail
account only for sending out these emails."
echo "This can be done in your account security settings here:
https://myaccount.google.com/security"
echo ""
echo "NOTE: You can test ssmtp by running the command:"
echo "printf 'Subject: test\n\nTesting ssmtp' | ssmtp -v send.to.address@gmail.com"
echo ""
echo "NOTE: You can test the linux-auto-update script by running:"
echo "sudo run-parts -v /etc/cron.weekly/"
