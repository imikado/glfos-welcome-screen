import 'package:flutter/material.dart';
import 'package:glfos_welcome_screen/Api/localization_api.dart';

class DesktopselectorView extends StatelessWidget {
  const DesktopselectorView({
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
          Text(LocalizationApi().tr('page_desktopselector_title')),
          SizedBox(
            height: 15,
          ),
          Text(LocalizationApi().tr('page_desktopselector_body'))
        ],
      ),
    ]));
  }
}
