#!/bin/bash

#Minecraft server scheduling

#Global variables
	CURRENTDAY=$(date +%u)
	CURRENTHOUR=$(date +%H)
	TAYLORMCSTAT=$(sudo gcloud compute instances list |grep taylor-retreat-mc |awk ' {print $6} ')
	CURRENTPOP=$(sudo curl -s https://mcapi.us/server/status?ip=35.203.141.105 |awk -F"\:|,|\}" ' {print$13} ')	
	date
	printf "Google Compute Engine Instance Status is "$TAYLORMCSTAT"\n"
	printf "MCAPI believes there are "$CURRENTPOP" players online now\n"
	printf "It is currently day "$CURRENTDAY" of the week and hour "$CURRENTHOUR" of the day\n"

#Main Scheduler
	#Check if its a weekend or not (day 0=Sunday, day 6=Saturday)
	if [[ "$CURRENTDAY" = 7 || "$CURRENTDAY" = 6 ]]; then
		#Use weekend schedule to set instance up/down
		#printf "WEEKEND\n"
		
		#Weekend running hours are from 7AM to 2AM
		if [[ "$CURENTHOUR" -lt 2 || "$CURRENTHOUR" -ge 7 ]]; then
			#Instance should be running, check instance status
			#printf "RunTime\n"
			if [ "$TAYLORMCSTAT" != "RUNNING" ];then
				#Found that the current status (variabl= TAYLORMCSTAT) does not equal "RUNNING" 
				printf "Need to start instance\n"
				#issue API command to start the instance
				STARTUP=$(sudo gcloud compute instances start taylor-retreat-mc --zone us-west1-a >> /home/mgmg-scripts/minecraft-server/instance_schedule.txt)

			else
			#Instance should not be running, check instance status
			#printf "Shutdown hours\n"
				if [ "$TAYLORMCSTAT" = "RUNNING" ]; then
					#Found that the current status is RUNNING and instance should be shut down
					#issue API command to stop the instance
					if [ "CURRENTPOP" = 0 ];then
						SHUTDOWN=$(gcloud compute instances stop taylor-retreat-mc --zone us-west1-a >> /home/mgmt-scripts/minecraft-server/instance_schedule.txt)
					else
						printf "Server is not empty, delaying shutdown\n"
					fi
				else
					printf "Instance is properly shut down, take no action\n"
				fi
			fi
		fi	
	else
		#Use the Weekday schdule to set the instance up/down
		#printf "WEEKDAY\n"

		#Weeday running hours are from 2pm to 2am
		if [[ "$CURRENTHOUR" -lt 2 || "$CURRENTHOUR" -ge 14 ]]; then
			#Instance should be running
			#printf "RunTime\n"
			if [ "$TAYLORMCSTAT" != "RUNNING" ]; then	
				#Found that the current status (Variable=TAYLORMCSTAT) does not equal "RUNNING
				printf "Need to start instance\n"
				#Issue API command to start the instance
				STARTUP=$(sudo gcloud compute instances start taylor-retreat-mc --zone us-west1-a)
			else
				printf "Instance is running as expected, take no action\n"
			fi
		else
			#Instance should not be running
			if [ "$TAYLORMCSTAT" = "RUNNING" ]; then
				#Found that the current status is RUNNING and the instance should be shut down
				#issue API command to stop the instance
				#printf "CurrentPop variable is currently "$CURRENTPOP"\n"
				if [ "$CURRENTPOP" = 0 ];then
					SHUTDOWN=$(gcloud compute instances stop taylor-retreat-mc --zone us-west1-a >> /home/mgmt-scripts/minecraft-server/instance_schedule.txt)
				else
					printf "Server is not empty, delaying shutdown\n"
				fi
			else
				printf "Instance is properly shut down, take no action\n"
			fi	
		fi
	fi


	#Install the following CRON entry to re-run this script every 15 minutes to properly start/stop instance
	#CRON=$((crontab -l ; echo "0,15,30,45 * * * * /home/mgmt-scripts/cronloader.sh")| crontab -)


