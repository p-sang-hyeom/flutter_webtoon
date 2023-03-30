// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:toonflix/models/keymedi_mainbanner_model.dart';
import 'package:toonflix/models/webtoon_model.dart';
import 'package:toonflix/screens/liked_screen.dart';
import 'package:toonflix/screens/recent_screen.dart';
import 'package:toonflix/services/api_services.dart';
import 'package:toonflix/widgets/webtoon_widget.dart';
import 'package:toonflix/widgets/banner_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();
  Future<List<MainbannerModel>> banner = ApiService.getKeymediMainContent();

  final int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      // Navigator.pushNamed(context, '/$index');
      if (index != _selectedIndex) {
        switch (index) {
          case 0:
            Navigator.of(context).push(_createRoute(const HomeScreen(), index));
            break;
          case 1:
            Navigator.of(context)
                .push(_createRoute(const LikedScreen(), index));
            break;
          case 2:
            Navigator.of(context)
                .push(_createRoute(const RecentScreen(), index));
            break;
          default:
            final url = Uri.parse("https://m.comic.naver.com/webtoon/weekday");
            launchUrl(url);
            break;
        }
      }
    });
  }

  Route _createRoute(screen, idx) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(1.0, 0.0);
        var end = Offset.zero;
        var tween = Tween(begin: begin, end: end);
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF224FBC),
        title: const Text(
          "오늘의 웹툰",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
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
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        backgroundColor: Colors.white,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(
              Icons.home,
              color: Color(0xFF224FBC),
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(
              Icons.favorite,
              color: Color(0xFF224FBC),
            ),
            label: 'Liked',
          ),
          NavigationDestination(
            icon: Icon(Icons.access_time_outlined),
            selectedIcon: Icon(
              Icons.access_time,
              color: Color(0xFF224FBC),
            ),
            label: 'Recent',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_box_outlined),
            selectedIcon: Icon(
              Icons.add_box,
              color: Color(0xFF224FBC),
            ),
            label: 'More',
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
    // return ListView.separated(
    //   scrollDirection: Axis.horizontal,
    //   itemCount: snapshot.data!.length,
    //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    //   itemBuilder: (context, index) {
    //     var webtoon = snapshot.data![index];
    //     return Webtoon(
    //         title: webtoon.title, thumb: webtoon.thumb, id: webtoon.id);
    //   },
    //   separatorBuilder: (context, index) => const SizedBox(
    //     width: 40,
    //   ),
    // );
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
