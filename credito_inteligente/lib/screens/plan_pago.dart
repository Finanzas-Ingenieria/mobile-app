import 'package:credito_inteligente/models/plan_pago.dart';
import 'package:credito_inteligente/models/vehicle_loan.dart';
import 'package:credito_inteligente/services/vehicle_loan_service.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/plan_pago_row.dart';
import '../styles/styles.dart';
import '../widgets/button.dart';
import '../widgets/custom_table.dart';

class PlanDePago extends StatefulWidget {
  final VehicleLoan vehicleLoan;
  const PlanDePago({super.key, required this.vehicleLoan});

  @override
  State<PlanDePago> createState() => _PlanDePagoState();
}

class _PlanDePagoState extends State<PlanDePago> {
  late List<PlanPagoRow> rows;
  late PlanPago planPago;
  late VehicleLoan vehicleLoan;

  double getFlow() {
    return widget.vehicleLoan.vehiclePrice -
        0.2 * widget.vehicleLoan.vehiclePrice +
        widget.vehicleLoan.notaryCosts +
        widget.vehicleLoan.registrationCosts;
  }

  @override
  void initState() {
    super.initState();

    rows = [
      PlanPagoRow(
          month: 0,
          gracePeriod: '',
          date: DateFormat('dd/MM/yyyy').format(DateTime.now()),
          fc_initialAmount: 0,
          fc_interest: 0,
          fc_amortization: 0,
          fc_lifeEnsurance: 0,
          fc_finalAmount: 0,
          initialAmount: 0,
          interestAmount: 0,
          quota: 0,
          amortization: 0,
          lifeEnsurance: 0,
          vehicleInsurance: 0,
          physicalShipments: 0,
          administrativeCost: 0,
          finalAmount: 0,
          flow: getFlow())
    ];

    vehicleLoan = widget.vehicleLoan;
    planPago = PlanPago(planPagoRows: rows, vehicleLoan: vehicleLoan);
  }

  void savePaymentPlan() {
    VehicleLoanService().createVehicleLoan(vehicleLoan).then((value) => {
          if (value != null) {print("LETS GO BABAY"), print(value)}
        });
  }

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
                    ],
                  ),
                  CustomButton(
                      text: "Ver calendario",
                      buttonColor: Colors.indigo,
                      textColor: textColor,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CustomTable(
                                  planPago: planPago,
                                )));
                      }),
                  CustomButton(
                      text: "Guardar Plan de Pagos",
                      buttonColor: Colors.indigo,
                      textColor: textColor,
                      onPressed: () {
                        savePaymentPlan();
                      })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
