import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toonflix/models/keymedi_mainbanner_model.dart';
import 'package:toonflix/models/webtoon_detail_model.dart';
import 'package:toonflix/models/webtoon_episode_model.dart';
import 'package:toonflix/models/webtoon_model.dart';

class ApiService {
  // 키메디 메인 컨텐츠 호출
  static const String keymediBaseUrl =
      "https://api.devweb.keymedidev.com/api/main/getMainContentList";
  static const String baseUrl =
      "https://webtoon-crawler.nomadcoders.workers.dev";
  static const String today = "today";

  static Future<List<WebtoonModel>> getTodaysToons() async {
    List<WebtoonModel> webtoonInstances = [];

    final url = Uri.parse('$baseUrl/$today');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> webtoons = jsonDecode(response.body);

      for (var webtoon in webtoons) {
        webtoonInstances.add(WebtoonModel.fromJson(webtoon));
      }
      return webtoonInstances;
    }
    throw Error();
  }

  static Future<List<WebtoonModel>> getLikedToons() async {
    List<WebtoonModel> webtoonInstances = [];
    late SharedPreferences prefs;
    List likedToons = [];

    final url = Uri.parse('$baseUrl/$today');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> webtoons = jsonDecode(response.body);
      prefs = await SharedPreferences.getInstance();
      likedToons = prefs.getStringList('likedToons')!;

      for (var webtoon in webtoons) {
        if (likedToons.contains(webtoon['id']) == true) {
          webtoonInstances.add(WebtoonModel.fromJson(webtoon));
        }
      }
      return webtoonInstances;
    }
    throw Error();
  }

  static Future<List<WebtoonModel>> getRecentToons() async {
    List<WebtoonModel> webtoonInstances = [];
    late SharedPreferences prefs;
    List recentToons = [];
    List toonsList = [];

    prefs = await SharedPreferences.getInstance();
    recentToons = prefs.getStringList('recentToons')!;

    if (recentToons.isNotEmpty) {
      for (int i = 0; i < recentToons.length; i++) {
        var list = recentToons[i].split('/');
        toonsList.add(list[0]);

        // final url = Uri.parse("$baseUrl/$list[0]");
        // final response = await http.get(url);
        // if (response.statusCode == 200) {
        //   final webtoon = jsonDecode(response.body);
        //   print(webtoon);
        //   webtoonInstances.add(WebtoonModel.fromJson(webtoon));
        // }
        // throw Error();
      }

      final url = Uri.parse('$baseUrl/$today');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> webtoons = jsonDecode(response.body);

        for (var webtoon in webtoons) {
          if (toonsList.contains(webtoon['id']) == true) {
            webtoonInstances.add(WebtoonModel.fromJson(webtoon));
          }
        }
        return webtoonInstances;
      }
    }
    return webtoonInstances;
  }

  static Future<WebtoonDetailModel> getToonById(String id) async {
    final url = Uri.parse("$baseUrl/$id");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final webtoon = jsonDecode(response.body);
      // print(webtoon);
      return WebtoonDetailModel.fromJson(webtoon);
    }
    throw Error();
  }

  static Future<List<WebtoonEpisodeModel>> getLatesEpisodeById(
      String id) async {
    List<WebtoonEpisodeModel> episodesInstances = [];
    final url = Uri.parse("$baseUrl/$id/episodes");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final episodes = jsonDecode(response.body);
      for (var episode in episodes) {
        episodesInstances.add(WebtoonEpisodeModel.fromJson(episode));
      }
      return episodesInstances;
    }
    throw Error();
  }

  // 키메디 메인 컨텐츠 호출
  static Future<List<MainbannerModel>> getKeymediMainContent() async {
    List<MainbannerModel> bannerInstances = [];
    final url = Uri.parse(keymediBaseUrl);
    final response = await http.post(url, body: {'front_type': 'mobile'});

    if (response.statusCode == 200) {
      final contents = jsonDecode(response.body);
      final mainbanner = contents['data']['banner_top_slide'];

      for (var banner in mainbanner) {
        bannerInstances.add(MainbannerModel.fromJson(banner));
      }
      return bannerInstances;
    }

    throw Error();
  }

  // static Future<List> getKeymediMainContent() async {
  //   List keymediInstances = [];

  //   final url = Uri.parse(keymediBaseUrl);
  //   final response = await http.post(url, body: {'front_type': 'mobile'});
  //   if (response.statusCode == 200) {
  //     final List<dynamic> contents = jsonDecode(response.body);

  //     for (var maincontent in contents) {
  //       keymediInstances.add(WebtoonModel.fromJson(maincontent));
  //     }
  //     return (keymediInstances);
  //   }
  //   throw Error();
  // }
}
