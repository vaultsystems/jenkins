set +e -x
OS_TENANT_NAME="jns_monkeys"

for i in $(seq $START_ID $STOP_ID); do 
nova reboot troop$i;
sleep $TROOP_INTERVAL;
nova reboot zookeeper$i;
done
