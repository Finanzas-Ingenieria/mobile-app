import 'package:credito_inteligente/screens/buscar_plan_pago.dart';
import 'package:credito_inteligente/screens/login2.dart';
import 'package:flutter/material.dart';
import 'package:credito_inteligente/styles/styles.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/button.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
          body: SizedBox(
        width: double.infinity,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/icons/car2.png",
                width: screenWidth * 0.2,
              ),
              const SizedBox(height: 20),
              Text("Crédito vehicular inteligente",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: primaryColor,
                    fontSize: 35,
                    fontWeight: FontWeight.w600,
                  )),
              const SizedBox(height: 20),
              Text(
                  "Disfruta los mejores años de tu auto con Compra Inteligente",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.w400)),
              const SizedBox(height: 40),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomButton(
                    text: "Quiero Unirme",
                    buttonColor: primaryColor,
                    textColor: textColor,
                    width: screenWidth * 0.45,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Login2()));
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: "Ver mi plan de pagos",
                    buttonColor: textColor,
                    textColor: homeTextColor,
                    width: screenWidth * 0.45,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const BuscarPlanPago()));
                    },
                  )
                ],
              )
            ]),
      )),
    );
  }
}
