import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  bool passwordVisible = false;
  late bool _rememberMe;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    passwordVisible = true;
    _loadPreferences();
  }

  // Method to load the shared preference data
  void _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _usernameController.text = prefs.getString('username') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
      _rememberMe = prefs.getBool('rememberMe') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Shared Preferences'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter your username',
                    filled: true),
                onChanged: (value) {},
              ),
              TextField(
                controller: _passwordController,
                obscureText: passwordVisible,
                decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: '********',
                    alignLabelWithHint: false,
                    filled: true,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(
                          () {
                            passwordVisible = !passwordVisible;
                          },
                        );
                      },
                      icon: Icon(passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                    )),
              ),
              CheckboxListTile(
                title: Text('Remember me'),
                value: _rememberMe,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value!;
                  });
                },
              ),
              TextButton(
                child: Text('Save'),
                onPressed: () async {
                  if (_rememberMe) {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setString('username', _usernameController.text);
                    prefs.setString('password', _passwordController.text);
                    prefs.setBool('rememberMe', _rememberMe);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
