# Find-people

Where is connected my collegue?
This script is the answer

# Telegram configuration

Add simbolink link for telegram tool

```
cd /home/user
ln -s .telegram.sh ./find-people/telegram.conf
```


# Crontab

```
*/10 * * * * cd /home/teopost/find-people; ./find-people.sh >> /home/teopost/find-people/logs/trace.log
```

