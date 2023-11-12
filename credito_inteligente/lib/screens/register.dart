import 'package:credito_inteligente/models/user.dart';
import 'package:credito_inteligente/services/user_service.dart';
import 'package:credito_inteligente/widgets/input_field.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../styles/styles.dart';
import '../widgets/button.dart';
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
    User newUser = User(
      id: 0,
      name: inputName,
      lastname: inputLastname,
      email: inputEmail,
      password: inputPassword,
    );

    UserService().createUser(newUser).then((user) {
      print("User created");
      print(user.toString());

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const Login2()));
    });
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
                    height: 97,
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
                  const SizedBox(height: 54),
                  InputFieldWidget(
                      hintText: "Nombre", onTextChanged: _updateInputName),
                  const SizedBox(height: 26),
                  InputFieldWidget(
                      hintText: "Apellido",
                      onTextChanged: _updateInputLastname),
                  const SizedBox(height: 26),
                  InputFieldWidget(
                      hintText: "Email", onTextChanged: _updateInputEmail),
                  const SizedBox(height: 26),
                  InputFieldWidget(
                      obscureText: true,
                      hintText: "Contraseña",
                      onTextChanged: _updateInputPassword),
                  const SizedBox(height: 34),
                  CustomButton(
                    text: "Crear cuenta",
                    buttonColor: primaryColor,
                    textColor: textColor,
                    onPressed: () {
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
                  )
                ])),
      ],
    ));
  }
}
