#!/bin/bash -x
OS_TENANT_NAME="jns_monkeys"
SSH="ssh -o StrictHostKeyChecking=no $PM sudo"

rm ~/.ssh/known_hosts
$SSH /etc/init.d/apache2 stop
for i in $(seq $START_ID $STOP_ID); do
  nova list | grep -e zookeeper$i -e troop$i | awk '{print $2}' | xargs nova delete
  $SSH puppet cert clean troop$i.vaultsystems
  $SSH puppet cert clean zookeeper$i.vaultsystems
done
$SSH rm /var/lib/puppet/ssl/ca/requests/* /var/log/puppet/*
$SSH timeout 5 puppet master --no-daemonize --verbose
$SSH /etc/init.d/apache2 start

nova list | grep ERROR
if [[ $? == 0 ]]; then exit 1; fi
