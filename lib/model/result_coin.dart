import 'dart:convert';

class ResultCoin {
  ResultCoin({
    required this.high,
    required this.low,
    required this.vol,
    required this.last,
    required this.buy,
    required this.sell,
    required this.open,
    required this.date,
  });

  double high;
  double low;
  double vol;
  double last;
  double buy;
  double sell;
  double open;
  String date;

  factory ResultCoin.fromJson(String str) =>
      ResultCoin.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ResultCoin.fromMap(Map<String, dynamic> json) => ResultCoin(
        high: json["high"],
        low: json["low"],
        vol: json["vol"],
        last: json["last"],
        buy: json["buy"],
        sell: json["sell"],
        open: json["open"],
        date: json["date"],
      );

  Map<String, dynamic> toMap() => {
        "high": high,
        "low": low,
        "last": last,
        "buy": buy,
        "sell": sell,
      };
}
