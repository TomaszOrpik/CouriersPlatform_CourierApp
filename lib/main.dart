import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:courier_app/providers/directions.dart';
import 'package:courier_app/providers/functionality.dart' show Functionality;
import 'package:courier_app/providers/packages.dart';
import 'package:courier_app/screens/help.screen.dart';
import 'package:courier_app/screens/login.screen.dart';
import 'package:courier_app/screens/navigation.screen.dart';
import 'package:courier_app/screens/packages.screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Functionality()),
        ChangeNotifierProvider(create: (ctx) => Packages()),
        ChangeNotifierProvider(create: (ctx) => Directions()),
      ],
      child: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  ConnectivityResult _connectionResult = ConnectivityResult.mobile;

  late StreamSubscription<ConnectivityResult> subscription;

  @override
  initState() {
    super.initState();
    subscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  dispose() {
    super.dispose();

    subscription.cancel();
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_connectionResult == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Brak połączenia z siecią!'),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {},
          ),
        ),
      );
    }

    final functionality = Provider.of<Functionality>(context);
    return MaterialApp(
      title: 'CourierApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            elevation: 0,
          )),
      home: functionality.isLogged
          ? const NavigationScreen()
          : const LoginScreen(),
      routes: {
        PackagesScreen.name: (BuildContext context) => functionality.isLogged
            ? const PackagesScreen()
            : const LoginScreen(),
        HelpScreen.name: (BuildContext context) =>
            functionality.isLogged ? HelpScreen() : const LoginScreen(),
      },
    );
  }
}
