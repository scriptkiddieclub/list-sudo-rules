# What does list-sudo-rules.sh do?
- It checks automated sudo rules for every found user on each system through ssh login
- It will accept every ssh-fingerprint automatically, if the systemes is unkown

# For whom is this suitable?
Mostly for penetrations testers, with many linux systems in scope

# Prerequisites
- sudo rules on targets
- ssh login enabled
- hostlist.txt with all the systems to be checked in the same path

# Example
Output:
```
_______________________________________________

host: abc
_______________________________________________
User XXX may run the following commands on abc:
    (root) NOPASSWD: /bin/cat /var/log/messages
    (root) NOPASSWD: /usr/sbin/dmidecode
    (root) NOPASSWD: /usr/bin/du

_______________________________________________

host: 123
_______________________________________________
User YYY may run the following commands on 123:
    (ALL) NOPASSWD: /usr/lib64/nagios/plugins/*, /usr/bin/systemctl, /usr/bin/jstat, /usr/bin/jq

User ZZZ may run the following commands on 123:
    (ALL) NOPASSWD: ALL

```
