#!/usr/bin/env bash

rm ./multipass.log 2> /dev/null
multipass launch -c 6 -d 128G -m 8G --name dev --cloud-init cloud-config.yaml > >(tee -a ./multipass.log) 2> >(tee -a ./multipass.log)
if [ $? ]; then
  if grep timed ./multipass.log > /dev/null; then
    echo "Initialization often takes longer than multipass allows..."
  else
    echo "Multipass failed.  Quitting."
    exit 1
  fi
fi

wait_for_shutdown (){
  count=0
  while [ $count -lt 3 ]
    do
      if powershell Get-Vm -Name dev | grep 'Off' > /dev/null; then
        echo "vm is off, waiting for possible reboot: " $count "/3"
        count=$((count+1))
      else
        if [ $count -ne 0 ]; then
          echo "...must have been a reboot, resuming wait."
          count=0
        fi
        printf "."
      fi
      sleep 10
    done
  printf "\n"
}

echo $(date)
echo "Waiting 20m for VM to finish cloud-init and shut down."
export -f wait_for_shutdown
timeout 20m bash -c wait_for_shutdown

if ! powershell Get-Vm -Name dev | grep 'Off' > /dev/null; then
  echo "Timed out waiting for VM to halt. Quitting."
  exit 1
else
#  echo "Configuring VM..."
#  echo "Enabling Hyper-V extensions."
#  powershell set-vm dev -enhancedsessiontransporttype hvsocket
#  powershell Enable-VMIntegrationService -VMName dev -Name \"Guest Service Interface\"
  echo "Starting VM."
  powershell Start-VM -Name dev
  echo "Done!"
fi
