import 'package:flutter/material.dart';
import 'package:telasapp/screens/home.dart';
import 'package:telasapp/screens/listaurl.dart';
import 'package:telasapp/screens/webview_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: webview()));
}
