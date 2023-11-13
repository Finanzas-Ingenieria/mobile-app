import 'dart:math';

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
import '../widgets/snack_bar.dart';
import 'main_menu.dart';

class PlanDePago extends StatefulWidget {
  final VehicleLoan vehicleLoan;
  final bool fromHistory;
  const PlanDePago(
      {super.key, required this.vehicleLoan, this.fromHistory = false});

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

  //DTA FROM OTHER SCREEN

  //Create basic data
  late double vehiclePrice;
  late double paymentPeriod;
  late double initialCarPaymentPercentage;
  late double loanPercentage;
  late double finalCarPaymentPercentage;
  late String rateType;
  late double rateAnualPercentage;
  late double rateMonthlyPercentage;

  late double notaryCost;
  late double registryCost;
  late double appraisalCost;

  late double physicalShipment;
  late double administativeCost;
  late double desgravamenRatePercentage;
  late double vehicleInsurancePercentage;

  late double initialQuota;
  late double finalQuota;
  late double loanAmount;
  late double balanceToFinance;
  late double vehicleInsuranceAmount;
  late int gracePeriod;
  late String graceType;

  double convertToMonthlyRate(double rate) {
    if (rateType == 'TEA') {
      return pow(1 + rate, 1 / 12) - 1;
    } else {
      return rate / 12; // UPDATE THIS
    }
  }

  String getLastQuotaMessage(type) {
    if (type == "RENOVAR") {
      return "Tienes un saldo a Favor de S/ 1,000.00";
    } else if (type == "QUEDAR") {
      return "Valor del último Cuoton S/ 1,000.00";
    } else {
      return "Tienes un saldo a Favor de S/ 200";
    }
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

    //DATA FROM OTHER SCREEN
    vehiclePrice = planPago.vehicleLoan.vehiclePrice;
    paymentPeriod = planPago.vehicleLoan.paymentPeriod.toDouble();
    initialCarPaymentPercentage = 0.2; // 20% of vehiclePrice
    loanPercentage = planPago.vehicleLoan.loanPercentage; // 80% of vehiclePrice
    finalCarPaymentPercentage =
        1 - initialCarPaymentPercentage - loanPercentage;
    rateType = planPago.vehicleLoan.rateType;
    rateAnualPercentage = planPago.vehicleLoan.rateAmount;
    rateMonthlyPercentage = convertToMonthlyRate(rateAnualPercentage);

    notaryCost = planPago.vehicleLoan.notaryCosts;
    registryCost = planPago.vehicleLoan.registrationCosts;
    appraisalCost = planPago.vehicleLoan.appraisal;

    physicalShipment = planPago.vehicleLoan.physicalShipment;
    administativeCost = planPago.vehicleLoan.administrationCosts;
    desgravamenRatePercentage = planPago.vehicleLoan.desgravamenRate;
    vehicleInsurancePercentage = planPago.vehicleLoan.vehicleInsurance;

    initialQuota = vehiclePrice * initialCarPaymentPercentage;
    finalQuota = vehiclePrice * finalCarPaymentPercentage;
    loanAmount = vehiclePrice - initialQuota + notaryCost + registryCost;
    balanceToFinance = getLoanBalanceToFinance(loanAmount, finalQuota,
        rateMonthlyPercentage, desgravamenRatePercentage, paymentPeriod);

    vehicleInsuranceAmount =
        getVehicleInsuranceAmount(vehiclePrice, vehicleInsurancePercentage);

    gracePeriod = planPago.vehicleLoan.gracePeriod;
    graceType = planPago.vehicleLoan.graceType;

    planPago = planPago;
    rows = planPago.planPagoRows;
    generateRows();
  }

  double getLoanBalanceToFinance(
      double loanAmount,
      double finalQuota,
      double rateMonthlyPercentage,
      double desgravamenRatePercentage,
      double month) {
    double resultado = loanAmount -
        (finalQuota /
            pow(1 + rateMonthlyPercentage + desgravamenRatePercentage,
                month + 1));

    resultado = double.parse(resultado.toStringAsFixed(5));

    return resultado;
  }

