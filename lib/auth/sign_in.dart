import 'package:flutter/material.dart';
import 'package:restaurant/category/category.dart';

import 'package:restaurant/service/authService.dart';
import 'package:restaurant/auth/register.dart';
// Assurez-vous que l'importation est correcte

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  // État des champs de texte
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 246, 248, 250),
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        elevation: 0.0,
        title: Text('Connectez-vous à l\'application Restaurant'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                  ),
                ),
                SizedBox(height: 10.0),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue[400],
                    onPrimary: Colors.white,
                  ),
                  onPressed: () async {
                    if (email.isNotEmpty && password.isNotEmpty) {
                      dynamic result = await _auth.signInWithEmailAndPassword(
                        email,
                        password,
                      );

                      if (result == null) {
                        setState(() {
                          error =
                              'Erreur de connexion. Vérifiez vos identifiants.';
                        });
                        _showErrorDialog();
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryScreen()),
                        );
                      }
                    } else {
                      setState(() {
                        error =
                            'Veuillez saisir un e-mail et un mot de passe valides.';
                      });
                      _showErrorDialog();
                    }
                  },
                  child: Text('Se connecter'),
                ),
                SizedBox(height: 10.0),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Register()),
                    );
                  },
                  child: Text(
                    'Vous n\'avez pas de compte ? Inscrivez-vous ici',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erreur'),
          content: Text(error),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
