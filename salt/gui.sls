gui.packages:
  pkg.installed:
    - pkgs:
      - kubuntu-desktop
      - tigervnc-standalone-server

'mkdir -p /home/ubuntu/.vnc && printf "ubuntu\nubuntu\n\n\n" | vncpasswd':
  cmd.run:
    - runas: ubuntu

/etc/systemd/system/vncserver@.service:
  file.managed:
      - source: salt://vncserver@.service

'printf "#!/bin/sh\ndbus-launch startplasma-x11\n" > /home/ubuntu/.vnc/xstartup && chmod +x /home/ubuntu/.vnc/xstartup':
  cmd.run

'systemctl daemon-reload && systemctl enable vncserver@1.service':
  cmd.run

'kwriteconfig5 --file /home/ubuntu/.config/kdeglobals --group KScreen --key ScaleFactor 2':
  cmd.run

'kwriteconfig5 --file /home/ubuntu/.config/kdeglobals --group KScreen --key ScreenScaleFactors VNC-0=2':
  cmd.run

'chown -R ubuntu:ubuntu /home/ubuntu':
  cmd.run
