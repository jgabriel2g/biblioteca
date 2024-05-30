import 'package:biblioteca_cuc/provider/login_provider.dart';
import 'package:biblioteca_cuc/routes/routes.dart';
import 'package:biblioteca_cuc/utils/show_snackbar.dart';
import 'package:biblioteca_cuc/widgets/circular_progress.dart';
import 'package:biblioteca_cuc/widgets/input_decoration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscure = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((result) {
      if (result != null) {
        Navigator.pushNamed(context, Routes.home, arguments: result);
      }
    });
  }

  Future<void> login() async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await loginProvider.login(
        email: _emailController.text,
        password: _passwordController.text,
        onSuccess: (user) async {
          setState(() {
            _isLoading = false;
          });
        },
        onError: (error) {
          showSnackBar(context, error);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 200,
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 50),
              child: Center(
                child: Text(
                  'Iniciar Sesion',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      InputDecorationWidget(
                        hintText: "user@example.com",
                        labelText: "Ingrese su email",
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        suffixIcon: const Icon(Icons.email_outlined),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese su correo';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      InputDecorationWidget(
                        hintText: "********",
                        labelText: "Ingrese su password",
                        controller: _passwordController,
                        obscureText: _isObscure,
                        maxLines: 1,
                        keyboardType: TextInputType.visiblePassword,
                        suffixIcon: IconButton(
                          icon: Icon(_isObscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese su contraseña';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      _isLoading
                          ? const CircularProgressWidget(text: "Validando...")
                          : ElevatedButton(
                              onPressed: () async {
                                await login();
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 50,
                                  vertical: 20,
                                ),
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              child: const Text('Inicia Sesion'),
                            ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // const Text("Registrate"),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, Routes.register);
                            },
                            child: const Text("Registrate Aqui!"),
                          )
                        ],
                      )
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
