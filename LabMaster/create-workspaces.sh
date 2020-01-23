#!/bin/bash
#
# account running this script should have sudo group 
# 
if [ "$#" -ne 5 ] ; then
  echo "Usage: $0 Packet-Auth-Token Packet-Project-ID Number-Workspaces-To-Create Facility" >&2
  exit 1
fi

#must be lower case since usernames must be lowercase
LAB_NAME="flatcar"

PACKET_AUTH_TOKEN="$1"
PACKET_PROJECT_ID="$2"
NUMBER_WORKSPACES="$3"
FACILITY="$4"

echo PACKET_AUTH_TOKEN=$PACKET_AUTH_TOKEN
echo PACKET_PROJECT_ID=$PACKET_PROJECT_ID
echo NUMBER_WORKSPACES=$NUMBER_WORKSPACES
echo FACILITY=$FACILITY

rm -rf ContainerLinuxOnBareMetal/
git clone https://github.com/packet-labs/ContainerLinuxOnBareMetal
cd ContainerLinuxOnBareMetal/

# Terraform needs access to these to install plugins
chmod 755 ~root
touch ~root/.netrc
chmod 777 ~root/.netrc

for i in `seq -w 01 $NUMBER_WORKSPACES`
do
  # setup the new student account
  USER=$LAB_NAME$i
  echo "Creating $USER"
  #  encrypted password is openstack
  sudo useradd -d /home/$USER -p $(echo "flatcar" | openssl passwd -1 -stdin) -s /bin/bash $USER 
  sudo mkdir /home/$USER
  sudo chown $USER.sudo /home/$USER
  sudo chmod 2775 /home/$USER

  echo ""                                       >  Workspace/terraform.tfvars
  echo packet_auth_token=\"$PACKET_AUTH_TOKEN\" >> Workspace/terraform.tfvars
  echo packet_project_id=\"$PACKET_PROJECT_ID\" >> Workspace/terraform.tfvars
  echo lab_number=\"$i\"                        >> Workspace/terraform.tfvars
  echo lab_name=\"$USER\"                       >> Workspace/terraform.tfvars
  echo facility=\"$FACILITY\"                   >> Workspace/terraform.tfvars


  # copy over the student files from the base template
  sudo -u $USER cp -r Workspace /home/$USER/
  pushd /home/$USER/Workspace
  sudo -u $USER ssh-keygen -t ed25519 -f /home/$USER/.ssh/id_ed25519  -q -N ""
  sudo -u $USER cp /home/$USER/.ssh/id_ed25519 /home/$USER/Workspace/mykey
  sudo -u $USER cp /home/$USER/.ssh/id_ed25519.pub /home/$USER/Workspace/mykey.pub
  sudo chmod g+w .
  sudo chmod 400 /home/$USER/.ssh/id_ed25519
  sudo touch terraform.tfstate
  sudo chown $USER.sudo terraform.tfstate
  sudo -u $USER terraform init
  screen -dmS $USER-terraform-apply terraform apply -auto-approve
  popd
  # pause to prevent overloading deployments
  sleep 20
done

cat <<EOF >> /etc/ssh/sshd_config
Match user $LAB_NAME*
  PasswordAuthentication yes
EOF
service sshd restart
