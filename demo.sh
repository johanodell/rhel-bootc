#!/usr/bin/env bash

#################################
# include the -=magic=-
# you can pass command line args
#
# example:
# to disable simulated typing
# . ../demo-magic.sh -d
#
# pass -h to see all options
#################################
. ../utils/demo-magic.sh
DEMO_PROMPT="${GREEN}➜${CYAN}[bootc]$ ${COLOR_RESET}"
TYPE_SPEED=20
USE_CLICKER=true

# Define colors
BLUE='\033[38;2;102;204;255m' #'\033[38;5;153m' #'\033[0;34m'
GREEN='\033[38;5;41m' #'\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

# Function to print lines with color based on their content
print_colored_output() {
    while IFS= read -r line; do
        if [[ $line == skipping:* || $line == included:* ]]; then
            echo -e "${BLUE}${line}${RESET}"
        elif [[ $line == ok:* ]]; then
            echo -e "${GREEN}${line}${RESET}"
        elif [[ $line == changed:* ]]; then
            echo -e "${YELLOW}${line}${RESET}"
        else
            echo "$line"
        fi
    done
}

# login to registries

# Hide the evidence
clear

# Enter the ansible directory
wait
figlet -f starwars -S "demo!"
wait
export COWPATH=/usr/share/cows
cowsay "Soo, we are going to create a VM of a containerfile. 
Step 1 is to create the container image"
wait
echo -e "\n"
viu pictures/process.png
echo -e "\n"
wait
pei "tree"
echo -e "\n"
wait 
pei "cat Containerfile"
echo -e "\n"
wait
cowsay "lets build the container image"
echo -e "\n"
pei "podman build -t rhel10-bootc:v1 ."
echo -e "\n"
wait
pei "podman images"
echo -e "\n"
wait
pei "podman tag localhost/rhel10-bootc:v1 quay.io/codell/rhel10-bootc:v1"
echo -e "\n"
wait
pei "podman push quay.io/codell/rhel10-bootc:v1"
echo -e "\n"
wait
redhatsay "With AAP Operator we can configure the AAP components 
declaratively with manifests"
wait
pei "ls -l ../ansible/manifests"
wait
echo -e "\n"
wait
redhatsay "The majority of things are configured, 
but let's have a look at a JobTemplate"
wait
pe "highlight ../ansible/manifests/7.job-template-deploy-vm.yaml"
echo -e "\n"
wait
redhatsay "Now, let's apply a few ansible resources"
wait
pi "oc apply -f ../ansible/manifests/7.job-template-deploy-vm.yaml -f ../ansible/manifests/9.job-template-register-vms.yaml"
sleep 1
echo '
jobtemplate.tower.ansible.com/deploy-vm created'
sleep 1
echo 'jobtemplate.tower.ansible.com/register-vms created'
echo -e "\n"
sleep 1
echo "# AAP is configured by applying manifests, lets move on" | lolcat
wait
clear
redhatsay "Before we start building VMs... how do we create images with Ansible?"
wait
viu ../pics/AAP_image_builder_1.png
echo -e "\n"
echo -e "\n"
wait
viu ../pics/AAP_image_builder_2.png
echo -e "\n"
echo -e "\n"
wait
redhatsay "This is how an image blueprint is structured" 
wait
highlight -O ansi ../hardened_xccdf_org.ssgproject.content_profile_pci-dss.toml | less -R
wait
clear
redhatsay "Let's create a project for the vms"
pi "oc new-project virt-corp-vms"
sleep 1
echo '
Now using project "virt-corp-vms" on server "https://api.cluster-jl6vp.dynamic.redhatworkshops.io:6443".

You can add applications to this project with the 'new-app' command. For example, try:

    oc new-app rails-postgresql-example

to build a new example application in Ruby. Or use kubectl to deploy a simple Kubernetes application:

    kubectl create deployment hello-node --image=registry.k8s.io/e2e-test-images/agnhost:2.43 -- /agnhost serve-hostname
 '
