import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final String result;

  const ResultPage({super.key, required this.result});

  AppBar _appBar() {
    return AppBar(title: const Text("Resultado"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        body: SafeArea(
            child:
                Scrollbar(child: SingleChildScrollView(child: Text(result)))));
  }
}
