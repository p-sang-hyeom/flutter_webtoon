import 'package:flutter/material.dart';
import 'package:toonflix/models/webtoon_episode_model.dart';
import 'package:url_launcher/url_launcher.dart';

class Episode extends StatelessWidget {
  const Episode({
    super.key,
    required this.episode,
    required this.webtoonId,
  });

  final String webtoonId;
  final WebtoonEpisodeModel episode;

  onButtonTap() async {
    final url = Uri.parse(
        "https://comic.naver.com/webtoon/detail?titleId=$webtoonId&no=${episode.id}");
    await launchUrl(url);
    // await launchUrlString("https://google.com");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onButtonTap,
      child: Container(
        width: 400,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: Color(0xFFCCCCCC),
            ),
          ),
          // color: Colors.green.shade300,
          // boxShadow: [
          //   BoxShadow(
          //     blurRadius: 8,
          //     offset: const Offset(5, 5),
          //     color: Colors.green.withOpacity(0.6),
          //   ),
          // ],
          // borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 3,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 70,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Image.network(
                  episode.thumb,
                  headers: const {
                    "User-Agent":
                        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(episode.title,
                      style: const TextStyle(
                        fontSize: 16,
                      )),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.red,
                        size: 11,
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(episode.rating,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.red,
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(episode.date,
                          style: const TextStyle(
                            fontSize: 11,
                          )),
                    ],
                  ),
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
