import 'package:flutter/material.dart';
import 'package:glfos_welcome_screen/Api/localization_api.dart';
import 'package:libadwaita/libadwaita.dart';

class EasyflatpakView extends StatelessWidget {
  const EasyflatpakView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: [
      SizedBox(
        height: 30,
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/easyflatpak_128.png'),
          SizedBox(
            height: 20,
          ),
          Text(LocalizationApi().tr('page_easyflatpak_title')),
          SizedBox(
            height: 15,
          ),
          Text(LocalizationApi().tr('page_easyflatpak_body'))
        ],
      ),
    ]));
  }
}
