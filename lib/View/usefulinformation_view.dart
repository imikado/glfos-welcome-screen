import 'package:flutter/material.dart';
import 'package:glfos_welcome_screen/Api/localization_api.dart';

class UsefulinformationView extends StatelessWidget {
  const UsefulinformationView({
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
          Text(LocalizationApi().tr('page_usefulinformation_title')),
          SizedBox(
            height: 15,
          ),
          Text(LocalizationApi().tr('page_usefulinformation_body'))
        ],
      ),
    ]));
  }
}
