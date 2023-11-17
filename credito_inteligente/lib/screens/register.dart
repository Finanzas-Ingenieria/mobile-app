import 'package:credito_inteligente/models/user.dart';
import 'package:credito_inteligente/services/user_service.dart';
import 'package:credito_inteligente/widgets/input_field.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../styles/styles.dart';
import '../widgets/button.dart';
import '../widgets/snack_bar.dart';
import 'login2.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String inputName = '';
  String inputLastname = '';
  String inputEmail = '';
  String inputPassword = '';
  bool buttonClicked = false;

  void _updateInputName(String text) {
    setState(() {
      inputName = text;
    });
  }

  void _updateInputLastname(String text) {
    setState(() {
      inputLastname = text;
    });
  }

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

  void createUser() {
    if (inputName.isNotEmpty &&
        inputLastname.isNotEmpty &&
        !invalidEmail() &&
        inputPassword.length > 4) {
      User newUser = User(
        id: 0,
        name: inputName,
        lastname: inputLastname,
        email: inputEmail,
        password: inputPassword,
      );

      UserService().getUserByEmail(inputEmail).then((user) {
        if (user.id != 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: CustomSnackBarContent(
                mainTile: "Email Existente!",
                errorText:
                    "Este email ya esta registrado, por favor ingrese otro.",
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              elevation: 0,
              duration: Duration(seconds: 5),
            ),
          );
          return;
        } else {
          UserService().createUser(newUser).then((user) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const CustomSnackBarContent(
                  topPosition: -5,
                  mainTile: "¡Usuario Creado!",
                  errorText: " El usuario se ha creado de manera exitosa.",
                  backgroundColor: Color.fromARGB(255, 63, 118, 195),
                  iconsColor: Color.fromARGB(255, 34, 75, 132),
                ),
                behavior: SnackBarBehavior.floating,
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.85),
                backgroundColor: Colors.transparent,
                elevation: 0,
                duration: const Duration(seconds: 3),
              ),
            );

            Future.delayed(const Duration(seconds: 5), () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Login2()));
            });
          });
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: CustomSnackBarContent(
            mainTile: "Campos vacíos!",
            errorText: "Por favor llene todos los campos de manera correcta.",
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          duration: Duration(seconds: 5),
        ),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Container(
            margin: MediaQuery.of(context).size.width > webScreenWidth
                ? const EdgeInsets.symmetric(horizontal: 400)
                : const EdgeInsets.symmetric(horizontal: 35),
            width: double.infinity,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 70,
                  ),
                  Text(
                    "Crear cuenta",
                    style: GoogleFonts.poppins(
                        color: primaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                      "Crea una cuenta para poder utilizar nuestra herramienta",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          color: tertiaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 40),
                  InputFieldWidget(
                      hintText: "Nombre", onTextChanged: _updateInputName),
                  const SizedBox(height: 5),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text("Ingrese un nombre válido",
                        textAlign: TextAlign.right,
                        style: GoogleFonts.poppins(
                            color: inputName.isEmpty && buttonClicked
                                ? Colors.red
                                : const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                  ]),
                  const SizedBox(height: 15),
                  InputFieldWidget(
                      hintText: "Apellido",
                      onTextChanged: _updateInputLastname),
                  const SizedBox(height: 5),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text("Ingrese un apellido válido",
                        textAlign: TextAlign.right,
                        style: GoogleFonts.poppins(
                            color: inputLastname.isEmpty && buttonClicked
                                ? Colors.red
                                : const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                  ]),
                  const SizedBox(height: 15),
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
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text("La contraseña debe tener al menos 5 caracteres",
                        textAlign: TextAlign.right,
                        style: GoogleFonts.poppins(
                            color: (inputPassword.isEmpty ||
                                        inputPassword.length <= 4) &&
                                    buttonClicked
                                ? Colors.red
                                : const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                  ]),
                  const SizedBox(height: 22),
                  CustomButton(
                    text: "Crear cuenta",
                    buttonColor: primaryColor,
                    textColor: textColor,
                    onPressed: () {
                      setState(() {
                        buttonClicked = true;
                      });
                      createUser();
                    },
                  ),
                  const SizedBox(height: 30),
                  InkWell(
                    onTap: () => {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Login2()))
                    },
                    child: Text("ya tienes una cuenta?",
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
                          child: Center(
                            child: Icon(
                              i == 1
                                  ? FeatherIcons.instagram
                                  : FeatherIcons
                                      .facebook, // Replace with your desired icon
                              size: 24,
                              color: Colors.black, // Color of the icon
                            ),
                          ),
                        )
                    ],
                  ),
                ])),
      ],
    ));
  }
}
