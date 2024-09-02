#!/bin/bash

HOSTLIST="hostlist.txt"
SUDORULES="sudo-rules-for-users.txt"
TIMEOUT="zeitüberschreistung.txt"
SSH_CONNECT_TIMEOUT=15

# Leert die Dateien, falls sie bereits existieren/befüllt sind
> "$SUDORULES"
> "$TIMEOUT"

# Baue SSH Verbindung zum Host auf
for host in $(cat "$HOSTLIST"); do
  echo "Verbindung zu $host ..."
  echo -e "\n_________________________________________\n\nhost: $host \n_________________________________________" >> $SUDORULES
  ssh_connection="ssh -o StrictHostKeyChecking=accept-new -o ConnectTimeout=$SSH_CONNECT_TIMEOUT $host"
  
  # Erfasse die Benutzer und ihre sudo-Regeln in einer SSH-Sitzung - ausgehend vom Host, der gerade analysiert wird
  user_and_sudo=$($ssh_connection 'users=$(getent passwd | awk -F":" "{print \$1}" | grep -v -E "^(root|adm|bin|daemon|sync|lp|shutdown|halt|mail|operator|games|ftp|nobody|dbus|polkitd|unbound|sssd|sshd)$" );

    for user in $users; do
      sudo_rules=$(sudo -lU "$user" | grep -v "not allowed to run sudo");
      if [ -n "$sudo_rules" ]; then
        echo "$sudo_rules";
      fi;
    done;
  ')

  if [ $? -ne 0 ]; then
    echo -e "\n***Fehler*** Zeitüberschreitung bei der Verbindung zu $host.\n\n" >> $TIMEOUT
  else
    echo "$user_and_sudo" >> "$SUDORULES"
  fi

  echo -e "\n\n***HOST $host ABGESCHLOSSEN*** Sudo-Regeln in $SUDORULES gelistet.\n\n"

done

echo -e "\n***FERTIG*** Alle Sudo-Regeln der Benutzer wurden in $SUDORULES gelistet."
