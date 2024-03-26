import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sender_native_app/result_page.dart';

const platform = MethodChannel('com.example/my_channel');

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MainPage());
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _contentFormKey = GlobalKey<FormState>();

  //inputs
  final _ticketController = TextEditingController();
  final _ticketKey = GlobalKey();

  //------
  final _notificationDetailsController = TextEditingController();
  final _notificationDetailsKey = GlobalKey();

  //------
  final _pumpNumberController = TextEditingController();
  final _pumpNumberKey = GlobalKey();

  //------
  final _dispatcherController = TextEditingController();
  final _dispatcherKey = GlobalKey();

  //------
  final _paymentMethodController = TextEditingController();
  final _paymentMethodKey = GlobalKey();

  //------
  final _requiredAmountOfMxnMoneyToRedeemController = TextEditingController();
  final _requiredAmountOfMxnMoneyToRedeemKey = GlobalKey();

  //------

  bool _addProduct = false;

  bool _amountToRedeemIsRequired = false;

  @override
  void dispose() {
    _ticketController.dispose();
    _notificationDetailsController.dispose();
    _pumpNumberController.dispose();
    _dispatcherController.dispose();
    _paymentMethodController.dispose();
    _contentFormKey.currentState?.dispose();
    _requiredAmountOfMxnMoneyToRedeemController.dispose();
    super.dispose();
  }

  String? _errorResult;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      platform.setMethodCallHandler((call) async {
        setState(() => _errorResult = null);

        switch (call.method) {
          case "DATA_RECEIVED":
            final result = call.arguments.toString();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ResultPage(result: result)));
            _cleanInputs();
            break;
          case "DATA_RECEIVED_ERROR":
            _errorResult = "ERROR:\n${call.arguments.toString()}";
            break;
        }

        setState(() {});
      });
    });
    super.initState();
  }

  AppBar _appBar() {
    return AppBar(title: const Text("Generador de consumos"));
  }

  Widget _customInput(
      {required final GlobalKey inputKey,
      required final TextEditingController controller,
      final InputDecoration? decoration,
      final TextInputType? keyboardType = TextInputType.name,
      final bool canBeBlank = false,
      final String? Function(String)? validations}) {
    return TextFormField(
        key: inputKey,
        controller: controller,
        decoration: decoration,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return (canBeBlank) ? null : "Este campo no debe estar vacio";
          }

          if (validations != null) {
            final result = validations(value);
            if (result != null) return result;
          }

          return null;
        });
  }

  Widget _form() {
    return Form(
        key: _contentFormKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _customInput(
                  inputKey: _ticketKey,
                  controller: _ticketController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: "Ticket", hintText: "Introdusca ticket"),
                  validations: (value) {
                    if (int.tryParse(value) == null) return "Debe ser numerico";
                    return null;
                  }),
              _customInput(
                  inputKey: _pumpNumberKey,
                  controller: _pumpNumberController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: "Número de bomba",
                      hintText: "Introdusca número de bomba"),
                  validations: (value) {
                    if (int.tryParse(value) == null) return "Debe ser numerico";
                    return null;
                  }),
              _customInput(
                  inputKey: _dispatcherKey,
                  controller: _dispatcherController,
                  decoration: const InputDecoration(
                      labelText: "Despachador",
                      hintText: "Introdusca despachador")),
              _customInput(
                  inputKey: _notificationDetailsKey,
                  controller: _notificationDetailsController,
                  decoration: const InputDecoration(
                      labelText: "Detalle de notifiaciones",
                      hintText: "Introdusca detalle de notifiaciones")),
              _customInput(
                  inputKey: _paymentMethodKey,
                  controller: _paymentMethodController,
                  decoration: const InputDecoration(
                      labelText: "Método de pago",
                      hintText: "Introdusca método de pago")),
              _customInput(
                  inputKey: _requiredAmountOfMxnMoneyToRedeemKey,
                  controller: _requiredAmountOfMxnMoneyToRedeemController,
                  canBeBlank: true,
                  validations: (value) {
                    if (double.tryParse(value) == null) {
                      return "Debe ser numerico";
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                      labelText: "Cantidad de \$MXN a redimir",
                      hintText: "Introdusca la cantidad a redimir"))
            ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        body: SafeArea(
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(5),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_errorResult != null) Text(_errorResult!),
                      _form(),
                      SwitchListTile(
                          value: _addProduct,
                          title: const Text("Agregar producto seco"),
                          onChanged: (value) => setState(() {
                                _addProduct = value;
                              })),
                      SwitchListTile(
                          value: _amountToRedeemIsRequired,
                          title: const Text("El pago es de 1 exhibición"),
                          onChanged: (value) => setState(() {
                                _amountToRedeemIsRequired = value;
                              })),
                      const SizedBox(height: 5),
                      Center(
                          child: ElevatedButton(
                              onPressed: _sendData,
                              child: const Text("Enviar ejemplo")))
                    ]))));
  }

  Future<void> _sendData() async {
    if (_contentFormKey.currentState?.validate() != true) return;

    await platform.invokeMethod('sendDataFromNative', {
      "ticket": int.parse(_ticketController.text.trim()),
      "pumpNumber": int.parse(_pumpNumberController.text.trim()),
      "dispatcher": _dispatcherController.text.trim(),
      "notificationDetails": _notificationDetailsController.text.trim(),
      "paymentMethod": _paymentMethodController.text.trim(),
      "addProduct": _addProduct,
      "transactedAt": DateTime.now().toIso8601TimeZonedString(),
      "requiredAmountOfMxnMoneyToRedeem":
          (_requiredAmountOfMxnMoneyToRedeemController.text.isEmpty)
              ? null
              : double.parse(
                  _requiredAmountOfMxnMoneyToRedeemController.text.trim()),
      "amountToRedeemIsRequired": _amountToRedeemIsRequired
    });
  }

  void _cleanInputs() {
    _ticketController.clear();
    _notificationDetailsController.clear();
    _pumpNumberController.clear();
    _dispatcherController.clear();
    _paymentMethodController.clear();
    _requiredAmountOfMxnMoneyToRedeemController.clear();
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
