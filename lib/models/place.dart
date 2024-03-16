class Place {
  double long;
  double lat;
  String name;
  String? description;

  Place({
    required this.name,
    required this.description,
    required this.lat,
    required this.long,
  });

  factory Place.fromJson(Map<String, dynamic> json) => Place(
        name: json['properties']['name'],
        description: json['properties']['description'],
        lat: json['geometry']['coordinates'][1],
        long: json['geometry']['coordinates'][0],
      );
}
