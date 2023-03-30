import 'package:flutter/material.dart';
import 'package:toonflix/models/keymedi_mainbanner_model.dart';
import 'package:toonflix/models/webtoon_model.dart';
import 'package:toonflix/services/api_services.dart';
import 'package:toonflix/widgets/banner_widget.dart';
import 'package:toonflix/widgets/webtoon_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();
  Future<List<MainbannerModel>> banner = ApiService.getKeymediMainContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            children: [
              FutureBuilder(
                future: banner,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 430,
                            height: 250,
                            child: bannerList(snapshot),
                          ),
                        ],
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
          FutureBuilder(
            future: webtoons,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 1,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 400,
                        height: 2000,
                        child: makeList(snapshot),
                      ),
                    ],
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }

  GridView makeList(AsyncSnapshot<List<WebtoonModel>> snapshot) {
    return GridView.builder(
      itemCount: snapshot.data!.length, //item 개수
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, //1 개의 행에 보여줄 item 개수
        childAspectRatio: 1 / 1.55, //item 의 가로 1, 세로 2 의 비율
        mainAxisSpacing: 10, //수평 Padding
        crossAxisSpacing: 10, //수직 Padding
      ),
      itemBuilder: (context, index) {
        var webtoon = snapshot.data![index];
        return Webtoon(
            title: webtoon.title, thumb: webtoon.thumb, id: webtoon.id);
      },
    );
  }

  ListView bannerList(AsyncSnapshot<List<MainbannerModel>> snapshot) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data!.length,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      itemBuilder: (context, index) {
        var banner = snapshot.data![index];
        return keymediBanner(
          title: banner.title,
          image: banner.image,
          urllink: banner.urllink,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        width: 40,
      ),
    );
  }
}
