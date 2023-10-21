import 'package:credito_inteligente/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../styles/styles.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    Text(
                      "Crédito Vehicular\nCompra Inteligente",
                      style: GoogleFonts.readexPro(
                          color: tertiaryColor,
                          fontSize: 30,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 30),
                    Text("Datos del Cliente",
                        style: GoogleFonts.readexPro(
                            color: tertiaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 24),
                    InputFieldWidget(
                        hintText: "Nombres", onTextChanged: (string) {}),
                    const SizedBox(height: 11),
                    InputFieldWidget(
                        hintText: "Apellidos", onTextChanged: (string) {}),
                    const SizedBox(height: 39),
                    Text("Moneda",
                        style: GoogleFonts.readexPro(
                            color: tertiaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
