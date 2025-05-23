import 'package:flutter/material.dart';
import 'package:glfos_welcome_screen/Api/localization_api.dart';

class HomeView extends StatelessWidget {
  const HomeView({
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
          Image.asset('assets/images/glf-logo-128.png'),
          SizedBox(
            height: 20,
          ),
          Text(LocalizationApi().tr('page_home_title')),
          SizedBox(
            height: 20,
          ),
          Text(LocalizationApi().tr('page_home_body')),
        ],
      ),
    ]));
  }
}
