import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mantra_biometric/mantra_biometric.dart';
import 'package:mantra_biometric/utils/mantra_plugin_exception.dart';
import 'package:xml/xml.dart';
import 'package:collection/collection.dart';

void main() {
  runApp(
      MaterialApp(
        theme: ThemeData(
          useMaterial3: true
        ),
      home: MyApp(),

      )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _mantraBiometricPlugin = MantraBiometric();

  @override
  void initState() {
    super.initState();
  }

  displyAlert(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(message),
        ));
  }

  String result = "";

  getDeviceInfo() async {
    try {
      String output = await _mantraBiometricPlugin.getDeviceInformation() ?? "";
      result = output;
      setState(() {});
    } on RDClientNotFound catch (e) {
      displyAlert("Mantra RD Service not installed");
    } catch (e) {
      displyAlert("Something Went Wrong");
    }
  }

  scanFingerPrint() async {
    try {
      String wadh = "";
      String pidOptions =
          "<PidOptions ver=\"1.0\"> <Opts fCount=\"1\" fType=\"2\" pCount=\"0\" format=\"0\" pidVer=\"2.0\" wadh=\"$wadh\" timeout=\"20000\"  posh=\"UNKNOWN\" env=\"P\" /> </PidOptions>";
      result = await _mantraBiometricPlugin.captureFingerPrint(
          pidOptions: pidOptions) ??
          "";

      setState(() {});
    } on RDClientNotFound catch (e) {
      log("${e.code}");
      displyAlert("Mantra RD Service not installed");
    } catch (e) {
      displyAlert("Something Went Wrong ${e.runtimeType} $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biometric Testing'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: getDeviceInfo,
                child: const Text("Device Information"),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: scanFingerPrint,
                child: const Text("SCAN"),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(onPressed: ()async{
                await Clipboard.setData(ClipboardData(text: "$result"));
              }, child: Text("Copy")),
              const SizedBox(
                height: 20,
              ),
              Text("$result")
            ],
          ),
        ),
      ),
    );
  }
}