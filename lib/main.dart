import 'dart:async';
import 'dart:io' as io;

import 'package:adwaita/adwaita.dart';
import 'package:flutter/material.dart';
import 'package:glfos_welcome_screen/Api/localization_api.dart';
import 'package:glfos_welcome_screen/welcome_screen.dart';
import 'package:window_manager/window_manager.dart';

import 'package:flutter_gettext/flutter_gettext/gettext_localizations_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:package_info_plus/package_info_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();
  await windowManager.hide();

  const windowOptions = WindowOptions(
    size: Size(1000, 600),
    minimumSize: Size(800, 350),
    skipTaskbar: false,
    backgroundColor: Colors.transparent,
    titleBarStyle: TitleBarStyle.hidden,
    title: 'Welcome screen',
  );

  await windowManager.waitUntilReadyToShow(windowOptions);

  await windowManager.setAsFrameless();

  await windowManager.show();
  await windowManager.focus();

  bool isStartupEnabled = true;

  io.Directory autoStartDir = io.Directory(getAutoStartDirPath());
  if (autoStartDir.existsSync()) {
    io.File autoStartFile = io.File(getAutoStartFilePath());
    if (autoStartFile.existsSync()) {
      isStartupEnabled = false;
    }
  }

  runApp(MyApp(autostartEnabled: isStartupEnabled));
}

String getAutoStartDirPath() {
  final home = io.Platform.environment['HOME'] ?? '';
  return '$home/.config/autostart';
}

String getAutoStartFilePath() {
  return getAutoStartDirPath() + '/glfos-welcome-screen.desktop';
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.autostartEnabled});
  final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.system);

  late bool autostartEnabled;

  void toggleAutostart() async {
    String desktopContent = '''[Desktop Entry]
Exec=glfos-welcome-screen
Icon=glfos-welcome-screen
Name=Welcome Screen
StartupWMClass=org.dupot.glfos_welcome_screen
Type=Application
Version=1.5

Hidden=true''';

    io.File autoStartFile = io.File(getAutoStartFilePath());

    if (autostartEnabled) {
      io.Directory autoStartDirectory = io.Directory(getAutoStartDirPath());
      if (!autoStartDirectory.existsSync()) {
        autoStartDirectory.create(recursive: true);
      }

      if (autoStartFile.existsSync()) {
        await autoStartFile.delete();
      }
      await autoStartFile.writeAsString(desktopContent);
    } else {
      if (autoStartFile.existsSync()) {
        await autoStartFile.delete();
      }
    }

    autostartEnabled = !autostartEnabled;
  }

  @override
  Widget build(BuildContext context) {
    final baseLight = AdwaitaThemeData.light();
    final baseDark = AdwaitaThemeData.dark();

    final light = baseLight.copyWith(
      textTheme: baseLight.textTheme.apply(fontFamily: 'customFont'),
    );

    final dark = baseDark.copyWith(
      textTheme: baseDark.textTheme.apply(fontFamily: 'customFont'),
    );

    LocalizationApi(newLanguageCode: io.Platform.localeName);

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          supportedLocales: [Locale('en', 'US'), Locale('fr', 'FR')],
          localizationsDelegates: [
            GettextLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) {
            final virtualWindowFrame = VirtualWindowFrameInit();

            return virtualWindowFrame(context, child);
          },
          theme: light,
          darkTheme: dark,
          debugShowCheckedModeBanner: false,
          home: WelcomeScreen(
              getAutostartStatus: () => autostartEnabled,
              toggleAutostart: () => toggleAutostart(),
              themeNotifier: themeNotifier),
          themeMode: currentMode,
        );
      },
    );
  }
}