  double getVehicleInsuranceAmount(
      double vehiclePrice, double vehicleInsurancePercentage) {
    double resultado = vehicleInsurancePercentage * vehiclePrice / 12;

    resultado = double.parse(resultado.toStringAsFixed(5));

    return resultado;
  }

  void savePaymentPlan() {
    VehicleLoanService().createVehicleLoan(vehicleLoan).then((value) => {
          if (value != null)
            {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const CustomSnackBarContent(
                    topPosition: -5,
                    mainTile: "¡Plan de pagos creado!",
                    errorText: "Se creo el plan de pagos de manera exitosa!",
                    backgroundColor: Color.fromARGB(255, 63, 118, 195),
                    iconsColor: Color.fromARGB(255, 34, 75, 132),
                  ),
                  behavior: SnackBarBehavior.floating,
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.78),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  duration: const Duration(seconds: 4),
                ),
              ),

              //waiut for 3 seconds
              Future.delayed(const Duration(seconds: 6), () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MainMenu(user: vehicleLoan.user, firstScreen: 1)));
              })
            }
        });
  }

  String addOneMonthToCurrentDate(String date) {
    DateTime currentDate = DateFormat('dd/MM/yyyy').parse(date);

    // Add one month to the current date
    DateTime newDate =
        DateTime(currentDate.year, currentDate.month + 1, currentDate.day);

    // Format the new date with leading zeros for day and month, and 'yyyy' for the year
    String formattedDate = DateFormat('dd/MM/yyyy').format(newDate);

    return formattedDate;
  }

  String getGracePeriodType(int month) {
    if (month > gracePeriod) {
      return 'S';
    } else {
      return graceType;
    }
  }

  double calculateQuota(
      double initialCapital,
      double rateAmount,
      double desgravamenRate,
      double paymentPeriod,
      int lastMonth,
      String periodGrace) {
    if (periodGrace == 'T') {
      return 0;
    } else if (periodGrace == 'P') {
      return initialCapital * rateAmount;
    } else {
      double resultado = (initialCapital * (rateAmount + desgravamenRate)) /
          (1 -
              pow(1 + (rateAmount + desgravamenRate),
                  -(paymentPeriod - lastMonth)));

      // Limitar a 3 decimales
      resultado = double.parse(resultado.toStringAsFixed(5));
      return resultado;
    }
  }

  double calculateInterest(double finalCapital, double rateAmount) {
    double resultado = finalCapital * rateAmount;

    // Limitar a 3 decimales
    resultado = double.parse(resultado.toStringAsFixed(5));
    return resultado;
  }

  double calculateLifeEnsurance(double finalCapital, double desgravamenRate) {
    double resultado = finalCapital * desgravamenRate;

    // Limitar a 3 decimales
    resultado = double.parse(resultado.toStringAsFixed(5));
    return resultado;
  }

  double calculateAmortization(
      double quota, double interest, double lifeEnsurance, String periodGrace) {
    if (periodGrace == 'S') {
      double resultado = quota - interest - lifeEnsurance;

      // Limitar a 3 decimales
      resultado = double.parse(resultado.toStringAsFixed(5));
      return resultado;
    } else {
      return 0;
    }
  }

  double calculateFinalCapital(double initialCapital, double amortization,
      String periodGrace, double interest) {
    if (periodGrace == 'T') {
      return initialCapital + interest;
    } else {
      double resultado = initialCapital - amortization;

      // Limitar a 3 decimales
      resultado = double.parse(resultado.toStringAsFixed(5));
      return resultado;
    }
  }

  double calculateFlow(double quota, double carSecure, double physicalShipments,
      double administativeCost, String periodGrace, double segDesgravamen) {
    double resultado =
        quota + carSecure + physicalShipments + administativeCost;

    if (periodGrace != 'S') {
      resultado += segDesgravamen;
    }

    // Limitar a 3 decimales
    resultado = double.parse(resultado.toStringAsFixed(5));
    return resultado;
  }

  double getCurrentFinalQuotaValue(double amount, double rateMonthlyPercentage,
      double desgravamenRatePercentage, double n) {
    double resultado = (amount /
        pow(1 + rateMonthlyPercentage + desgravamenRatePercentage, n + 1));

    resultado = double.parse(resultado.toStringAsFixed(5));

    print("resultado: $resultado");

    return resultado;
  }

  void generateRows() {
    PlanPagoRow initialRow = rows.first;
    rows.clear();
    rows.add(initialRow);

    for (int i = 1; i <= planPago.vehicleLoan.paymentPeriod + 1; i++) {
      double newInitialCapital =
          rows.last.month == 0 ? balanceToFinance : rows.last.finalAmount;

      double newLifeEnsurance =
          calculateLifeEnsurance(newInitialCapital, desgravamenRatePercentage);

      double newInterest =
          calculateInterest(newInitialCapital, rateMonthlyPercentage);

      double newQuota = double.parse(calculateQuota(
              newInitialCapital,
              rateMonthlyPercentage,
              desgravamenRatePercentage,
              paymentPeriod,
              rows.last.month,
              getGracePeriodType(rows.last.month + 1))
          .toStringAsFixed(1));

      double newAmortization = calculateAmortization(newQuota, newInterest,
          newLifeEnsurance, getGracePeriodType(rows.last.month + 1));

      double fcInitialamount = rows.last.month == 0
          ? getCurrentFinalQuotaValue(finalQuota, rateMonthlyPercentage,
              desgravamenRatePercentage, paymentPeriod)
          : double.parse(rows.last.fc_finalAmount.toStringAsFixed(5));

      double fcInterest = double.parse(
          (fcInitialamount * rateMonthlyPercentage).toStringAsFixed(5));
      double fcLifeEnsurance = double.parse(
          (fcInitialamount * desgravamenRatePercentage).toStringAsFixed(5));

      if (i <= paymentPeriod) {
        rows.add(PlanPagoRow(
          month: i,
          gracePeriod: getGracePeriodType(rows.last.month + 1),
          date: addOneMonthToCurrentDate(rows.last.date),
          fc_initialAmount: fcInitialamount,
          fc_interest: fcInterest,
          fc_amortization: 0,
          fc_lifeEnsurance: fcLifeEnsurance,
          fc_finalAmount: double.parse(
              (fcInitialamount + fcInterest + fcLifeEnsurance).toStringAsFixed(
                  2)), // we dont extract amortization due to it is not calculated yet, in 37 row still
          initialAmount: newInitialCapital,
          interestAmount: newInterest,
          quota: newQuota,
          amortization: newAmortization,
          lifeEnsurance: newLifeEnsurance,
          vehicleInsurance: vehicleInsuranceAmount,
          physicalShipments: physicalShipment,
          administrativeCost: administativeCost, //add this value in backend
          finalAmount: i == paymentPeriod
              ? double.parse(calculateFinalCapital(
                          newInitialCapital,
                          newAmortization,
                          getGracePeriodType(rows.last.month + 1),
                          newInterest)
                      .toStringAsFixed(0))
                  .abs()
              : calculateFinalCapital(newInitialCapital, newAmortization,
                  getGracePeriodType(rows.last.month + 1), newInterest),
          flow: double.parse(calculateFlow(
            newQuota,
            vehicleInsuranceAmount,
            physicalShipment,
            administativeCost,
            getGracePeriodType(rows.last.month + 1),
            newLifeEnsurance,
          ).toStringAsFixed(2)),
        ));
      } else {
        // quota 25 or 37
        double fcAmortization = double.parse(
            (fcInitialamount + fcInterest + fcLifeEnsurance)
                .toStringAsFixed(5));

        rows.add(PlanPagoRow(
          month: i,
          gracePeriod: getGracePeriodType(rows.last.month),
          date: addOneMonthToCurrentDate(rows.last.date),
          fc_initialAmount: fcInitialamount,
          fc_interest: fcInterest,
          fc_amortization: fcAmortization.toInt(),
          fc_lifeEnsurance: fcLifeEnsurance,
          fc_finalAmount: double.parse(
              (fcInitialamount + fcInterest + fcLifeEnsurance - fcAmortization)
                  .toStringAsFixed(5)),
          initialAmount: newInitialCapital,
          interestAmount: newInterest,
          quota: 0,
          amortization: 0,
          lifeEnsurance: newLifeEnsurance,
          vehicleInsurance: vehicleInsuranceAmount,
          physicalShipments: physicalShipment,
          administrativeCost: administativeCost, //add this value in backend
          finalAmount: calculateFinalCapital(
              newInitialCapital,
              0,
              getGracePeriodType(rows.last.month + 1),
              newInterest), //actualizar para plazo TGracias otal
          flow: double.parse((calculateFlow(
                      0,
                      vehicleInsuranceAmount,
                      physicalShipment,
                      administativeCost,
                      getGracePeriodType(rows.last.month + 1),
                      newLifeEnsurance) +
                  fcAmortization)
              .toStringAsFixed(1)),
        ));
      }
    }
  }

  ///ENDS HERE

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Text("Datos del Cliente",
                      style: GoogleFonts.readexPro(
                          color: tertiaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w500)),
                  Text(
                      "${widget.vehicleLoan.client.name} ${widget.vehicleLoan.client.lastname}",
                      style: GoogleFonts.readexPro(
                          color: homeInputFileTextColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Precio del Vehículo",
                              style: GoogleFonts.readexPro(
                                  color: tertiaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500)),
                          Text(widget.vehicleLoan.vehiclePrice.toString(),
                              style: GoogleFonts.readexPro(
                                  color: homeInputFileTextColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(width: 100),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Cuota Inicial",
                              style: GoogleFonts.readexPro(
                                  color: tertiaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500)),
                          Text(
                              (widget.vehicleLoan.vehiclePrice * 0.2)
                                  .toString(),
                              style: GoogleFonts.readexPro(
                                  color: homeInputFileTextColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text("${widget.vehicleLoan.rateType}: ",
                              style: GoogleFonts.readexPro(
                                  color: tertiaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500)),
                          Text("${widget.vehicleLoan.rateAmount * 100}%",
                              style: GoogleFonts.readexPro(
                                  color: homeInputFileTextColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(width: 175),
                      Row(
                        children: [
                          Text("TCEA: ",
                              style: GoogleFonts.readexPro(
                                  color: tertiaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500)),
                          Text("35.32%",
                              style: GoogleFonts.readexPro(
                                  color: homeInputFileTextColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("VAN: ",
                              style: GoogleFonts.readexPro(
                                  color: tertiaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500)),
                          Text("12345",
                              style: GoogleFonts.readexPro(
                                  color: homeInputFileTextColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(width: 156),
                      Row(
                        children: [
                          Text("TIR: ",
                              style: GoogleFonts.readexPro(
                                  color: tertiaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500)),
                          Text("35.32%",
                              style: GoogleFonts.readexPro(
                                  color: homeInputFileTextColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Fecha de inicio",
                              style: GoogleFonts.readexPro(
                                  color: tertiaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500)),
                          Text(widget.vehicleLoan.startedDate,
                              style: GoogleFonts.readexPro(
                                  color: homeInputFileTextColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(width: 130),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Periodo de Pago: ",
                              style: GoogleFonts.readexPro(
                                  color: tertiaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500)),
                          Text(widget.vehicleLoan.paymentPeriod.toString(),
                              style: GoogleFonts.readexPro(
                                  color: homeInputFileTextColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  Text("Última Cuota: ${widget.vehicleLoan.lastQuota}",
                      style: GoogleFonts.readexPro(
                          color: tertiaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 15),
                  Text(getLastQuotaMessage(widget.vehicleLoan.lastQuota),
                      style: GoogleFonts.readexPro(
                          color: homeInputFileTextColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 60),
                  Center(
                    child: CustomButton(
                        width: MediaQuery.of(context).size.width * 0.5,
                        text: "Ver calendario",
                        buttonColor: Colors.indigo,
                        textColor: textColor,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CustomTable(
                                    rows: rows,
                                  )));
                        }),
                  ),
                  const SizedBox(height: 15),
                  widget.fromHistory
                      ? Container()
                      : Center(
                          child: CustomButton(
                              width: MediaQuery.of(context).size.width * 0.5,
                              text: "Guardar Plan de Pagos",
                              buttonColor: Colors.indigo,
                              textColor: textColor,
                              onPressed: () {
                                savePaymentPlan();
                              }),
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
