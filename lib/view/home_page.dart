import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:koinversor/model/result_coin.dart';
import 'package:koinversor/service/mercado_bitcoin_service.dart';

import 'package:koinversor/widget/loading.dart';

class Item {
  const Item(this.name, this.url, this.value);
  final String name;
  final String url;
  final String value;
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

//gera a lista das moedas para pesquisar e gerar o dropdown
List<String> coins = ['BTC', 'LTC', 'ADA', 'UNI', 'USDC'];

//inicia os controllers
final btcController = TextEditingController();
final ltcController = TextEditingController();
final adaController = TextEditingController();
final uniController = TextEditingController();
final usdcController = TextEditingController();
final realController = TextEditingController();

//inicia os valores nos controllers
void _clearAll() {
  btcController.text = 1.toStringAsFixed(5);
  ltcController.text = 1.toStringAsFixed(5);
  adaController.text = 1.toStringAsFixed(5);
  uniController.text = 1.toStringAsFixed(5);
  usdcController.text = 1.toStringAsFixed(5);
}

//Faz a busca na API
Future<List> getData() async {
  List<ResultCoin> list = await Future.wait(
      coins.map((itemId) => MercadoCoinService.fetchCoin(itemId)));
  return list.map((response) {
    return response;
  }).toList();
}

// inicio da home page
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
        //o futurebuilder o vai renderizar a tela quando o getData terminar seu processo
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            // switch para caso nao retornar algum erro
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Loading(); // enquanto faz a busca na API fica aparecendo a tela de Loading
            default:
              if (snapshot.hasError) {
                return const Center(
                  //caso houver erro na busca aparecer msg de erro na tela
                  child: Text(
                    "Erro ao Carregar Dados :(",
                    style: TextStyle(fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                carregaCryptos(snapshot
                    .data); //carrega as variaveis com os valores das cryptos buscadas na API
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: <Widget>[
                        _montaCrypto(
                            _dropdownController), //monta o textfild das cryptos
                        const Icon(Icons.swap_horiz, size: 50),
                        _montaCrypto('REAL'), // monta o textfield do real
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

  //funcao para montar o textfield para a entrada de dados
  Widget _montaCrypto(String controller) {
    if (controller != 'REAL') {
      return Container(
        padding: const EdgeInsets.all(10),
        height: 150,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 2),
              blurRadius: 15.0,
            ), //BoxShadow
          ],
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _dropdown(),
              montaTextfield(controller),
            ]),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(10),
        height: 150,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 2),
              blurRadius: 15.0,
            ), //BoxShadow
          ],
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Reais',
                  style: TextStyle(fontWeight: FontWeight.normal)),
              const Divider(),
              montaTextfield(controller),
            ]),
      );
    }
  }

  //dropdown para as escolhas das moedas a serem convertidas
  Widget _dropdown() {
    List<Item> coin = [
      const Item(' Bitcoin', 'lib/images/bitcoin.png', 'BTC'),
      const Item(' Litecoin', 'lib/images/litecoin.png', 'LTC'),
      const Item(' Cardano', 'lib/images/cardano.png', 'ADA'),
      const Item(' Uniswap', 'lib/images/uniswap.png', 'UNI'),
      const Item(' Usdc', 'lib/images/usdc.png', 'USDC'),
    ];

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: _dropdownController,
        icon: const Icon(Icons.arrow_drop_down_circle_outlined),
        iconSize: 30,
        elevation: 16,
        style: const TextStyle(color: Colors.black, fontSize: 25.0),
        onChanged: (String? newValue) {
          setState(() => (_dropdownController = newValue!));
        },
        items: coin.map((Item coin) {
          return DropdownMenuItem<String>(
            value: coin.value,
            child: Row(
              children: [
                Image.asset(coin.url, width: 30, height: 30),
                Text(coin.name),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  //monta os textfield conforme a moeda escolhida
  Widget montaTextfield(String coin) {
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

  //carrega as variaveis como os valores das cryptos buscadas na API
  void carregaCryptos(data) {
    _clearAll();
    btc = double.parse(data![0].ticker.buy);
    ltc = double.parse(data![1].ticker.buy);
    ada = double.parse(data![2].ticker.buy);
    uni = double.parse(data![3].ticker.buy);
    usdc = double.parse(data![4].ticker.buy);

    switch (_dropdownController) {
      case 'BTC':
        realController.text = btc.toStringAsFixed(5);
        break;
      case 'LTC':
        realController.text = ltc.toStringAsFixed(5);
        break;
      case 'ADA':
        realController.text = ada.toStringAsFixed(5);
        break;
      case 'UNI':
        realController.text = uni.toStringAsFixed(2);
        break;
      case 'USDC':
        realController.text = usdc.toStringAsFixed(2);
        break;
    }
  }

  late double btc;
  late double ltc;
  late double ada;
  late double uni;
  late double usdc;

  //função que realiza a conversao da moeda
  double _calculo(a, b, c) {
    double x = (b * c) / a;
    return x;
  }

  // inicia as funcoes que realizam a chamada do _calculo conforme o textfield é alterado
  void _realChanged(String text) {
    if (text == '') {
      text = '0';
    }

    double real = double.parse(text);
    switch (_dropdownController) {
      case 'BTC':
        btcController.text = _calculo(btc, 1, real).toStringAsFixed(5);
        break;
      case 'LTC':
        ltcController.text = _calculo(ltc, 1, real).toStringAsFixed(5);
        break;
      case 'ADA':
        adaController.text = _calculo(ada, 1, real).toStringAsFixed(5);
        break;
      case 'UNI':
        uniController.text = _calculo(uni, 1, real).toStringAsFixed(5);
        break;
      case 'USDC':
        usdcController.text = _calculo(usdc, 1, real).toStringAsFixed(5);
        break;
    }
  }

  void _btcChanged(String text) {
    if (text == '') {
      text = '0';
    } else {
      double? coin = double.tryParse(text);
      realController.text = _calculo(1, btc, coin).toStringAsFixed(2);
    }
  }

  void _ltcChanged(String text) {
    if (text == '') {
      text = '0';
    }
    double coin = double.parse(text);
    realController.text = _calculo(1, ltc, coin).toStringAsFixed(2);
  }

  void _adaChanged(String text) {
    if (text == '') {
      text = '0';
    }
    double coin = double.parse(text);
    realController.text = _calculo(1, ada, coin).toStringAsFixed(2);
  }

  void _uniChanged(String text) {
    if (text == '') {
      text = '0';
    }
    double coin = double.parse(text);
    realController.text = _calculo(1, uni, coin).toStringAsFixed(2);
  }

  void _usdcChanged(String text) {
    if (text == '') {
      text = '0';
    }
    double coin = double.parse(text);
    realController.text = _calculo(1, usdc, coin).toStringAsFixed(2);
  }
}

// funcao que renderiza o textfield
Widget buildTextField(
    TextEditingController c, String prefix, Function(String) f) {
  return TextField(
    inputFormatters: [
      FilteringTextInputFormatter.deny(RegExp('[-,]')),
    ],
    controller: c,
    onChanged: f,
    decoration: InputDecoration(
      enabledBorder: const OutlineInputBorder(
        // width: 0.0 produces a thin "hairline" border
        borderSide: BorderSide(color: Colors.amber, width: 3.0),
      ),
      prefixText: prefix,
    ),
    style: const TextStyle(color: Colors.black, fontSize: 25.0),
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
  );
}
