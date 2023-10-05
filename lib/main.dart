import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

const platform = MethodChannel('com.example/my_channel');

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _result;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      platform.setMethodCallHandler((call) async {
        switch (call.method) {
          case "DATA_RECEIVED":
            _result = call.arguments.toString();
            break;
          case "DATA_RECEIVED_ERROR":
            _result = "ERROR:\n${call.arguments.toString()}";
            break;
        }

        setState(() {});
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
          if (_result != null) Text(_result!),
          TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration:
                  const InputDecoration(labelText: 'Ingresa un ticket')),
          Center(
              child: ElevatedButton(
                  onPressed: _sendData, child: const Text("Enviar ejemplo")))
        ])));
  }

  Future<void> _sendData() async {
    final ticket = int.tryParse(_controller.text);
    if (ticket == null) return;

    await platform.invokeMethod('sendDataFromNative', {
      "ticket": ticket,
      "transactedAt": DateTime.now().toIso8601TimeZonedString()
    });
  }
}

extension DateTimeZoneExtension on DateTime {
  String myOwnTimeZoneFormatter({final Duration? offSet}) {
    final timeZone = offSet ?? timeZoneOffset;
    if (timeZone.inSeconds == 0) {
      return "Z";
    }
    return "${timeZone.isNegative ? "" : "+"}${NumberFormat("##00").format(timeZone.inHours)}:${NumberFormat("##00").format(timeZone.inMinutes - timeZone.inHours * 60)}";
  }

  String toIso8601TimeZonedString({final Duration? offSet}) =>
      "${toIso8601String()}${myOwnTimeZoneFormatter(offSet: offSet)}";
}
