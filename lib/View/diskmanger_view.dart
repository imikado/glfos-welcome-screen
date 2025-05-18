import 'package:flutter/material.dart';
import 'package:glfos_welcome_screen/Api/localization_api.dart';

class DiskmangerView extends StatelessWidget {
  const DiskmangerView({
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
          Image.asset('assets/images/diskmanager_128.png'),
          SizedBox(
            height: 20,
          ),
          Text(LocalizationApi().tr('page_diskmanager_title')),
          SizedBox(
            height: 15,
          ),
          Text(LocalizationApi().tr('page_diskmanager_body'))
        ],
      ),
    ]));
  }
}
