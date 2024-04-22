import 'dart:convert';

AreaModel areaModelFromJson(String str) => AreaModel.fromJson(json.decode(str));


class AreaModel {
  List<Area> area;

  AreaModel({
    required this.area,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) => AreaModel(
    area: List<Area>.from(json["area"].map((x) => Area.fromJson(x))),
  );


}

class Area {
  int id;
  String name;

  Area({
    required this.id,
    required this.name,
  });

  factory Area.fromJson(Map<String, dynamic> json) => Area(
    id: json["id"],
    name: json["name"],
  );
}
