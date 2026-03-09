import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../function/luncher_url.dart';

class SocialIconsRow extends StatelessWidget {
  final String? facebookLink;
  final String? youtubeLink;
  final String? tiktokLink;
  const SocialIconsRow({
    super.key,
    this.facebookLink,
    this.youtubeLink,
    this.tiktokLink,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (facebookLink != null && facebookLink!.isNotEmpty) ...[
          IconButton(
            icon: const Icon(FontAwesomeIcons.facebook),
            color: Colors.blue,
            onPressed: () {
              if (facebookLink != null) {
                launchURL(facebookLink!);
              }
            },
          ),
        ],
        if (youtubeLink != null && youtubeLink!.isNotEmpty) ...[
          IconButton(
            icon: const Icon(FontAwesomeIcons.youtube),
            color: Colors.red,
            onPressed: () {
              if (facebookLink != null) {
                launchURL(youtubeLink!);
              }
            },
          ),
        ],
        if (tiktokLink != null && tiktokLink!.isNotEmpty) ...[
          IconButton(
            icon: const Icon(FontAwesomeIcons.tiktok),
            color: Colors.black,
            onPressed: () {
              if (tiktokLink != null) {
                launchURL(tiktokLink!);
              }
            },
          ),
        ]
      ],
    );
  }
}
