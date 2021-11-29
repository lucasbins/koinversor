import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:koinversor/model/result_coin.dart';

class MercadoCoinService {
  static Future<ResultCoin> fetchCoin(String coin) async {
    Map<String, dynamic> result;
    final Uri uri =
        Uri.parse('https://www.mercadobitcoin.net/api/$coin/ticker/');
    final response = await http.get(uri);

    result = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return ResultCoin.fromJson(result);
    } else {
      throw Exception('Requisição inválida!');
    }
  }
}
