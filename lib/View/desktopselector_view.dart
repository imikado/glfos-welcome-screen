import 'package:flutter/material.dart';
import 'package:glfos_welcome_screen/View/Shared/sharedmarkdown_view.dart';

class DesktopselectorView extends StatefulWidget {
  const DesktopselectorView({super.key});

  final String titleKey = 'page_desktopselector_title';
  final String bodyKey = 'page_desktopselector_body';

  @override
  State<DesktopselectorView> createState() => _DesktopselectorViewState();
}

class _DesktopselectorViewState extends State<DesktopselectorView> {
  @override
  Widget build(BuildContext context) {
    return SharedMarkdownView(
      titleKey: widget.titleKey,
      bodyKey: widget.bodyKey,
    );
  }
}
