gui.packages:
  pkg.installed:
    - pkgs:
      - xubuntu-desktop
      - tigervnc-standalone-server

'mkdir -p /home/ubuntu/.vnc && printf "ubuntu\nubuntu\n\n\n" | vncpasswd':
  cmd.run:
    - runas: ubuntu

/etc/systemd/system/vncserver@.service:
  file.managed:
      - source: salt://vncserver@.service

'printf "#!/bin/sh\nstartxfce4\n" > /home/ubuntu/.vnc/xstartup && chmod +x /home/ubuntu/.vnc/xstartup':
  cmd.run

'systemctl daemon-reload && systemctl enable vncserver@1.service':
  cmd.run

xfconf-query -c xsettings -p /Gdk/WindowScalingFactor -s 2:
  cmd.run

xfconf-query -c xfwm4 -p /general/theme -s Default-xhdpi:
  cmd.run

'chown -R ubuntu:ubuntu /home/ubuntu':
  cmd.run
