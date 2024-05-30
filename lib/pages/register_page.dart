import 'package:biblioteca_cuc/provider/register_provider.dart';
import 'package:biblioteca_cuc/routes/routes.dart';
import 'package:biblioteca_cuc/utils/colors.dart';
import 'package:biblioteca_cuc/utils/show_snackbar.dart';
import 'package:biblioteca_cuc/widgets/circular_progress.dart';
import 'package:biblioteca_cuc/widgets/input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _identificationNumberController =
      TextEditingController();
  String _rol = Rol.TEACHER.name;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscure = true;
  bool _isLoading = false;

  Future<void> registerUser() async {
    final registerProvider =
        Provider.of<RegisterProvider>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // validate email
        final bool existUser =
            await registerProvider.checkUserExist(_emailController.text);
        if (existUser) {
          setState(() {
            _isLoading = false;
          });
          showSnackBar(context, "Este correo ya esta registrado");
          return;
        }

        await registerProvider.registerUser(
            email: _emailController.text,
            password: _passwordController.text,
            fullName: _fullNameController.text,
            identificationNumber: _identificationNumberController.text,
            rol: _rol,
            onError: (error) {
              showSnackBar(context, error);
              setState(() {
                _isLoading = false;
              });
            },
            onSuccess: () {
              setState(() {
                _isLoading = false;
              });
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.login, (route) => false);
            });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, e.toString());
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Registrate',
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
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
                        height: 20,
                      ),
                      InputDecorationWidget(
                        hintText: "jhon doe",
                        labelText: "Ingrese su nombre completo",
                        controller: _fullNameController,
                        keyboardType: TextInputType.text,
                        suffixIcon: const Icon(Icons.person_outline),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese sus nombres y apellidos';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InputDecorationWidget(
                        hintText: "10000000",
                        labelText: "Ingrese su numero de cedula",
                        controller: _identificationNumberController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese su numero de cedula';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InputDecorationWidget(
                        hintText: "user@example.com",
                        labelText: "Ingrese su correo",
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
                        height: 20,
                      ),
                      InputDecorationWidget(
                        hintText: "****************",
                        labelText: "Ingrese su contraseña",
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
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: const Text(
                          "Seleccione su rol",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Theme(
                        data: ThemeData(
                          unselectedWidgetColor: AppColors.blueColor,
                        ),
                        child: RadioListTile<String>(
                          value: Rol.TEACHER.name,
                          activeColor: Colors.blue,
                          groupValue: _rol,
                          title: const Text(
                            "Profesor",
                            style: TextStyle(color: Colors.blue),
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              _rol = value!;
                            });
                          },
                        ),
                      ),
                      Theme(
                        data: ThemeData(
                          unselectedWidgetColor: AppColors.blueColor,
                        ),
                        child: RadioListTile<String>(
                          value: Rol.STUDENT.name,
                          activeColor: Colors.blue,
                          title: const Text(
                            "Estudiante",
                            style: TextStyle(color: Colors.blue),
                          ),
                          groupValue: _rol,
                          onChanged: (String? value) {
                            setState(() {
                              _rol = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(height: 20),
                      _isLoading
                          ? const CircularProgressWidget(text: "Validando...")
                          : ElevatedButton(
                              onPressed: () async {
                                await registerUser();
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
                              child: const Text('Registrar'),
                            ),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
