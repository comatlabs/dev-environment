'snap install kubectl --classic':
  cmd.run

'snap install microk8s --classic':
  cmd.run

'ufw allow in on cni0 && sudo ufw allow out on cni0':
  cmd.run

'ufw default allow routed':
  cmd.run

'export LC_ALL=C.UTF-8 && export LANG=C.UTF-8 && microk8s enable dns dashboard storage ingress':
  cmd.run

'usermod -a -G microk8s ubuntu':
  cmd.run

'chown -f -R ubuntu ~/.kube':
  cmd.run
