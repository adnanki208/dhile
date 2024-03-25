import 'dart:convert';

FeaturesModel featureFromJson(String str) => FeaturesModel.fromJson(json.decode(str));


class FeaturesModel {
  List<Feature> features;

  FeaturesModel({
    required this.features,
  });

  factory FeaturesModel.fromJson(Map<String, dynamic> json) => FeaturesModel(
    features: List<Feature>.from(json["features"].map((x) => Feature.fromJson(x))),
  );

}

class Feature {
  String title;
  int icon;
  Media media;

  Feature({
    required this.title,
    required this.icon,
    required this.media,
  });

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
    title: json["title"],
    icon: json["icon"],
    media: Media.fromJson(json["media"]),
  );


}

class Media {
  int id;
  String url;

  Media({
    required this.id,
    required this.url,
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
    id: json["id"],
    url: json["url"],
  );
}
