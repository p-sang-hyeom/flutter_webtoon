import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toonflix/models/webtoon_model.dart';
import 'package:toonflix/screens/home_screen.dart';
import 'package:toonflix/screens/liked_screen.dart';
import 'package:toonflix/services/api_services.dart';
import 'package:toonflix/widgets/recent_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class RecentScreen extends StatefulWidget {
  const RecentScreen({super.key});

  @override
  State<RecentScreen> createState() => _RecentScreenState();
}

class _RecentScreenState extends State<RecentScreen> {
  Future<List<WebtoonModel>> recentWebtoons = ApiService.getRecentToons();

  late SharedPreferences prefs;

  List recentToons = [];

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    recentToons = prefs.getStringList('recentToons')!;
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  final int _selectedIndex = 2;

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
        var begin = const Offset(-1.0, 0.0);
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
          "최근 본 웹툰",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: recentWebtoons,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      SizedBox(
                        width: 450,
                        height: 2000,
                        child: makeList(snapshot),
                      ),
                    ],
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

  ListView makeList(AsyncSnapshot<List<WebtoonModel>> snapshot) {
    print(recentToons);
    return ListView.separated(
      scrollDirection: Axis.vertical,
      itemCount: snapshot.data!.length,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      itemBuilder: (context, index) {
        var webtoon = snapshot.data![index];
        for (int i = 0; i < recentToons.length; i++) {
          var list = recentToons[i].split('/');
          if (list[0] == webtoon.id) {
            return Recent(
              title: webtoon.title,
              thumb: webtoon.thumb,
              id: webtoon.id,
              subtitle: list[2],
              episode: list[1],
            );
          }
        }
        return null;
      },
      separatorBuilder: (context, index) => const SizedBox(
        width: 40,
      ),
    );
  }
}
