import 'package:courier_app/providers/functionality.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final employeeNumberController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> _logIn(BuildContext context) async {
    await Provider.of<Functionality>(context, listen: false)
        .logIn(LoginData(
            login: employeeNumberController.text,
            password: passwordController.text))
        .then((isLogginCorrect) {
      if (isLogginCorrect) {
        Navigator.of(context).popAndPushNamed('/');
      } else {
        print('dialog to sgow');
        showDialog<String>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => AlertDialog(
                  title: const Text('Błąd logowania'),
                  content:
                      const Text('Wprowadzono nieprawidłowy login lub hasło!'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ));
      }
    });
  }

  @override
  void dispose() {
    employeeNumberController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('assets/images/logoExample.jpg'),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: TextField(
                controller: employeeNumberController,
                enableSuggestions: true,
                autocorrect: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'AAA11111',
                  labelText: 'Numer Pracownika',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Hasło',
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                _logIn(context);
              },
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'ZALOGUJ',
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
