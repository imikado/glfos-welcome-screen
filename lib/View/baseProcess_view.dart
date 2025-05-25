import 'package:flutter/material.dart';
import 'package:glfos_welcome_screen/View/Shared/sharedmarkdown_view.dart';

class BaseProcessView extends StatefulWidget {
  const BaseProcessView({super.key});

  final String titleKey = 'page_baseprocess_title';
  final String bodyKey = 'page_baseprocess_body';

  @override
  State<BaseProcessView> createState() => _BaseProcessViewState();
}

class _BaseProcessViewState extends State<BaseProcessView> {
  @override
  Widget build(BuildContext context) {
    return SharedMarkdownView(
      titleKey: widget.titleKey,
      bodyKey: widget.bodyKey,
    );
  }
}
