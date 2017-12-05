# Taylor-Retreat-MC
Minecraft Server Control Scripts for GCP\n

These scripts are meant to run on two paired Google Compute Platform instances, one to run the server, and the other to perform startup and shutdown of that instance to save cost.  The second "cron host" instance can be the cheapest micro scale instance available.  Size the main server instance appropriately for your desired server capacity.  \n

Backups are currently handled by a startup script on the core server instance, and also triggered by the cron-host during scheduled shutdown opperations. Backup script contains unique GCS bucket name you will need to update with your own.\n

These scripts are offered with no support or warranty.  User assumes all responsibility for function and/or potential cloud costs.
Questions answered on an best effort basis.  Please email matt.r.taylor@gmail.com
