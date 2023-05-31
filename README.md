# Termux Backup

This simple script does not use any tool that does not come by default in Termux, and it is as easy to configure as changing the path where we want to make the backup.

In summary what it does is:
- Creates a .log record of the actions it performs. 
- Creates a backup (home directory included) of Termux.
- Searches for backups older than 7 days and deletes them.
- Sends a notification to the mobile when it finishes (OK or ERROR)
- (extra) With Drive sync I synchronize the path of Termux to have everything in Drive
