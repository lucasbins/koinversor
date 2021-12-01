import 'package:flutter/material.dart';
import 'package:koinversor/model/result_coin.dart';
import 'package:koinversor/service/mercado_bitcoin_service.dart';

import 'package:koinversor/widget/loading.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

List<String> coins = ['BTC', 'LTC', 'ADA', 'UNI', 'USDC'];

final btcController = TextEditingController();
final ltcController = TextEditingController();
final adaController = TextEditingController();
final uniController = TextEditingController();
final usdcController = TextEditingController();

final realController = TextEditingController();

void _clearAll() {
  btcController.text = 1.toStringAsFixed(2);
  ltcController.text = 1.toStringAsFixed(2);
  adaController.text = 1.toStringAsFixed(2);
  uniController.text = 1.toStringAsFixed(2);
  usdcController.text = 1.toStringAsFixed(2);
}

Future<List> getData() async {
  List<ResultCoin> list = await Future.wait(
      coins.map((itemId) => MercadoCoinService.fetchCoin(itemId)));
  return list.map((response) {
    return response;
  }).toList();
}

class _HomePageState extends State<HomePage> {
  String _dropdownController = 'BTC';

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Koinversor',
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
      ),
      body: FutureBuilder<List>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Loading();
            default:
              if (snapshot.hasError) {
                return const Center(
                    child: Text(
                  "Erro ao Carregar Dados :(",
                  style: TextStyle(color: Colors.amber, fontSize: 25.0),
                  textAlign: TextAlign.center,
                ));
              } else {
                carregaCryptos(snapshot.data);

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _dropdown(),
                        montaTextfield(_dropdownController),
                        const Text(
                          '=',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 50),
                        ),
                        montaTextfield('REAL'),
                      ],
                    ),
                  ),
                );
              }
          }
        },
      ),
    );
  }

  Widget _dropdown() {
    return DropdownButtonHideUnderline(
        child: DropdownButton<String>(
      value: _dropdownController,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.black, fontSize: 25.0),
      onChanged: (String? newValue) {
        setState(() => (_dropdownController = newValue!));
      },
      items: coins.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    ));
  }

  Widget montaTextfield(String coin) {
    _clearAll();
    switch (coin) {
      case 'REAL':
        return buildTextField(realController, "R\$ ", _realChanged);
      default:
        switch (_dropdownController) {
          case 'BTC':
            return buildTextField(btcController, "BTC ", _btcChanged);
          case 'LTC':
            return buildTextField(ltcController, "LTC ", _ltcChanged);
          case 'ADA':
            return buildTextField(adaController, "ADA ", _adaChanged);
          case 'UNI':
            return buildTextField(uniController, "UNI ", _uniChanged);
          case 'USDC':
            return buildTextField(usdcController, "USDC ", _usdcChanged);
          default:
            return const Text('Error');
        }
    }
  }

  late double btc;
  late double ltc;
  late double ada;
  late double uni;
  late double usdc;

  double _calculo(a, b, c) {
    double x = (b * c) / a;
    return x;
  }

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    switch (_dropdownController) {
      case 'BTC':
        btcController.text = _calculo(btc, 1, real).toStringAsFixed(2);
        break;
      case 'LTC':
        ltcController.text = _calculo(ltc, 1, real).toStringAsFixed(2);
        break;
      case 'ADA':
        adaController.text = _calculo(ada, 1, real).toStringAsFixed(2);
        break;
      case 'UNI':
        uniController.text = _calculo(uni, 1, real).toStringAsFixed(2);
        break;
      case 'USDC':
        usdcController.text = _calculo(usdc, 1, real).toStringAsFixed(2);
        break;
    }
  }

  void _btcChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double coin = double.parse(text);
    realController.text = _calculo(1, btc, coin).toStringAsFixed(2);
  }

  void _ltcChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double coin = double.parse(text);
    realController.text = _calculo(1, ltc, coin).toStringAsFixed(2);
  }

  void _adaChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double coin = double.parse(text);
    realController.text = _calculo(1, ada, coin).toStringAsFixed(2);
  }

  void _uniChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double coin = double.parse(text);
    realController.text = _calculo(1, uni, coin).toStringAsFixed(2);
  }

  void _usdcChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double coin = double.parse(text);
    realController.text = _calculo(1, usdc, coin).toStringAsFixed(2);
  }

  void carregaCryptos(data) {
    btc = double.parse(data![0].ticker.buy);
    ltc = double.parse(data![1].ticker.buy);
    ada = double.parse(data![2].ticker.buy);
    uni = double.parse(data![3].ticker.buy);
    usdc = double.parse(data![4].ticker.buy);

    switch (_dropdownController) {
      case 'BTC':
        realController.text = btc.toStringAsFixed(2);
        break;
      case 'LTC':
        realController.text = ltc.toStringAsFixed(2);
        break;
      case 'ADA':
        realController.text = ada.toStringAsFixed(2);
        break;
      case 'UNI':
        realController.text = uni.toStringAsFixed(2);
        break;
      case 'USDC':
        realController.text = usdc.toStringAsFixed(2);
        break;
    }
  }
}

Widget buildTextField(
    TextEditingController c, String prefix, Function(String) f) {
  return TextField(
    controller: c,
    onChanged: f,
    decoration: InputDecoration(
      prefixText: prefix,
      border: const OutlineInputBorder(),
    ),
    style: const TextStyle(color: Colors.black, fontSize: 25.0),
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
  );
}