echo -e "\n"
wait
redhatsay "Let's look at the VM provisioning workflow" 
wait
wait
viu ../pics/provisioning_workflow.png
wait
clear
echo "# This is how the workflow-jobtemplate in ansible looks like" | lolcat
viu ../pics/AAP_workflow_template.png
wait
redhatsay "Ok, Let's start our ansible workflow jobtemplate 
- deploy a vm and and add Insights compliance profile"
wait
p "awx --conf.host https://aap-controller-aap.apps.mothershift.codell.io --conf.token \$AAP_TOKEN workflow_job_templates launch 68 -f human"
sleep 1
echo '
id   name                                 
==== ==================================== 
1448 deploy vm and add compliance profile
'
sleep 2
gum spin --title "Doing some timetravel while cloning boot source and deploying VM" sleep 3
pei ""
wait
pi "oc get vmi"
sleep 1
echo '
NAME              AGE   PHASE     IP             NODENAME   READY
payments-app-d4   23s   Running   10.128.1.159   endor      True
'
pei ""
wait
redhatsay "Ok, now we will take a look at the last part
of the provisioning workflow"
wait
pi "awx --conf.host https://aap-controller-aap.apps.mothershift.codell.io --conf.token \$AAP_TOKEN jobs stdout 1453 -f human"
sleep 0.5
echo '
PLAY [Assign Compliance Profile to New VM] *************************************
' 
sleep 1
echo '
TASK [Retrieve Bearer token using uri module] **********************************
ok: [localhost]
' | print_colored_output
sleep 0.5
echo '
TASK [Fail if token retrieval failed] ******************************************
skipping: [localhost]
' | print_colored_output
sleep 1
echo '
TASK [Set access_token fact] ***************************************************
ok: [localhost]
' | print_colored_output
sleep 1
echo '
TASK [Get Inventory from Red Hat Insights ] ************************************
ok: [localhost]
' | print_colored_output
sleep 0.5
echo '
TASK [Fail if inventory retrieval failed] **************************************
skipping: [localhost]
' | print_colored_output
sleep 1
echo '
TASK [Extract host UUID for the given vm_name] *********************************
ok: [localhost]
' | print_colored_output
sleep 0.5
echo '
TASK [Fail if VM not found in inventory] ***************************************
skipping: [localhost]
' | print_colored_output
sleep 2
echo '
TASK [Fetch available compliance profiles] *************************************
ok: [localhost]
' | print_colored_output
sleep 0.2
echo '
TASK [Fail if compliance profiles retrieval failed] ****************************
skipping: [localhost]
' | print_colored_output
sleep 1
echo '
TASK [Set compliance profile ID based on selected_profile_name] ****************
ok: [localhost]
' | print_colored_output
sleep 0.3
echo '
TASK [Fail if selected compliance profile not found] ***************************
skipping: [localhost]
' | print_colored_output
sleep 1.5
echo '
TASK [Fetch current hosts assigned to the selected profile] ********************
ok: [localhost]
' | print_colored_output
sleep 0.6
echo '
TASK [Fail if profile hosts retrieval failed] **********************************
skipping: [localhost]
' | print_colored_output
sleep 1
echo '
TASK [Set fact for existing hosts in profile] **********************************
ok: [localhost]
' | print_colored_output
sleep 1
echo '
TASK [Add the new host to the current list of hosts] ***************************
ok: [localhost]
' | print_colored_output
sleep 1
echo '
TASK [Assign compliance profile with the updated host list] ********************
ok: [localhost]
' | print_colored_output
sleep 1
echo '
TASK [Fail if profile assignment failed] ***************************************
skipping: [localhost]
' | print_colored_output
sleep 1
echo '
TASK [Confirm Compliance Profile Assignment] ***********************************
ok: [localhost] => {
    "msg": "Compliance profile 'PCI-DSS v4.0 Control Baseline for Red Hat Enterprise Linux 9' has been assigned to VM 'payments-app-d4'."
}
' | print_colored_output
sleep 1
echo '
PLAY RECAP *********************************************************************
localhost                  : ok=11   changed=0    unreachable=0    failed=0    skipped=7    rescued=0    ignored=0
' | print_colored_output

wait
redhatsay "Looks good, let's check the insights interface"
wait
open 'https://console.redhat.com/insights/compliance/systems/ab2217b1-acaf-40e6-a6dc-51a23d8ba5ff'
pei ""
wait
clear
redhatsay "Let's summarize"
wait
viu ../pics/summary.png
echo -e "\n"
echo -e "\n"
wait
viu ../pics/wantoknowmore.png
wait
viu ../pics/openshift-dadjoke.png
wait
viu ../pics/fin.png
wait


