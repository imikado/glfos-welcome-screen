import 'package:flutter/material.dart';
import 'package:glfos_welcome_screen/View/Shared/sharedmarkdown_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
  });

  final String titleKey = 'page_home_title';
  final String bodyKey = 'page_home_body';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return SharedMarkdownView(
      titleKey: widget.titleKey,
      bodyKey: widget.bodyKey,
    );
  }
}
