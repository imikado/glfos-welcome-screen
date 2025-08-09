import 'dart:async';
import 'dart:io' as io;

import 'package:adwaita/adwaita.dart';
import 'package:flutter/material.dart';
import 'package:glfos_welcome_screen/welcome_screen.dart';
import 'package:window_manager/window_manager.dart';

import 'package:flutter_gettext/flutter_gettext/gettext_localizations_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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

  unawaited(
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.setAsFrameless();

      await windowManager.show();
      await windowManager.focus();
    }),
  );

  runApp(MyApp());
}

String getSystemAutostartDesktopFilePath() {
  String xdgConfigDirsEnv =
      io.Platform.environment["XDG_CONFIG_DIRS"] ?? "/etc/xdg";

  for (final dir in xdgConfigDirsEnv.split(':')) {
    final dirEntity = io.Directory(dir + '/autostart');

    if (!dirEntity.existsSync()) continue;

    List<io.FileSystemEntity> files = dirEntity.listSync();

    for (final file in files) {
      final filename = file.path.split('/').last;

      if (filename == 'glfos-welcome-screen.desktop') {
        return file.path;
      }
    }
  }
  return '';
  throw 'Could not start welcome screen: autostart desktop file not found (app package must be corrupted)';
}

class MyApp extends StatelessWidget {
  MyApp({super.key}) {
    autostartEnabled = !userAutostartDesktopFile.existsSync();
  }

  final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.system);

  final io.File systemAutostartDesktopFile =
      io.File(getSystemAutostartDesktopFilePath());
  final io.Directory autostartDirectory = io.Directory(
      (io.Platform.environment['HOME'] ?? '~') + '/.config/autostart/');
  final io.File userAutostartDesktopFile = io.File(
      (io.Platform.environment['HOME'] ?? '~') +
          '/.config/autostart/glfos-welcome-screen.desktop');

  late bool autostartEnabled;

  void toggleAutostart() async {
    if (!this.autostartEnabled)
      await userAutostartDesktopFile.delete();
    else {
      await autostartDirectory.create();
      final autostartDesktopContent =
          await systemAutostartDesktopFile.readAsStringSync();
      await userAutostartDesktopFile
          .writeAsString(autostartDesktopContent + "\nHidden=true");
    }

    this.autostartEnabled = !this.autostartEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          locale: const Locale('en'),
          supportedLocales: const [
            Locale('fr'),
            Locale('en'),
          ],
          localizationsDelegates: [
            GettextLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          builder: (context, child) {
            final virtualWindowFrame = VirtualWindowFrameInit();

            return virtualWindowFrame(context, child);
          },
          theme: AdwaitaThemeData.light(),
          darkTheme: AdwaitaThemeData.dark(),
          debugShowCheckedModeBanner: false,
          home: WelcomeScreen(
              getAutostartStatus: () => autostartEnabled,
              toggleAutostart: this.toggleAutostart,
              themeNotifier: themeNotifier),
          themeMode: currentMode,
        );
      },
    );
  }
}
