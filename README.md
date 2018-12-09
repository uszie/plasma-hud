# plasma-hud

Provides a way to run menubar commands through
[rofi](https://davedavenport.github.io/rofi/), much like the Unity 7
Heads-Up Display (HUD). `plasma-hud` was forked from `mate-hud` which was based on
`i3-hud-menu`.

  * https://jamcnaughton.com/2015/10/19/hud-for-xubuntu/
  * https://github.com/jamcnaughton/i3-hud-menu
  * https://github.com/RafaelBocquet/i3-hud-menu
  * https://github.com/ubuntu-mate/mate-hud
  * https://github.com/hardpixel/gnome-hud

![](https://i.imgur.com/94nih11.png)

## What is a HUD and why should I care?

A Heads-Up Display (HUD) allows you to search through an application's
appmenu. So if you're trying to find that single filter in Gimp but
can't remember which filter category it fits into or if you can't
recall if preferences sits under File, Edit or Tools on your favourite
browser, you can just search for it rather than hunting through the
menus.

### Manual Setup

* Either use the Global Menu widget, or add the App Menu button in to the titlebar.
* Download `plasma-hud`

```
git clone https://github.com/Zren/plasma-hud
cd plasma-hud
```

* Install files

```
sudo mkdir -p /usr/lib/plasma-hud
sudo cp usr/lib/plasma-hud/plasma-hud /usr/lib/plasma-hud/
sudo mkdir -p /etc/xdg/autostart
sudo cp etc/xdg/autostart/plasma-hud.desktop /etc/xdg/autostart/
```

* Either run the script in the terminal for plasma-hud to work in your current session. Or relog since it should now autostart the next time you login.

```
/usr/lib/plasma-hud/plasma-hud
```

* Run the following commands to bind the `Alt` keys.

```
kwriteconfig5 --file ~/.config/kwinrc --group ModifierOnlyShortcuts --key Alt "com.github.zren.PlasmaHUD,/PlasmaHUD,com.github.zren.PlasmaHUD,toggleHUD"
qdbus org.kde.KWin /KWin reconfigure
```

## Dependencies

  * `appmenu-qt`
  * `gir1.2-gtk-3.0`
  * `mate-desktop`
  * `python3`
  * `python3-dbus`
  * `python3-setproctitle`
  * `python3-xlib`
  * `rofi`
  * `unity-gtk2-module`
  * `unity-gtk3-module`

### Settings

If you manally create `~/.config/plasmahudrc` you can change any of the following settings.

```
[Style]
Font=Sans 10

[Colors]
Background=#111111
Foreground=#eeeff0
SelectedBackground=#062d25
SelectedForeground=#1abc9c
ErrorBackground=#000000
ErrorForeground=#000000
InfoBackground=#000000
InfoForeground=#000000
Borders=#000000
```

![](https://i.imgur.com/6ncDtWt.png)
