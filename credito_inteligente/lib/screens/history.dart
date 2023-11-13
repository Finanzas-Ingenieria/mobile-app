import 'dart:math';

import 'package:credito_inteligente/models/vehicle_loan.dart';
import 'package:credito_inteligente/screens/plan_pago.dart';
import 'package:credito_inteligente/services/vehicle_loan_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/user.dart';
import '../styles/styles.dart';

class History extends StatefulWidget {
  final User user;
  const History({
    super.key,
    required this.user,
  });

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<VehicleLoan> vehicleLoansList = [];

  @override
  void initState() {
    super.initState();
    getVehicleLoans();
  }

  void getVehicleLoans() {
    VehicleLoanService()
        .getVehicleLoansByUserId(widget.user.id)
        .then((vehicleLoans) {
      if (vehicleLoans.isEmpty) {
        print("No vehicle loans found");
        return [];
      } else {
        print("Vehicle loans found");
        print(vehicleLoans);

        setState(() {
          vehicleLoansList = vehicleLoans;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Color generateRandomColor() {
      final Random random = Random();
      final int r = random
          .nextInt(256); // Generate a random value for the red channel (0-255)
      final int g = random.nextInt(
          256); // Generate a random value for the green channel (0-255)
      final int b = random
          .nextInt(256); // Generate a random value for the blue channel (0-255)

      return Color.fromARGB(255, r, g, b); // Create and return a Color object
    }

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Center(
                  child: Text(
                    "Historial",
                    style: GoogleFonts.readexPro(
                      color: tertiaryColor,
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  "Planes generados",
                  style: GoogleFonts.readexPro(
                    color: tertiaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.785, // Set a fixed height for the list
                  child: vehicleLoansList.isEmpty
                      ? Center(
                          child: Text(
                              "No has generado ningún plan de crédito vehicular",
                              style: GoogleFonts.readexPro(
                                color: tertiaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              )),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: vehicleLoansList.length,
                          itemBuilder: (context, index) {
                            final vehicleLoan = vehicleLoansList[index];
                            final initials =
                                vehicleLoan.client.name[0].toUpperCase();

                            return ListTile(
                              onTap: () {
                                //navigate to PlanPago using material page route
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PlanDePago(
                                              vehicleLoan: vehicleLoan,
                                              fromHistory: true,
                                            )));
                              },
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: generateRandomColor(),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                    child: Text(
                                  initials,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                )),
                              ),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      "${vehicleLoan.client.name} ${vehicleLoan.client.lastname}"),
                                  const SizedBox(width: 8),
                                  Text(vehicleLoan.currency == "PEN"
                                      ? "s/.${vehicleLoan.vehiclePrice}"
                                      : "\$${vehicleLoan.vehiclePrice}"),
                                ],
                              ),
                              subtitle: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(DateFormat('dd/MM/yyyy').format(
                                          DateTime.parse(
                                              vehicleLoan.startedDate))),
                                      const Text('Auto'),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
