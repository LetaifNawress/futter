import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restaurant/category/category.dart';
import 'package:restaurant/service/authService.dart';
import 'package:restaurant/auth/register.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  String email = '';
  String password = '';
  String error = '';
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: _image != null
                ? FileImage(_image!)
                : AssetImage('assets/resto.jpeg') as ImageProvider<Object>,
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    SizedBox(
                      width: 250,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          filled: true,
                          fillColor: Color.fromARGB(255, 219, 211, 211),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                    ),
                    SizedBox(height: 10.0),
                    SizedBox(
                      width: 250,
                      child: TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          filled: true,
                          fillColor: Color.fromARGB(255, 219, 211, 211),
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
                          dynamic result =
                              await _auth.signInWithEmailAndPassword(
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
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: FaIcon(FontAwesomeIcons.facebook),
                          onPressed: () {
                            // Gérer la connexion Facebook
                          },
                        ),
                        SizedBox(width: 20.0),
                        IconButton(
                          icon: FaIcon(FontAwesomeIcons.google),
                          onPressed: () {
                            // Gérer la connexion Google
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
