rm ./multipass.log
multipass launch -c 6 -d 50G -m 4G --name dev --cloud-init cloud-config.yaml > >(tee -a ./multipass.log) 2> >(tee -a ./multipass.log >&2)
if [ $? ]; then
  if grep timed ./multipass.log; then
    echo "Initialization often takes longer than multipass allows..."
  else
    echo "Multipass failed.  Quitting."
    exit 1
  fi
fi

wait_for_shutdown (){
  set -o pipefail
  while ! powershell Get-Vm -Name dev | grep 'Off'
    do
      echo "VM still running, retry in 5s"
      sleep 5
    done
  set +o pipefail
}

echo "Waiting 5m for VM to halt."
export -f wait_for_shutdown
timeout 5m bash -c wait_for_shutdown

if powershell Get-Vm --Name dev | grep Off; then
  echo "Timed out waiting for VM to halt. Quitting."
  exit 1
else
  echo "Configuring VM."
  powershell set-vm dev -enhancedsessiontransporttype hvsocket
  powershell Enable-VMIntegrationService -VMName dev -Name \"Guest Service Interface\"
  powershell Start-VM -Name dev
  echo "Done!"
fi
