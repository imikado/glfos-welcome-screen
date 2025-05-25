import 'package:flutter/material.dart';
import 'package:glfos_welcome_screen/View/Shared/sharedmarkdown_view.dart';

class UsefulinformationView extends StatefulWidget {
  const UsefulinformationView({
    super.key,
  });

  final String titleKey = 'page_usefulinformation_title';
  final String bodyKey = 'page_usefulinformation_body';

  @override
  State<UsefulinformationView> createState() => _UsefulinformationViewState();
}

class _UsefulinformationViewState extends State<UsefulinformationView> {
  @override
  Widget build(BuildContext context) {
    return SharedMarkdownView(
      titleKey: widget.titleKey,
      bodyKey: widget.bodyKey,
    );
  }
}
