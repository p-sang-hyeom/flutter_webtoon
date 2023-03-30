import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Recent extends StatelessWidget {
  final String title, thumb, id, subtitle, episode;

  const Recent({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
    required this.subtitle,
    required this.episode,
  });

  onEpisodeClick() async {
    final url = Uri.parse(
        "https://comic.naver.com/webtoon/detail?titleId=$id&no=$episode");

    await launchUrl(url);
    // await launchUrlString("https://google.com");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onEpisodeClick,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: Color(0xFFCCCCCC),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 5,
          ),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                height: 80,
                width: 80,
                child: Image.network(
                  thumb,
                  headers: const {
                    "User-Agent":
                        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
                  },
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: const [
                  Text(
                    '이어보기',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                  )
                ],
              ),
              // const Icon(
              //   Icons.chevron_right_rounded,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
