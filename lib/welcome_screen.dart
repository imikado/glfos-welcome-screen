import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:glfos_welcome_screen/Api/localization_api.dart';
import 'package:glfos_welcome_screen/View/firewall_view.dart';
import 'package:glfos_welcome_screen/View/gaming_view.dart';
import 'package:glfos_welcome_screen/View/diskmanger_view.dart';
import 'package:glfos_welcome_screen/View/easyflatpak_view.dart';
import 'package:glfos_welcome_screen/View/home_view.dart';
import 'package:glfos_welcome_screen/View/sambashare_view.dart';
import 'package:glfos_welcome_screen/View/studio_view.dart';
import 'package:glfos_welcome_screen/View/updates_view.dart';
import 'package:glfos_welcome_screen/View/help_view.dart';
import 'package:libadwaita/libadwaita.dart';
import 'package:libadwaita_window_manager/libadwaita_window_manager.dart';

import 'package:flutter_gettext/flutter_gettext/context_ext.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen(
      {super.key,
      required this.autostartEnabled,
      required this.themeNotifier,
      required this.autoStartDirPath,
      required this.autoStartFilePath});

  bool autostartEnabled;

  String autoStartDirPath;
  String autoStartFilePath;

  final ValueNotifier<ThemeMode> themeNotifier;

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  static const String version = '1.8.14';

  bool stateIsDebug = true;

  int? _currentIndex = 0;

  bool _showNextTime = true;

  @override
  void initState() {
    super.initState();

    if (kReleaseMode) {
      setState(() => stateIsDebug = false);
    }

    listController = ScrollController();
    settingsController = ScrollController();
    _flapController = FlapController();

    _flapController.addListener(() => setState(() {}));

    load();
  }

  void load() async {
    bool autoStartEnabled = widget.autostartEnabled;

    setState(() {
      _showNextTime = autoStartEnabled;
    });
  }

  void toggleAutostart() async {
    String desktopContent = '''[Desktop Entry]
Exec=glfos-welcome-screen
Icon=glfos-welcome-screen
Name=Welcome Screen
StartupWMClass=org.dupot.glfos_welcome_screen
Type=Application
Version=1.5

Hidden=true''';

    io.File autoStartFile = io.File(widget.autoStartFilePath);

    if (_showNextTime) {
      io.Directory autoStartDirectory = io.Directory(widget.autoStartDirPath);
      if (await !autoStartDirectory.existsSync()) {
        await autoStartDirectory.create(recursive: true);
      }

      if (await autoStartFile.existsSync()) {
        await autoStartFile.delete();
      }
      await autoStartFile.writeAsString(desktopContent);
    } else {
      if (await autoStartFile.existsSync()) {
        await autoStartFile.delete();
      }
    }

    setState(() {
      _showNextTime = !_showNextTime;
    });
  }

  late ScrollController listController;
  late ScrollController settingsController;
  late FlapController _flapController;

  @override
  void dispose() {
    listController.dispose();
    settingsController.dispose();
    super.dispose();
  }

  void changeTheme() =>
      widget.themeNotifier.value = widget.themeNotifier.value == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return AdwScaffold(
        //flapController: _flapController,
        actions: AdwActions().windowManager,
        start: [
          AdwHeaderButton(
            icon: const Icon(Icons.nightlight_round, size: 15),
            onPressed: changeTheme,
          ),
        ],
        end: [Text(version)],
        title: Text(context.translate('app_title')),
        flap: (isDrawer) => AdwSidebar(
              currentIndex: _currentIndex,
              isDrawer: false,
              children: [
                AdwSidebarItem(
                  leading: Image.asset(
                      Theme.of(context).brightness == Brightness.dark
                          ? 'assets/images/glf-logo_menu_dark.png'
                          : 'assets/images/glf-logo_menu.png'),
                  label: context.translate('menu_home'),
                ),
                AdwSidebarItem(
                  leading: Image.asset('assets/images/gaming_menu.png'),
                  label: context.translate('menu_gaming'),
                ),
                AdwSidebarItem(
                  leading: Image.asset('assets/images/studio_128_menu.png'),
                  label: context.translate('menu_studio'),
                ),
                AdwSidebarItem(
                  leading: Image.asset('assets/images/updates_menu.png'),
                  label: context.translate('menu_updates'),
                ),
                AdwSidebarItem(
                  leading: Image.asset('assets/images/diskmanager_menu.png'),
                  label: context.translate('menu_diskManager'),
                ),
                AdwSidebarItem(
                  leading: Image.asset('assets/images/easyflatpak_menu.png'),
                  label: context.translate('menu_easyflatpak'),
                ),
                AdwSidebarItem(
                  leading:
                      Image.asset('assets/images/firewallmanager_menu.png'),
                  label: context.translate('menu_firewallmanager'),
                ),
                AdwSidebarItem(
                  leading: Image.asset('assets/images/sambashare_menu.png'),
                  label: context.translate('menu_sambashare'),
                ),
                AdwSidebarItem(
                  leading: Image.asset(
                      Theme.of(context).brightness == Brightness.dark
                          ? 'assets/images/help_menu_dark.png'
                          : 'assets/images/help_menu.png'),
                  label: context.translate('menu_help'),
                ),
              ],
              onSelected: (index) => setState(() => _currentIndex = index),
            ),
        body: Column(children: [
          Expanded(
              child: AdwViewStack(
            animationDuration: const Duration(milliseconds: 100),
            index: _currentIndex,
            children: [
              const HomeView(),
              const GamingView(),
              const StudioView(),
              const UpdatesView(),
              const DiskmanagerView(),
              const EasyflatpakView(),
              const FirewallView(),
              const SambashareView(),
              const HelpView(),
            ],
          )),
          const Divider(height: 1),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: _showNextTime,
              onChanged: (value) async {
                if (value != null) toggleAutostart();
              },
              title: Text(context.translate('bottom_show_window_next_time')),
            ),
          ),
        ]));
  }
}
