import 'package:credito_inteligente/screens/main_menu.dart';
import 'package:credito_inteligente/screens/register.dart';
import 'package:credito_inteligente/services/user_service.dart';
import 'package:credito_inteligente/styles/styles.dart';
import 'package:credito_inteligente/widgets/button.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/input_field.dart';
import '../widgets/snack_bar.dart';

class Login2 extends StatefulWidget {
  const Login2({super.key});

  @override
  State<Login2> createState() => _Login2State();
}

class _Login2State extends State<Login2> {
  String inputEmail = '';
  String inputPassword = '';
  bool buttonClicked = false;
  void _updateInputEmail(String text) {
    setState(() {
      inputEmail = text;
    });
  }

  void _updateInputPassword(String text) {
    setState(() {
      inputPassword = text;
    });
  }

  void getAllUsers() {
    UserService().getAllUsers().then((users) {
      print("This are the users");

      for (var user in users) {
        print(user.toString());
      }
    });
  }

  bool invalidEmail() {
    if (inputEmail.isEmpty) {
      return true;
    }

    if (inputEmail.contains("@") && inputEmail.contains(".")) {
      return false;
    }

    return true;
  }

  void getUserByEmailAndPassword() {
    String email = inputEmail;
    String password = inputPassword;

    if (invalidEmail() || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: CustomSnackBarContent(
            mainTile: "Campos Incorrectos!",
            errorText: "Por favor ingrese un email y contraseña correctos.",
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          duration: Duration(seconds: 5),
        ),
      );
      return;
    }

    UserService().getUserByEmailAndPassword(email, password).then((user) {
      if (user.id == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: CustomSnackBarContent(
              mainTile: "Usuario no encontrado!",
              errorText: "El usuario no se encuentra registrado en el sistema.",
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
            duration: Duration(seconds: 5),
          ),
        );
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => MainMenu(user: user)),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(children: [
          Container(
            margin: MediaQuery.of(context).size.width > webScreenWidth
                ? const EdgeInsets.symmetric(horizontal: 400)
                : const EdgeInsets.symmetric(horizontal: 35),
            width: double.infinity,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 70,
                  ),
                  Text(
                    "Iniciar Sesión",
                    style: GoogleFonts.poppins(
                        color: primaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 26),
                  Text("Bienvenido, te hemos\nechado de menos!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          color: secondaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 74),
                  InputFieldWidget(
                      hintText: "Email", onTextChanged: _updateInputEmail),
                  const SizedBox(height: 5),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text("Ingrese un email válido",
                        textAlign: TextAlign.right,
                        style: GoogleFonts.poppins(
                            color: invalidEmail() && buttonClicked
                                ? Colors.red
                                : const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                  ]),
                  const SizedBox(height: 15),
                  InputFieldWidget(
                      obscureText: true,
                      hintText: "Contraseña",
                      onTextChanged: _updateInputPassword),
                  const SizedBox(height: 5),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text("Ingrese una contraseña válida",
                        textAlign: TextAlign.right,
                        style: GoogleFonts.poppins(
                            color: inputPassword.isEmpty && buttonClicked
                                ? Colors.red
                                : const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                  ]),
                  const SizedBox(height: 5),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text("Olvidaste  tu contraseña?",
                        textAlign: TextAlign.right,
                        style: GoogleFonts.poppins(
                            color: primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                  ]),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: "Iniciar sesión",
                    buttonColor: primaryColor,
                    textColor: textColor,
                    onPressed: () {
                      setState(() {
                        buttonClicked = true;
                      });
                      getUserByEmailAndPassword();
                    },
                  ),
                  const SizedBox(height: 40),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Register()));
                    },
                    child: Text("Crear nueva cuenta",
                        textAlign: TextAlign.right,
                        style: GoogleFonts.poppins(
                            color: tertiaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 20),
                  Text("O continua con",
                      textAlign: TextAlign.right,
                      style: GoogleFonts.poppins(
                          color: primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < 3; i++)
                        Container(
                          margin: EdgeInsets.only(left: i == 0 ? 0 : 20),
                          width: 60,
                          height: 50,
                          decoration: const BoxDecoration(
                              color:
                                  iconButtonColor, // Background color of the container
                              borderRadius: BorderRadius.all(Radius.circular(
                                  10)) // Makes the container circular
                              ),
                          child: const Center(
                            child: Icon(
                              FeatherIcons
                                  .facebook, // Replace with your desired icon
                              size: 24,
                              color: Colors.black, // Color of the icon
                            ),
                          ),
                        )
                    ],
                  ),
                ]),
          ),
        ]),
      ),
    );
  }
}
