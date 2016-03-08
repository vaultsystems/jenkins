#!/bin/bash -x
OS_TENANT_NAME="jns_monkeys"
TROOP_IMAGE=`glance image-list | grep "Windows 2012 R2 autobuild" | sort -u -k8 | tail -1 | awk '{ print $2}'`
ZK_IMAGE=`glance image-list | grep "puppetclient" | head -1 | awk '{ print $2}'`
NET=d9e502bb-b6ca-4a5c-8eb6-3e3473bf7082

for i in $(seq $START_ID $STOP_ID); do
nova boot --flavor m1.fortigate --availability-zone nova --block-device source=image,id=$ZK_IMAGE,dest=volume,size=3,shutdown=remove,bootindex=0 --nic net-id=$NET --key-name monkey_pm zookeeper$i;
sleep $ZK_INTERVAL;
nova boot --flavor m1.large --availability-zone nova --block-device source=image,id=$TROOP_IMAGE,dest=volume,size=25,shutdown=remove,bootindex=0 --nic net-id=$NET troop$i;
sleep $TROOP_INTERVAL;
done

nova list | grep ERROR
if [[ $? == 0 ]]; then exit 1; fi
