import os

APP_DIR = os.path.dirname(os.path.abspath(__file__))
ASSETS_DIR = os.path.join(APP_DIR, "assets")
IMAGES_DIR = os.path.join(ASSETS_DIR, "images")
I18N_DIR = ASSETS_DIR
MD_DIR = os.path.join(ASSETS_DIR, "localizations", "markdowns")

VERSION = "2.0.4"
APP_ID = "org.dupot.glfos_welcome_screen"

AUTOSTART_DIR = os.path.expanduser("~/.config/autostart")
AUTOSTART_FILE = os.path.join(AUTOSTART_DIR, "glfos-welcome-screen.desktop")

DESKTOP_ENTRY = """\
[Desktop Entry]
Exec=glfos-welcome-screen
Icon=glfos-welcome-screen
Name=Welcome Screen
StartupWMClass=org.dupot.glfos_welcome_screen
Type=Application
Version=1.5

Hidden=true"""

PAGES = [
    {
        "id": "home",
        "menu_key": "menu_home",
        "menu_icon": "glf-logo_menu.png",
        "menu_icon_dark": "glf-logo_menu_dark.png",
        "title_key": "page_home_title",
        "body_key": "page_home_body",
        "image": "glf-logo-128.png",
        "image_dark": "glf-logo-128_dark.png",
        "command": "",
    },
    {
        "id": "gaming",
        "menu_key": "menu_gaming",
        "menu_icon": "gaming_menu.png",
        "title_key": "page_gaming_title",
        "body_key": "page_gaming_body",
        "image": "gaming.png",
        "command": "",
    },
    {
        "id": "studio",
        "menu_key": "menu_studio",
        "menu_icon": "studio_128_menu.png",
        "title_key": "page_studio_title",
        "body_key": "page_studio_body",
        "image": "studio_128.png",
        "command": "",
    },
    {
        "id": "updates",
        "menu_key": "menu_updates",
        "menu_icon": "updates_menu.png",
        "title_key": "page_updates_title",
        "body_key": "page_updates_body",
        "image": "updates.png",
        "command": "",
    },
    {
        "id": "diskmanager",
        "menu_key": "menu_diskManager",
        "menu_icon": "diskmanager_menu.png",
        "title_key": "page_diskmanager_title",
        "body_key": "page_diskmanager_body",
        "image": "diskmanager_128.png",
        "command": "bashWithPrivilege:///run/current-system/sw/bin/nix-disk",
    },
    {
        "id": "easyflatpak",
        "menu_key": "menu_easyflatpak",
        "menu_icon": "easyflatpak_menu.png",
        "title_key": "page_easyflatpak_title",
        "body_key": "page_easyflatpak_body",
        "image": "easyflatpak_128.png",
        "command": "flatpak://org.dupot.easyflatpak",
    },
    {
        "id": "firewall",
        "menu_key": "menu_firewallmanager",
        "menu_icon": "firewallmanager_menu.png",
        "title_key": "page_firewallmanager_title",
        "body_key": "page_firewallmanager_body",
        "image": "firewallmanager_128.png",
        "command": "bashWithPrivilege:///run/current-system/sw/bin/nix-firewall-mngt",
    },
    {
        "id": "sambashare",
        "menu_key": "menu_sambashare",
        "menu_icon": "sambashare_menu.png",
        "title_key": "page_sambashare_title",
        "body_key": "page_sambashare_body",
        "image": "sambashare_128.png",
        "command": "bashWithPrivilege:///run/current-system/sw/bin/glfos-nix-samba",
    },
    {
        "id": "help",
        "menu_key": "menu_help",
        "menu_icon": "help_menu.png",
        "menu_icon_dark": "help_menu_dark.png",
        "title_key": "page_help_title",
        "body_key": "page_help_body",
        "image": "help.png",
        "image_dark": "help_dark.png",
        "command": "",
    },
]
