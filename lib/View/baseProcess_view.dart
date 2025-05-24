import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:glfos_welcome_screen/Api/localization_api.dart';

class BaseProcessView extends StatefulWidget {
  const BaseProcessView({super.key});

  @override
  State<BaseProcessView> createState() => _BaseProcessViewState();
}

class _BaseProcessViewState extends State<BaseProcessView> {
  String? bodyText;

  @override
  void initState() {
    super.initState();
    _loadMarkdown();
  }

  Future<void> _loadMarkdown() async {
    final newBodyText =
        await LocalizationApi().markdown('page_baseprocess_body');
    if (mounted) {
      setState(() => bodyText = newBodyText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (bodyText == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
              maxWidth: constraints.maxWidth,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Center(
                  child: Text(
                    LocalizationApi().tr('page_baseprocess_title'),
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                MarkdownBody(
                  data: bodyText!,
                  styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
