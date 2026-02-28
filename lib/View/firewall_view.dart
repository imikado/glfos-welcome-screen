import 'package:flutter/material.dart';
import 'package:glfos_welcome_screen/View/Shared/sharedmarkdown_view.dart';

class FirewallView extends StatefulWidget {
  const FirewallView({super.key});

  final String titleKey = 'page_firewallmanager_title';
  final String bodyKey = 'page_firewallmanager_body';

  @override
  State<FirewallView> createState() => _FirewallViewState();
}

class _FirewallViewState extends State<FirewallView> {
  @override
  Widget build(BuildContext context) {
    return SharedMarkdownView(
        titleKey: widget.titleKey,
        bodyKey: widget.bodyKey,
        image: 'assets/images/firewallmanager_128.png',
        command:
            'bashWithPrivilege:///run/current-system/sw/bin/nix-firewall-manager');
  }
}
