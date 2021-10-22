///
class TimePlace {
  TimePlace({
    required this.time,
    required this.place,
    required this.price,
  });

  String time;
  String place;
  int price;

  factory TimePlace.fromJson(Map<String, dynamic> json) => TimePlace(
        time: json["time"],
        place: json["place"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "time": time,
        "place": place,
        "price": price,
      };
}
