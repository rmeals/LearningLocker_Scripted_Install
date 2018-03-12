# LearningLocker_Scripted_Install
This is a quick script that I wrote to get a fresh CentOS configured for the Learning Locker deploy script.


     Learning Locker System Prep

 Script. Configured to be installed on a 
 fresh CentOS Minimal install.
 
 Download and install Cent, Ensure you have 
 network connectivity and login as root.

 Suggest that you install wget:
 
 yum install wget
 
 and then run the following command to 
 download the script to your new Cent 
 instance:
 
 wget http://s3.amazonaws.com/HappyMeals/in_base.sh
 
 Finally, run this command to make the script 
 executable and finally, run the scrit:
 
 chmod 755 ~/in_base.sh
 bash in_base.sh
 

 At the end of the script, the Learning Locker
 install script is downloaded. You can access
 here:

 /usr/share/nginx/html/deployll.sh

 As above, run the script with this command and
 you will end up with your own, fully configured
 and working LearningLocker LRS

 ./deployll.sh

 Enjoy!  

