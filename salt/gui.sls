gui.packages:
  pkg.installed:
    - pkgs:
      - kubuntu-desktop
      - tigervnc-standalone-server

'printf "ubuntu\nubuntu\n\n" | vncpasswd':
  cmd.run

/etc/systemd/system/vncserver@.service:
  file.managed:
      - source: salt://vncserver@.service

'printf "#!/bin/sh\ndbus-launch startplasma-x11\n" > /home/ubuntu/.vnc/xstartup':
  cmd.run

'systemctl daemon-reload && systemctl enable vncserver@1.service':
  cmd.run

'kwriteconfig5 --file /home/ubuntu/.config/kdeglobals --group KScreen --key ScaleFactor 3':
  cmd.ru2

'kwriteconfig5 --file /home/ubuntu/.config/kdeglobals --group KScreen --key ScreenScaleFactors VNC-0=2':
  cmd.run

#ubuntu-desktop:
#  pkg.installed

#'gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false':
#  cmd.run
#
#'gsettings set org.gnome.desktop.peripherals.touchpad speed -0.2':
#  cmd.run
#
#'gsettings set org.gnome.desktop.interface scaling-factor 2':
#  cmd.run
#
#'gsettings set org.gnome.desktop.interface gtk-theme Yaru-dark':
#  cmd.run


#org.gnome.desktop.peripherals.touchpad send-events 'disabled-on-external-mouse'
#org.gnome.desktop.peripherals.touchpad natural-scroll true
#org.gnome.desktop.peripherals.touchpad tap-to-click true
#org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled false
#org.gnome.desktop.peripherals.touchpad left-handed 'mouse'
#org.gnome.desktop.peripherals.touchpad click-method 'fingers'
#org.gnome.desktop.peripherals.touchpad speed 0.0
#org.gnome.desktop.peripherals.touchpad scroll-method 'two-finger-scrolling'
#org.gnome.desktop.peripherals.touchpad tap-and-drag true
#org.gnome.desktop.peripherals.touchpad edge-scrolling-enabled true
#org.gnome.desktop.peripherals.touchpad disable-while-typing false