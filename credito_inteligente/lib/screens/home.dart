import 'package:credito_inteligente/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:credito_inteligente/styles/styles.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Crédito vehicular inteligente",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: primaryColor,
                    fontSize: 35,
                    fontWeight: FontWeight.w600,
                  )),
              const SizedBox(height: 27),
              Text(
                  "Disfruta los mejores años de tu auto con Compra Inteligente",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.w400)),
              const SizedBox(height: 58),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomButton(
                        text: "Iniciar Sesión",
                        buttonColor: primaryColor,
                        textColor: textColor),
                    CustomButton(
                        text: "Registrarse",
                        buttonColor: textColor,
                        textColor: homeTextColor)
                  ],
                ),
              )
            ]),
      )),
    );
  }
}
