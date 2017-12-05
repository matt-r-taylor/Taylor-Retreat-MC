
#!/bin/bash

#Global Varibles
	#Query and parse mojang JSON of versions and parse out most current
	MCJSON=$(curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json |awk -F\" ' {print $10} ')
#		printf "${MCJSON}\n"
	#Version currently running on the server, if any
	CURRENTVER=$(ls -al  /home/minecraft |grep -v ".old" |grep minecraft |awk -F\. ' {print $2"."$3"."$4}')
#		printf "${CURRENTVER}\n"
	
#Function Blocks
#----------------

#Version Check Function
vercheck () {
	if [ -z "$CURRENTVER" ]; then #Server does not have a current version
		printf "No current version file found, downloading latest version\n"
		getlatest
	else
		if [ $CURRENTVER != $MCJSON ]; then #If the current version doesn't match the Mojang current version
	
			printf "New Server Version is Available: ${MCJSON}\n"
	       		printf "Moving existing .jar file to .old\n"
			
			#Arvhive old versions for potential roll back			
			FILENAME="/home/minecraft/minecraft_server."$CURRENTVER".jar"
#				printf "${FILENAME}\n"
			OLDFILENAME="/home/minecraft/oldversions/minecraft_server."$CURRENTVER".jar.old"
#				printf "$OLDFILENAME\n"
			sudo mv $FILENAME $OLDFILENAME
#				printf "Downloading latest version\n"

			printf "\n\n"
			printf "Downloading latst version\n"
			
			#Run the function to download the new latest server version
			getlatest
		else
			#Server is running the Mojang current version and no action needed
			printf "Server Version is Current\n"
		fi
	fi
}

#Download Latest Version Function
getlatest () {

	NEWVERURL="https://s3.amazonaws.com/Minecraft.Download/versions/"$MCJSON"/minecraft_server."$MCJSON".jar"	
	sudo wget $NEWVERURL
}

launchlatest () {
	#Function to launch the server, create and save the running screen session.
	
	LAUNCHVER="minecraft_server."$MCJSON".jar"
	printf "$LAUNCHVER\n"
	LAUNCHSTRING="screen -d -m -S mcs java -Xms1g -Xmx7G -d64 -jar "$LAUNCHVER" nogui"
	printf "$LAUNCHSTRING\n"
	sudo $LAUNCHSTRING
	
}

#-------------------
#END FUNCTION BLOCKS


#Main Script Execution
vercheck
launchlatest

