class Search {
  int? id;
  String? name;
  String? region;
  String? country;
  double? lat;
  double? lon;

  Search({
    this.id,
    this.name,
    this.region,
    this.country,
    this.lat,
    this.lon,
  });

  factory Search.fromJson(json) {
    return Search(
      id: json['id'],
      name: json['name'],
      region: json['region'],
      country: json['country'],
      lat: json['lat'],
      lon: json['lon'],
    );
  }
}
