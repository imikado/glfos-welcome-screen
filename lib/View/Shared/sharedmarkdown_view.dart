import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:glfos_welcome_screen/Api/localization_api.dart';
import 'package:url_launcher/url_launcher.dart';

class SharedMarkdownView extends StatefulWidget {
  const SharedMarkdownView({
    super.key,
    required this.titleKey,
    required this.bodyKey,
  });

  final String titleKey;
  final String bodyKey;

  @override
  State<SharedMarkdownView> createState() => _SharedMarkdownViewState();
}

class _SharedMarkdownViewState extends State<SharedMarkdownView> {
  String? bodyText;

  @override
  void initState() {
    super.initState();
    _loadMarkdown();
  }

  Future<void> _loadMarkdown() async {
    final newBodyText = await LocalizationApi().markdown(widget.bodyKey);
    if (mounted) {
      setState(() => bodyText = newBodyText);
    }
  }

  Future<void> _onTapLink(String text, String? href, String title) async {
    if (href != null) {
      if (href.startsWith('flatpak://')) {
        String command = href.replaceAll('flatpak://', '');
        await Process.run('flatpak', ['run', command]);
        return;
      } else if (href.startsWith('bash://')) {
        String command = href.replaceAll('bash://', '');
        await Process.run(command, []);
        return;
      }

      final uri = Uri.parse(href);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        debugPrint('Could not launch $href');
      }
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
                    LocalizationApi().tr(widget.titleKey),
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                Row(children: [
                  MarkdownBody(
                    fitContent: true,
                    shrinkWrap: true,
                    imageDirectory: 'assets/images/',
                    data: bodyText!,
                    styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
                    onTapLink: _onTapLink,
                  )
                ]),
              ],
            ),
          ),
        );
      },
    );
  }
}
