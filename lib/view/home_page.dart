import 'package:flutter/material.dart';
import 'package:koinversor/service/mercado_bitcoin_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchCepController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchCepController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildLogo(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: const <Widget>[Text('texto aqui')],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Text('K', style: TextStyle(color: Colors.black, fontSize: 30)),
        Image.network(
          'https://media.giphy.com/media/4ylFrepUWnIcEjCTWm/giphy.gif',
          width: 30,
        ),
        const Text('inversor',
            style: TextStyle(color: Colors.black, fontSize: 30)),
      ],
    );
  }
}
