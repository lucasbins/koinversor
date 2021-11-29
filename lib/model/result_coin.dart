class ResultCoin {
  late Ticker ticker;

  ResultCoin({required this.ticker});

  ResultCoin.fromJson(Map<String, dynamic> json) {
    ticker = (json['ticker'] != null ? Ticker.fromJson(json['ticker']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ticker'] = ticker.toJson();
    return data;
  }
}

class Ticker {
  Ticker(
      {required this.high,
      required this.low,
      required this.vol,
      required this.last,
      required this.buy,
      required this.sell,
      required this.open,
      required this.date});

  late String high;
  late String low;
  late String vol;
  late String last;
  late String buy;
  late String sell;
  late String open;
  late int date;

  Ticker.fromJson(Map<String, dynamic> json) {
    high = json['high'];
    low = json['low'];
    vol = json['vol'];
    last = json['last'];
    buy = json['buy'];
    sell = json['sell'];
    open = json['open'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['high'] = high;
    data['low'] = low;
    data['vol'] = vol;
    data['last'] = last;
    data['buy'] = buy;
    data['sell'] = sell;
    data['open'] = open;
    data['date'] = date;
    return data;
  }
}
