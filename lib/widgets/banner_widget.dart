// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class keymediBanner extends StatelessWidget {
  final String title, image, urllink;

  const keymediBanner({
    super.key,
    required this.title,
    required this.image,
    required this.urllink,
  });

  onBannerClick() async {
    // final url = Uri.parse(urllink);
    final url = Uri.parse('https://keymedi.com');
    await launchUrl(url);
    // await launchUrlString("https://google.com");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onBannerClick,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 380,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              // boxShadow: [
              //   BoxShadow(
              //     blurRadius: 3,
              //     offset: const Offset(10, 10),
              //     color: Colors.black.withOpacity(0.5),
              //   ),
              // ],
            ),
            child: Image.network(
              image,
              headers: const {
                "User-Agent":
                    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
              },
            ),
          ),
        ],
      ),
    );
  }
}
