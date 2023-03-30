class MainbannerModel {
  final dynamic title, image, urllink;

  MainbannerModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        image = json['image'],
        urllink = json['url_link'];
}
