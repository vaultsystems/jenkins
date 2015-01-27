set +e
OS_TENANT_NAME="jns_monkeys"

for i in $(seq $START_ID $STOP_ID); do 
nova reboot troop$i;
sleep $TROOP_INTERVAL;
done

for i in $(seq $START_ID $STOP_ID); do
nova reboot zookeeper$i;
sleep $ZK_INTERVAL;
done
