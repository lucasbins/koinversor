import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  _loading() {
    return Column(
      children: const <Widget>[
        CircularProgressIndicator(
          color: Colors.white,
        ),
        Divider(
          height: 20,
          color: Colors.amber,
        ),
        Text(
          "Carregando Dados...",
          style: TextStyle(color: Colors.black, fontSize: 25.0),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [_loading()],
    );
  }
}
