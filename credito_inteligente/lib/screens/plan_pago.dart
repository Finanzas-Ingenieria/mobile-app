import 'package:credito_inteligente/widgets/custom_table.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../styles/styles.dart';

class PlanDePago extends StatelessWidget {
  const PlanDePago({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Plan de Pagos"),
          leading: InkWell(
              onTap: () => Navigator.pop(context),
              child: const Icon(FeatherIcons.arrowLeft)),
        ),
        body: ListView(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text("Datos del Cliente",
                      style: GoogleFonts.readexPro(
                          color: tertiaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                  Text("Juan Perez Ramos",
                      style: GoogleFonts.readexPro(
                          color: homeInputFileTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Datos del Cliente",
                              style: GoogleFonts.readexPro(
                                  color: tertiaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                          Text("Juan Perez Ramos",
                              style: GoogleFonts.readexPro(
                                  color: homeInputFileTextColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(width: 100),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Datos del Cliente",
                              style: GoogleFonts.readexPro(
                                  color: tertiaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                          Text("Juan Perez Ramos",
                              style: GoogleFonts.readexPro(
                                  color: homeInputFileTextColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const Column(
                        children: [],
                      )
                    ],
                  ),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("TEA: ",
                              style: GoogleFonts.readexPro(
                                  color: tertiaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                          Text("32.21%",
                              style: GoogleFonts.readexPro(
                                  color: homeInputFileTextColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(width: 150),
                      Row(
                        children: [
                          Text("TCEA: ",
                              style: GoogleFonts.readexPro(
                                  color: tertiaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                          Text("35.32%",
                              style: GoogleFonts.readexPro(
                                  color: homeInputFileTextColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("VAN: ",
                              style: GoogleFonts.readexPro(
                                  color: tertiaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                          Text("12345",
                              style: GoogleFonts.readexPro(
                                  color: homeInputFileTextColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(width: 156),
                      Row(
                        children: [
                          Text("TIR: ",
                              style: GoogleFonts.readexPro(
                                  color: tertiaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                          Text("35.32%",
                              style: GoogleFonts.readexPro(
                                  color: homeInputFileTextColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Fecha de inicio",
                              style: GoogleFonts.readexPro(
                                  color: tertiaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                          Text("12/12/2020",
                              style: GoogleFonts.readexPro(
                                  color: homeInputFileTextColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(width: 130),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Plazo",
                              style: GoogleFonts.readexPro(
                                  color: tertiaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                          Text("5 meses",
                              style: GoogleFonts.readexPro(
                                  color: homeInputFileTextColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const CustomTable()
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
