import 'package:credito_inteligente/styles/styles.dart';
import 'package:credito_inteligente/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Login2 extends StatelessWidget {
  const Login2({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 97,
                ),
                Text(
                  "Iniciar Sesión",
                  style: GoogleFonts.poppins(
                      color: primaryColor,
                      fontSize: 30,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 27,
                ),
                Text("Bienvenido, te hemos\nechado de menos!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        color: secondaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600)),
                const SizedBox(
                  height: 74,
                ),
                const Text("Olvidaste  tu contraseña?"),
                const CustomButton(
                    text: "Iniciar sesión",
                    buttonColor: primaryColor,
                    textColor: textColor),
                const Text("Crear nueva cuenta"),
                const Text("O continua con"),
              ]),
        ),
      ),
    );
  }
}
