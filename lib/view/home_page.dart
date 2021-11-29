import 'package:flutter/material.dart';
import 'package:koinversor/model/result_coin.dart';
import 'package:koinversor/service/mercado_bitcoin_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

List<String> coins = ['BTC', 'LTC', 'ADA', 'UNI', 'USDC'];
ResultCoin? btc;
ResultCoin? ltc;
ResultCoin? ada;
ResultCoin? uni;
ResultCoin? usdc;

final btcController = TextEditingController();
final ltcController = TextEditingController();
final adaController = TextEditingController();
final uniController = TextEditingController();
final usdcController = TextEditingController();

final realController = TextEditingController();

void _clearAll() {
  realController.text = 1.toString();
  btcController.text = "";
  ltcController.text = "";
  adaController.text = "";
  uniController.text = "";
  usdcController.text = "";
}

Future<List> getData() async {
  List<ResultCoin> list = await Future.wait(
      coins.map((itemId) => MercadoCoinService.fetchCoin(itemId)));

  return list.map((response) {
    // do processing here and return items
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
              return const Center(
                  child: Text(
                "Carregando Dados...",
                style: TextStyle(color: Colors.black, fontSize: 25.0),
                textAlign: TextAlign.center,
              ));
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
                        montaTextfield('REAL'),
                        const Text(
                          '=',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 50),
                        ),
                        montaTextfield(_dropdownController),
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
    switch (coin) {
      case 'BTC':
        return buildTextField(btcController, "R\$ ", _btcChanged);
      case 'LTC':
        return buildTextField(ltcController, "R\$ ", _btcChanged);
      case 'ADA':
        return buildTextField(adaController, "R\$ ", _btcChanged);
      case 'UNI':
        return buildTextField(uniController, "R\$ ", _btcChanged);
      case 'USDC':
        return buildTextField(usdcController, "R\$ ", _btcChanged);
      case 'REAL':
        switch (_dropdownController) {
          case 'BTC':
            return buildTextField(realController, "BTC ", _btcChanged);
          case 'LTC':
            return buildTextField(realController, "LTC ", _btcChanged);
          case 'ADA':
            return buildTextField(realController, "ADA ", _btcChanged);
          case 'UNI':
            return buildTextField(realController, "UNI ", _btcChanged);
          case 'USDC':
            return buildTextField(realController, "USDC ", _btcChanged);
          default:
            return const Text('Error');
        }
      default:
        return const Text('Error');
    }
  }

  void _btcChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
  }

  void carregaCryptos(data) {
    btc = data![0];
    ltc = data![1];
    ada = data![2];
    uni = data![3];
    usdc = data![4];

    btcController.text = btc!.ticker.buy;
    ltcController.text = ltc!.ticker.buy;
    adaController.text = ada!.ticker.buy;
    uniController.text = uni!.ticker.buy;
    usdcController.text = usdc!.ticker.buy;
    realController.text = 1.toString();
  }
}

Widget buildTextField(TextEditingController c, String prefix, Function f) {
  return TextField(
    controller: c,
    decoration: InputDecoration(
      prefixText: prefix,
      border: const OutlineInputBorder(),
    ),
    style: const TextStyle(color: Colors.black, fontSize: 25.0),
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
  );
}
