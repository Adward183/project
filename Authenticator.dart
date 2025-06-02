import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authenticator',
      theme: ThemeData(
        primaryColor: Colors.blueAccent, 
        scaffoldBackgroundColor: Colors.white, 
        appBarTheme: AppBarTheme(
          elevation: 0, 
        ),
      ),
      home: AuthenticatorHomePage(),
    );
  }
}

class AuthenticatorHomePage extends StatefulWidget {
  @override
  _AuthenticatorHomePageState createState() => _AuthenticatorHomePageState();
}

class _AuthenticatorHomePageState extends State<AuthenticatorHomePage> {
  final List<String> accounts = ['Account 1'];
  final List<String> otpCodes = [];
  int timeRemaining = 30;

  @override
  void initState() {
    super.initState();
    generateOtpCodes();
    startTimer();
  }

  void generateOtpCodes() {
    otpCodes.clear();
    for (var account in accounts) {
      otpCodes.add(_generateRandomString(6));
    }
    setState(() {});
  }

  String _generateRandomString(int length) {
    const characters = '0123456789';
    Random random = Random();
    return List.generate(length, (index) => characters[random.nextInt(characters.length)]).join();
  }

  void startTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (timeRemaining > 0) {
        setState(() {
          timeRemaining--;
        });
        if (timeRemaining == 0) {
          generateOtpCodes();
          timeRemaining = 30; 
        }
        startTimer();
      }
    });
  }

  void addNewAccount() {
    setState(() {
      accounts.add('Account ${accounts.length + 1}');
      generateOtpCodes();
    });
  }

  void removeAccount(int index) {
    setState(() {
      accounts.removeAt(index);
      otpCodes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authenticator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: accounts.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(accounts[index]),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  otpCodes[index],
                                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Осталось времени: $timeRemaining секунд',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () => removeAccount(index),
                                  child: Text('Удалить', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: addNewAccount,
              child: Text('Добавить новый аккаунт'),
            ),
            SizedBox(height: 16), 
            ElevatedButton(
              onPressed: generateOtpCodes,
              child: Text('Сгенерировать новые коды'),
            ),
          ],
        ),
      ),
    );
  }
}
