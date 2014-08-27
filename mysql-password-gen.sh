#!/bin/bash

echo "Random passwords will be set for all MySQL users that have no password currently set."; 
echo "Press any key to continue..."; read derp;
for i in $(mysql -e "select User,Password from mysql.user where password=''" | grep -v Password | awk '{print $1}'); 
do echo "Generating password for user '$i'..."; 
   pass=$(echo $RANDOM | md5sum | awk '{print $1}'); 
   mysql -e "update mysql.user set password='$pass' where User='$i'"; 
done; echo "Done."