set -o errexit
DEMO_PROMPT="${GREEN}➜ ${CYAN}bootc{GREEN}$"
clear
wait
export TERM=xterm-kitty
figlet -f starwars -S "Demo"
wait
clear 
viu pictures/build.jpg
clear
pei "tree"
wait
pei "cat Containerfile"
#redhatsay "lets start the presentation"
#pe "cat pipelinerun.yaml | gum format -t code -l yaml"
#p "oc create -f pipelinerun.yaml"
#PIPELINERUN=$(oc get pipelineruns.tekton.dev -o name)
#echo $PIPELINERUN
#pe "tkn pipelinerun describe"
#redhatsay 'Let`s look at the Sysprep TaskRun'
#SYSPREP=$(oc get taskruns.tekton.dev -l tekton.dev/pipelineTask=sysprep-image -o jsonpath='{.items[0].metadata.name}')
#pe "tkn taskrun describe $SYSPREP"
#pe "tkn taskrun logs -f $SYSPREP"
#redhatsay 'That was the Sysprep TaskRun'
#pe clear
#DEMO_PROMPT="${GREEN}➜ ${CYAN}Virtctl${GREEN} $ "
#redhatsay 'Let`s run virtctl to ssh into a VM on the pod network'
#redhatsay -t "What vms are available?"
#pe "oc get vmi"
#redhatsay 'Let`s use virtctl ssh into the hel9-3-golden-datasource-electronic-crow VM'
#pe "virtctl -n vms ssh rhel9-3-golden-datasource-electronic-crow  -l cloud-user"
#pe clear
#DEMO_PROMPT="${GREEN}➜ ${CYAN}introduction${GREEN} $ "
#redhatsay "Using OpenShift Virtualization to run a hosted cluster" "Hosted Control Planes are based on the upstream Hypershift project"
#viu ../pictures/frontpage.png
#pe clear
#redhatsay "lets start the presentation"
#pe viu ../pictures/vms_containers.png
#redhatsay 'Let`s create a new hosted cluster'
#pe "oc get nodes"
#redhatsay "Yes we are runing on a Single Node OpenShift Cluster" -v -t
#export CLUSTER_NAME="hosted"
#export PULL_SECRET="pull-secret.json"
#export MEM="6Gi"
#export CPU="2"
#export WORKER_COUNT="2"
#export BASE_DOMAIN=clusters.blahonga.me
#export OCP_VERSION=quay.io/openshift-release-dev/ocp-release:4.14.8-multi
#p "hypershift create cluster kubevirt \
#    --name $CLUSTER_NAME \
#    --pull-secret ${PULL_SECRET}  \
#    --node-pool-replicas 2 \
#    --cores 2 \
#    --memory 8Gi \
#    --auto-repair \
#    --root-volume-size 50 \
#    --release-image ${OCP_VERSION} \
#    --base-domain ${BASE_DOMAIN} \
#    --additional-network="name:default/vlan202" \
#    --attach-default-network=false \
#    --ssh-key ~/.ssh/id_ed25519.pub"
#redhatsay "The cluster is now being created..."
#gum spin --title "creating cluster, nodes, pods and lots of things" --title.foreground="111"  sleep 5
#redhatsay "The cluster is now ready"
#pe "oc get hostedclusters.hypershift.openshift.io -A"
#redhatsay "The cluster has created a new nodepool with the kubevirt provider"
#pe "oc get nodepools.hypershift.openshift.io -A"
#redhatsay "The control plane is running as pods in the clusters-hosted namespace"
#pe "oc get pods -n clusters-hosted"
#redhatsay -t -v "The virtualized nodes are running in the clusters-hosted namespace"
#pe "oc get vmi -n clusters-hosted"
#redhatsay "The kubeapi is accessible using a loadbalancer"
#pe "oc get svc  -n clusters-hosted | grep LoadBalancer"
#redhatsay 'Let`s use the hosted cluster by getting the cluster kubeconfig'
#pe "hypershift create kubeconfig --name ${CLUSTER_NAME} > /tmp/${CLUSTER_NAME}-kubeconfig"
#redhatsay 'Now we can use the kubeconfig to access the cluster, for example to get the nodes'
#pe "KUBECONFIG=/tmp/${CLUSTER_NAME}-kubeconfig oc get nodes"
#redhatsay "The hosted cluster is now ready for use"
