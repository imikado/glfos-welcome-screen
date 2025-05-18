import 'package:flutter/material.dart';
import 'package:glfos_welcome_screen/Api/localization_api.dart';
import 'package:libadwaita/libadwaita.dart';

class BaseProcessView extends StatelessWidget {
  const BaseProcessView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: [
      SizedBox(
        height: 30,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(LocalizationApi().tr('page_baseprocess_title')),
          SizedBox(
            height: 15,
          ),
          Text(LocalizationApi().tr('page_baseprocess_body'))
        ],
      ),
    ]));
  }
}
