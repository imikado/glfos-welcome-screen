import 'package:flutter/material.dart';
import 'package:glfos_welcome_screen/View/Shared/sharedmarkdown_view.dart';

class SambashareView extends StatefulWidget {
  const SambashareView({super.key});

  final String titleKey = 'page_sambashare_title';
  final String bodyKey = 'page_sambashare_body';

  @override
  State<SambashareView> createState() => _SambashareViewState();
}

class _SambashareViewState extends State<SambashareView> {
  @override
  Widget build(BuildContext context) {
    return SharedMarkdownView(
        titleKey: widget.titleKey,
        bodyKey: widget.bodyKey,
        image: 'assets/images/sambashare_128.png',
        command:
            'bashWithPrivilege:///run/current-system/sw/bin/nix-firewall-manager');
  }
}
