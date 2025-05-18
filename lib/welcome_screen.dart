import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:glfos_welcome_screen/Api/localization_api.dart';
import 'package:glfos_welcome_screen/View/baseProcess_view.dart';
import 'package:glfos_welcome_screen/View/desktopselector_view.dart';
import 'package:glfos_welcome_screen/View/diskmanger_view.dart';
import 'package:glfos_welcome_screen/View/easyflatpak_view.dart';
import 'package:glfos_welcome_screen/View/home_view.dart';
import 'package:glfos_welcome_screen/View/usefulinformation_view.dart';
import 'package:libadwaita/libadwaita.dart';
import 'package:libadwaita_window_manager/libadwaita_window_manager.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key, required this.themeNotifier});

  final ValueNotifier<ThemeMode> themeNotifier;

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  String stateLanguageSelected = LocalizationApi().languageCode;

  bool stateIsDebug = true;

  int? _currentIndex = 0;

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
      widget.themeNotifier.value = widget.themeNotifier.value == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;

  final List<String> options = LocalizationApi.languages();

  @override
  Widget build(BuildContext context) {
    return AdwScaffold(
      flapController: _flapController,
      actions: AdwActions().windowManager,
      start: [
        AdwHeaderButton(
          icon: const Icon(Icons.view_sidebar_outlined, size: 19),
          isActive: _flapController.isOpen,
          onPressed: () => _flapController.toggle(),
        ),
        AdwHeaderButton(
          icon: const Icon(Icons.nightlight_round, size: 15),
          onPressed: changeTheme,
        ),
        DropdownButton<String>(
          value: stateLanguageSelected,
          items: options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(LocalizationApi().tr("lang_$value")),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              LocalizationApi().setLanguageCode(newValue);

              setState(() {
                stateLanguageSelected = newValue;
              });
            }
          },
        ),
      ],
      title: Text(LocalizationApi().tr('app_title')),
      flap: (isDrawer) => AdwSidebar(
        currentIndex: _currentIndex,
        isDrawer: isDrawer,
        children: [
          AdwSidebarItem(
            label: LocalizationApi().tr('menu_home'),
          ),
          AdwSidebarItem(
            label: LocalizationApi().tr('menu_baseProcess'),
          ),
          AdwSidebarItem(
            label: LocalizationApi().tr('menu_desktopSelector'),
          ),
          AdwSidebarItem(
            label: LocalizationApi().tr('menu_diskManager'),
          ),
          AdwSidebarItem(
            label: LocalizationApi().tr('menu_easyflatpak'),
          ),
          AdwSidebarItem(
            label: LocalizationApi().tr('menu_usefulInformation'),
          ),
        ],
        onSelected: (index) => setState(() => _currentIndex = index),
      ),
      body: AdwViewStack(
        animationDuration: const Duration(milliseconds: 100),
        index: _currentIndex,
        children: [
          const HomeView(),
          const BaseProcessView(),
          const DesktopselectorView(),
          const DiskmangerView(),
          const EasyflatpakView(),
          const UsefulinformationView()
        ],
      ),
    );
  }
}
