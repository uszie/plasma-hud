# plasma-hud

Provides a way to run menubar commands through
[`rofi`](https://github.com/davatorium/rofi), much like the Unity 7
Heads-Up Display (HUD). `plasma-hud` was forked from [`mate-hud`](https://github.com/ubuntu-mate/mate-hud) which was based on
[`i3-hud-menu`](https://github.com/RafaelBocquet/i3-hud-menu). There's also a [`gnome-hud`](https://github.com/hardpixel/gnome-hud).

If you are interested in Unity's other feature, locally integrated menus in window titlebars, then you may want to check out the [Material KWin decoration](https://github.com/Zren/material-decoration) which has that feature.

![](https://i.imgur.com/M3YUONc.png)
![](https://i.imgur.com/sE0i8IE.png)

## What is a HUD and why should I care?

A Heads-Up Display (HUD) allows you to search through an application's
appmenu. So if you're trying to find that single filter in Gimp but
can't remember which filter category it fits into or if you can't
recall if preferences sits under File, Edit or Tools on your favourite
browser, you can just search for it rather than hunting through the
menus.

## Install via Package Manager

* AUR: https://aur.archlinux.org/packages/plasma-hud-git/

## Install via GitHub

### Dependencies

#### apt (Kubuntu / KDE Neon)

```
sudo apt install rofi python3 python3-dbus python3-setproctitle python3-xlib gir1.2-gtk-3.0
sudo apt install appmenu-qt # Qt4
sudo apt install appmenu-gtk2-module appmenu-gtk3-module # Gtk2 / Gtk3
```
Or use `unity-gtk2-module unity-gtk3-module` for Gtk2 / Gtk3.

#### pacman (Arch)

```
pacman -S rofi python python-dbus python-setproctitle python-xlib python-gobject gobject-introspection
pacman -S appmenu-gtk-module
```

### Manual Install

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

* Run the following commands to bind the `Alt` keys. For Arch users, you will need `qt5-tools` installed to run `qdbus`.

```
kwriteconfig5 --file ~/.config/kwinrc --group ModifierOnlyShortcuts --key Alt "com.github.zren.PlasmaHUD,/PlasmaHUD,com.github.zren.PlasmaHUD,toggleHUD"
qdbus org.kde.KWin /KWin reconfigure
```

* If you wish to bind to a normal shortcut key like `Menu` or `Alt+F1` then create a new custom global shortcut in the System Settings.
    * System Settings > Shortcuts > Custom Shortcut
    * Edit > New > Global Shorcut > D-Bus Command
    * Trigger > Shortcut: `Menu`
    * Action > Remote application: `com.github.zren.PlasmaHUD`
    * Action > Remote object: `/PlasmaHUD`
    * Action > Function: `toggleHUD`
    * Action > Arguments: Leave it empty

### Manual Uninstall

* Run the following commands to unbind the `Alt` keys.

```
kwriteconfig5 --file ~/.config/kwinrc --group ModifierOnlyShortcuts --key Alt ""
qdbus org.kde.KWin /KWin reconfigure
```

* Uninstall files

```
sudo rm /usr/lib/plasma-hud/plasma-hud
sudo rm /etc/xdg/autostart/plasma-hud.desktop
```

## Settings

If you manally create `~/.config/plasmahudrc` you can change any of the following settings.

```
[General]
Matching=fuzzy
Sort=true
Lines=20

[Icons]
Enabled=true
Theme=breeze-dark

[Shortcuts]
Enabled=true

[Style]
Font=Sans 10
Title=::
Theme=breeze
# place any normal rofi theme in the folder /usr/share/plasma-hud
# The Theme argument must be the same as the theme filename without the .rasi extension.
# At runtime plasma-hud will inject the colors of the current desktop theme into the rasi theme.
# Possible injection values are `<BACKGROUND>`, `<FOREGROUND>`, `<BORDERS>`,
# `<VIEW_BACKGROUND>`, `<DECORATION_FOCUS>` and `<DECORATION_FOCUS_INACTIVE>`.

[Colors]
Background=#111111
Foreground=#eeeff0
SelectedBackground=#062d25
SelectedForeground=#1abc9c
Borders=#000000
ShortcutForeground=#888888
```

* `[General] Matching=fuzzy` can be either `fuzzy` matching or `normal` matching where it matches a keyword exactly. See `man rofi | grep "\-matching" -A20` for more info.

* `[Style] Title=::` will change the `HUD:` prompt text to `:::` which is roughly the width of an icon.

![](https://i.imgur.com/OrDieG2.png)
