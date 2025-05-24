import 'package:flutter/material.dart';
import 'package:glfos_welcome_screen/Api/localization_api.dart';
import 'package:url_launcher/url_launcher.dart';

class UsefulinformationView extends StatefulWidget {
  const UsefulinformationView({
    super.key,
  });

  @override
  State<UsefulinformationView> createState() => _UsefulinformationViewState();
}

class _UsefulinformationViewState extends State<UsefulinformationView> {
  List<LinkItem> links = [
    LinkItem(label: 'GLF OS', url: 'https://www.gaminglinux.fr/glf-os/'),
    LinkItem(label: 'Wiki', url: 'https://gaming-linux-fr.github.io/GLF-OS/'),
    LinkItem(label: 'Discord', url: 'https://discord.gg/tqXyUMEwq3'),
  ];

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
          Text(LocalizationApi().tr('page_usefulinformation_body')),
          SizedBox(
            height: 15,
          ),
          Column(
            children: links
                .map((LinkItem linkLoop) => Padding(
                    padding: EdgeInsets.all(3),
                    child: TextButton.icon(
                        icon: Icon(Icons.link),
                        onPressed: () {
                          launchUrl(Uri.parse(linkLoop.url));
                        },
                        label: Text(linkLoop.label))))
                .toList(),
          )
        ],
      ),
    ]));
  }
}

class LinkItem {
  final String label;
  final String url;

  LinkItem({required this.label, required this.url});
}
