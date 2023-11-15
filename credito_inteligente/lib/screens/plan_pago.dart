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
  late double finalQuotaAndAppraisalCost;
  late double depreciationRate;
  late double VAN;
  late double TIR;
  late double TCEA;
  late double annualCOK;
  late double mountlyCOK;
  double finalQuoton = 0;
  int fixedDecimals = 16;

  double getFlow() {
    return widget.vehicleLoan.vehiclePrice -
        0.2 * widget.vehicleLoan.vehiclePrice +
        widget.vehicleLoan.notaryCosts +
        widget.vehicleLoan.registrationCosts;
  }

  double convertYearlyRate(double rate) {
    double innerRate = 0;

    if (widget.vehicleLoan.rateType == "TEA") {
      innerRate = rate;
    } else {
      if (widget.vehicleLoan.rateCapitalization == "Mensual") {
        innerRate = pow(1 + rate / (360 / 30), 360 / 30) - 1;
      } else {
        innerRate = pow(1 + rate / (360 / 1), 360 / 1) - 1;
      }
    }

    return double.parse(innerRate.toStringAsFixed(fixedDecimals));
  }

  double convertToMonthlyRate(double rate) {
    return pow(1 + rate, 1 / 12) - 1;
  }

  String getLastQuotaMessage(type) {
    finalQuotaAndAppraisalCost =
        double.parse(finalQuotaAndAppraisalCost.toStringAsFixed(fixedDecimals));
    if (type == "RENOVAR") {
      //limitate to 2 decimals
      return "Tienes un saldo a Favor de $finalQuotaAndAppraisalCost";
    } else if (type == "QUEDAR") {
      return "Valor del Cuotón Final $finalQuoton";
    } else {
      return "Tienes un saldo a Favor de $finalQuotaAndAppraisalCost";
    }
  }

  String addOneDayToCurrentDate() {
    DateTime currentDate = DateTime.now();

    DateTime newDate =
        DateTime(currentDate.year, currentDate.month, currentDate.day + 1);

    String formattedDate = DateFormat('dd/MM/yyyy').format(newDate);

    return formattedDate;
  }

  @override
  void initState() {
    super.initState();

    vehicleLoan = widget.vehicleLoan;
    rows = [
      PlanPagoRow(
          month: 0,
          gracePeriod: '',
          date: addOneDayToCurrentDate(),
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

    planPago = PlanPago(planPagoRows: rows, vehicleLoan: vehicleLoan);

    //DATA FROM OTHER SCREEN
    vehiclePrice = planPago.vehicleLoan.vehiclePrice;
    paymentPeriod = planPago.vehicleLoan.paymentPeriod.toDouble();
    initialCarPaymentPercentage = 0.2; // 20% of vehiclePrice
    loanPercentage = planPago.vehicleLoan.loanPercentage; // 80% of vehiclePrice
    finalCarPaymentPercentage =
        1 - initialCarPaymentPercentage - loanPercentage;
    rateType = planPago.vehicleLoan.rateType;
    rateAnualPercentage = convertYearlyRate(planPago.vehicleLoan.rateAmount);
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

    annualCOK = planPago.vehicleLoan.annualCok;
    mountlyCOK = convertToMonthlyRate(annualCOK);

    planPago = planPago;
    rows = planPago.planPagoRows;
    depreciationRate = planPago.vehicleLoan.paymentPeriod == 24 ? 0.3 : 0.45;
    finalQuotaAndAppraisalCost = 0;
    VAN = 0;
    TIR = 0;
    TCEA = 0;
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

    resultado = double.parse(resultado.toStringAsFixed(fixedDecimals));

    return resultado;
  }

  double calculateVAN(List<PlanPagoRow> myRows, double cok) {
    double VNA = 0;
    double VNAi = 0;
    double COK = cok;
    for (int i = 1; i < myRows.length; i++) {
      VNAi = myRows[i].flow / pow(1 + COK, i);
      VNA += VNAi;
    }

    double VAN = -(VNA - myRows[0].flow);
    print("VAN: $VAN");

    return VAN;
  }

  void calculateTIR(List<PlanPagoRow> myRows) {
    double numberOfChange = 0.001;
    double currentIteracionPercentage = 0;
    double currentVNAValue = calculateVAN(myRows, currentIteracionPercentage);
    double iHigherPercentage = 0;
    double iLowerPercentage = 0;
    double higherPercentageVNAValue = 0;
    double lowerPercentageVNAValue = 0;

    if (currentVNAValue > 0) {
      while (currentVNAValue > 0) {
        currentIteracionPercentage -= numberOfChange;
        currentVNAValue = calculateVAN(myRows, currentIteracionPercentage);
      }

      iHigherPercentage = currentIteracionPercentage + numberOfChange;
      higherPercentageVNAValue = calculateVAN(myRows, iHigherPercentage);

      iLowerPercentage = currentIteracionPercentage;
      lowerPercentageVNAValue = currentVNAValue;
    } else {
      while (currentVNAValue < 0) {
        currentIteracionPercentage += numberOfChange;
        currentVNAValue = calculateVAN(myRows, currentIteracionPercentage);
      }

      iHigherPercentage = currentIteracionPercentage;
      higherPercentageVNAValue = currentVNAValue;

      //find lower percentage
      while (currentVNAValue > 0) {
        currentIteracionPercentage -= numberOfChange;
        currentVNAValue = calculateVAN(myRows, currentIteracionPercentage);
      }

      iLowerPercentage = currentIteracionPercentage;
      lowerPercentageVNAValue = currentVNAValue;
    }

    double tir =
        -(((iHigherPercentage - iLowerPercentage) * higherPercentageVNAValue) /
                (higherPercentageVNAValue - lowerPercentageVNAValue)) +
            iHigherPercentage;

    tir = double.parse(tir.toStringAsFixed(fixedDecimals));

    double tcea = pow(1 + tir, 12) - 1;
    tcea = double.parse(tcea.toStringAsFixed(fixedDecimals));

    setState(() {
      TIR = tir;
      TCEA = tcea;
    });
  }

  double getVehicleInsuranceAmount(
      double vehiclePrice, double vehicleInsurancePercentage) {
    double resultado = vehicleInsurancePercentage * vehiclePrice / 12;

    resultado = double.parse(resultado.toStringAsFixed(fixedDecimals));

    return resultado;
  }

  void savePaymentPlan() {
    VehicleLoanService().createVehicleLoan(widget.vehicleLoan).then((value) => {
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
                  duration: const Duration(seconds: 3),
                ),
              ),

              //waiut for 3 seconds
              Future.delayed(const Duration(seconds: 5), () {
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
      resultado = double.parse(resultado.toStringAsFixed(fixedDecimals));
      return resultado;
    }
  }

  double calculateInterest(double finalCapital, double rateAmount) {
    double resultado = finalCapital * rateAmount;

    // Limitar a 3 decimales
    resultado = double.parse(resultado.toStringAsFixed(fixedDecimals));
    return resultado;
  }

  double calculateLifeEnsurance(double finalCapital, double desgravamenRate) {
    double resultado = finalCapital * desgravamenRate;

    // Limitar a 3 decimales
    resultado = double.parse(resultado.toStringAsFixed(fixedDecimals));
    return resultado;
  }

  double calculateAmortization(
      double quota, double interest, double lifeEnsurance, String periodGrace) {
    if (periodGrace == 'S') {
      double resultado = quota - interest - lifeEnsurance;

      // Limitar a 3 decimales
      resultado = double.parse(resultado.toStringAsFixed(fixedDecimals));
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

      //resultado += 0.1; //TO ROUND UP

      // Limitar a 3 decimales
      resultado = double.parse(resultado.toStringAsFixed(0));
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
    resultado = double.parse(resultado.toStringAsFixed(fixedDecimals));
    return resultado;
  }

  double getCurrentFinalQuotaValue(double amount, double rateMonthlyPercentage,
      double desgravamenRatePercentage, double n) {
    double resultado = (amount /
        pow(1 + rateMonthlyPercentage + desgravamenRatePercentage, n + 1));

    resultado = double.parse(resultado.toStringAsFixed(fixedDecimals));

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
          .toStringAsFixed(fixedDecimals));

      double newAmortization = calculateAmortization(newQuota, newInterest,
          newLifeEnsurance, getGracePeriodType(rows.last.month + 1));

      double fcInitialamount = rows.last.month == 0
          ? getCurrentFinalQuotaValue(finalQuota, rateMonthlyPercentage,
              desgravamenRatePercentage, paymentPeriod)
          : double.parse(
              rows.last.fc_finalAmount.toStringAsFixed(fixedDecimals));

      double fcInterest = double.parse((fcInitialamount * rateMonthlyPercentage)
          .toStringAsFixed(fixedDecimals));
      double fcLifeEnsurance = double.parse(
          (fcInitialamount * desgravamenRatePercentage)
              .toStringAsFixed(fixedDecimals));

      if (i <= paymentPeriod) {
        rows.add(PlanPagoRow(
          month: i,
          gracePeriod: getGracePeriodType(rows.last.month + 1),
          date: addOneMonthToCurrentDate(rows.last.date),
          fc_initialAmount: fcInitialamount,
          fc_interest: fcInterest,
          fc_amortization: 0,
          fc_lifeEnsurance: fcLifeEnsurance,
          fc_finalAmount: double.parse(((fcInitialamount +
                      fcInterest +
                      fcLifeEnsurance)
                  .abs())
              .toStringAsFixed(
                  fixedDecimals)), // we dont extract amortization due to it is not calculated yet, in 37 row still
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
              : double.parse(calculateFinalCapital(
                      newInitialCapital,
                      newAmortization,
                      getGracePeriodType(rows.last.month + 1),
                      newInterest)
                  .toStringAsFixed(fixedDecimals)),
          flow: double.parse(calculateFlow(
            newQuota,
            vehicleInsuranceAmount,
            physicalShipment,
            administativeCost,
            getGracePeriodType(rows.last.month + 1),
            newLifeEnsurance,
          ).toStringAsFixed(fixedDecimals)),
        ));
      } else {
        // quota 25 or 37
        double fcAmortization = double.parse(
            (fcInitialamount + fcInterest + fcLifeEnsurance)
                .toStringAsFixed(fixedDecimals));

        double lastQuota = double.parse((calculateFlow(
                    0,
                    vehicleInsuranceAmount,
                    physicalShipment,
                    administativeCost,
                    getGracePeriodType(rows.last.month + 1),
                    newLifeEnsurance) +
                fcAmortization)
            .toStringAsFixed(fixedDecimals));

        setState(() {
          finalQuotaAndAppraisalCost =
              vehiclePrice * (1 - depreciationRate) - lastQuota;
          finalQuoton = lastQuota;
        });

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
                  .toStringAsFixed(fixedDecimals)),
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
          flow: lastQuota,
        ));

        double van = calculateVAN(rows, mountlyCOK);
        van = double.parse(van.toStringAsFixed(fixedDecimals));

        setState(() {
          VAN = van;
        });
        calculateTIR(rows);
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
          title: Text(
            'Plan de Pagos',
            style: GoogleFonts.readexPro(
              fontSize: 22,
              fontWeight: FontWeight.w400,
            ),
          ),
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
                  const SizedBox(height: 20),
                  Text(
                    "Datos del Cliente",
                    style: GoogleFonts.readexPro(
                      color: tertiaryColor,
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "${widget.vehicleLoan.client.name} ${widget.vehicleLoan.client.lastname}",
                    style: GoogleFonts.readexPro(
                      color: homeInputFileTextColor,
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.15),
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.2),
                    child: Table(
                      columnWidths: const {
                        0: FlexColumnWidth(2.0),
                        1: FlexColumnWidth(2.0),
                      },
                      children: [
                        buildTableRow("Precio del Vehículo:",
                            widget.vehicleLoan.vehiclePrice.toString()),
                        buildTableRow("Cuota Inicial:",
                            (widget.vehicleLoan.vehiclePrice * 0.2).toString()),
                        buildTableRow("TEA:", "${rateAnualPercentage * 100}%"),
                        buildTableRow("VAN:", VAN.toString()),
                        buildTableRow("TIR:", "${TIR * 100}%"),
                        buildTableRow("TCEA:", "${TCEA * 100}%"),
                        buildTableRow("Fecha de inicio: ",
                            widget.vehicleLoan.startedDate),
                        buildTableRow("Periodo de Pago: ",
                            "${widget.vehicleLoan.paymentPeriod} meses"),
                        buildTableRow("Porcentaje de Depreciación: ",
                            "${depreciationRate * 100} %"),
                        buildTableRow("Código: ", widget.vehicleLoan.code)
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  widget.fromHistory
                      ? Column(children: [
                          Text(
                            "Última Cuota: ${widget.vehicleLoan.lastQuota}",
                            style: GoogleFonts.readexPro(
                              color: tertiaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            getLastQuotaMessage(widget.vehicleLoan.lastQuota),
                            style: GoogleFonts.readexPro(
                              color: homeInputFileTextColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ])
                      : Container(),
                  const SizedBox(height: 35),
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
                          ),
                        ));
                      },
                    ),
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
                            },
                          ),
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  TableRow buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            label,
            style: GoogleFonts.readexPro(
              color: const Color.fromARGB(255, 62, 62, 62),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            value,
            style: GoogleFonts.readexPro(
              color: homeInputFileTextColor,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
