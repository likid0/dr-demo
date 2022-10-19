echo "Patching drcluster to fence worker nodes"
oc patch drcluster cluster1 --type json -p "[{'op': 'add', 'path': '/spec/clusterFence', 'value': 'Fenced'}]"
sleep 45
if [ $(oc get drcluster.ramendr.openshift.io cluster1 -o jsonpath='{.status.phase}{"\n"}') = 'Fenced' ]
then
    echo "Starting to relocate application"
    oc patch drpc rocketchat-placement-1-drpc  --type json -p "[{'op': 'add', 'path': '/spec/failoverCluster', 'value': "cluster2"}]" -n rocketchat
    oc patch drpc rocketchat-placement-1-drpc  --type json -p "[{'op': 'add', 'path': '/spec/action', 'value': 'Failover'}]" -n rocketchat
else
    echo "cluster not fenced, exit"
fi