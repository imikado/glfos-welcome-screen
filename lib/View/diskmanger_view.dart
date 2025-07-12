import 'package:flutter/material.dart';
import 'package:glfos_welcome_screen/View/Shared/sharedmarkdown_view.dart';

class DiskmanagerView extends StatefulWidget {
  const DiskmanagerView({super.key});

  final String titleKey = 'page_diskmanager_title';
  final String bodyKey = 'page_diskmanager_body';

  @override
  State<DiskmanagerView> createState() => _DiskmanagerViewState();
}

class _DiskmanagerViewState extends State<DiskmanagerView> {
  @override
  Widget build(BuildContext context) {
    return SharedMarkdownView(
        titleKey: widget.titleKey,
        bodyKey: widget.bodyKey,
        image: 'assets/images/diskmanager_128.png',
        command:
            'bash:///nix/store/wcy05baxviaqy7wam8hjmj0p7g17ahr7-nix-disk-manager-1.2.6/bin/nix-disk-manager');
  }
}
