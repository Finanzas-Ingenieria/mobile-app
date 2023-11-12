import 'dart:math';

import 'package:credito_inteligente/models/plan_pago.dart';
import 'package:credito_inteligente/models/plan_pago_row.dart';
import 'package:credito_inteligente/styles/styles.dart';
import 'package:credito_inteligente/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomTable extends StatefulWidget {
  final PlanPago planPago;
  const CustomTable({super.key, required this.planPago});

  @override
  State<CustomTable> createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  late PlanPago planPago;
  late List<PlanPagoRow> rows;
  final ScrollController scrollController = ScrollController();

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
      return rate / 12;
    }
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

  @override
  void initState() {
    super.initState();

    vehiclePrice = widget.planPago.vehicleLoan.vehiclePrice;
    paymentPeriod = widget.planPago.vehicleLoan.paymentPeriod.toDouble();
    initialCarPaymentPercentage = 0.2; // 20% of vehiclePrice
    loanPercentage =
        widget.planPago.vehicleLoan.loanPercentage; // 80% of vehiclePrice
    finalCarPaymentPercentage =
        1 - initialCarPaymentPercentage - loanPercentage;
    rateType = widget.planPago.vehicleLoan.rateType;
    rateAnualPercentage = widget.planPago.vehicleLoan.rateAmount;
    rateMonthlyPercentage = convertToMonthlyRate(rateAnualPercentage);

    notaryCost = widget.planPago.vehicleLoan.notaryCosts;
    registryCost = widget.planPago.vehicleLoan.registrationCosts;
    appraisalCost = widget.planPago.vehicleLoan.appraisal;

    physicalShipment = widget.planPago.vehicleLoan.physicalShipment;
    administativeCost = widget.planPago.vehicleLoan.administrationCosts;
    desgravamenRatePercentage = widget.planPago.vehicleLoan.desgravamenRate;
    vehicleInsurancePercentage = widget.planPago.vehicleLoan.vehicleInsurance;

    initialQuota = vehiclePrice * initialCarPaymentPercentage;
    finalQuota = vehiclePrice * finalCarPaymentPercentage;
    loanAmount = vehiclePrice - initialQuota + notaryCost + registryCost;
    balanceToFinance = getLoanBalanceToFinance(loanAmount, finalQuota,
        rateMonthlyPercentage, desgravamenRatePercentage, paymentPeriod);

    vehicleInsuranceAmount =
        getVehicleInsuranceAmount(vehiclePrice, vehicleInsurancePercentage);

    gracePeriod = widget.planPago.vehicleLoan.gracePeriod;
    graceType = widget.planPago.vehicleLoan.graceType;

    planPago = widget.planPago;
    rows = planPago.planPagoRows;
    generateRows();
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
    //print
    print("amount: $amount");
    print("rateMonthlyPercentage: $rateMonthlyPercentage");
    print("desgravamenRatePercentage: $desgravamenRatePercentage");
    print("n: $n");

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: MediaQuery.of(context).size.width > webScreenWidth
              ? const EdgeInsets.symmetric(horizontal: 10)
              : const EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,

                controller: scrollController, // Add the scrollController
                child: buildDataTable(),
              ),
              const SizedBox(height: 20),
              CustomButton(
                  text: "Regresar",
                  buttonColor: primaryColor,
                  textColor: textColor,
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          ),
        ),
      ),
    );
  }

  //Saldo Inicial Cuota final	Interes Cuota final	Amort. Cuota final	Seguro desg. Cuota final	 Saldo Final Cuota Final 	Saldo Inicial Cuota	Interes	"Cuota  (inc Seg Des)"	Amort.	Seguro desg. Cuota	Seguro riesgo	GPS	Portes	Gastos Adm.	 Saldo Final para Cuota 	 Flujo

  Widget buildDataTable() {
    final columns = [
      'N°',
      'P.G',
      'Fecha',
      'Saldo Inicial CF',
      'Interes CF',
      'Amort. CF',
      'Seguro desg. CF',
      'Saldo Final CF',
      'Saldo Inicial',
      'Interes',
      'Cuota',
      'Amortizacion',
      'Seguro Desgrav.',
      'Seguro Vehicular',
      'Envío Físico',
      'Gastos Adm.', // Add a comma here
      'Saldo Final', // Separate 'Gastos Adm.' and 'Saldo Final' with a comma
      'Flujo'
    ];
    return Table(
      defaultColumnWidth: const IntrinsicColumnWidth(),
      children: [
        // Custom header row
        TableRow(
          children: columns.map(
            (column) {
              return Container(
                color: (column == 'Saldo Inicial CF' ||
                        column == 'Interes CF' ||
                        column == 'Amort. CF' ||
                        column == 'Seguro desg. CF' ||
                        column == 'Saldo Final CF')
                    ? const Color.fromARGB(173, 134, 172, 255)
                    : const Color.fromARGB(172, 255, 192, 134),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(column),
                ),
              );
            },
          ).toList(),
        ),
        // Data rows
        ...getRows(rows),
      ],
    );
  }

  List<TableRow> getRows(List<PlanPagoRow> rows) {
    return rows.map((PlanPagoRow row) {
      final cells = [
        row.month,
        row.gracePeriod,
        row.date,
        row.fc_initialAmount,
        row.fc_interest,
        row.fc_amortization,
        row.fc_lifeEnsurance,
        row.fc_finalAmount,
        row.initialAmount,
        row.interestAmount,
        row.quota,
        row.amortization,
        row.lifeEnsurance,
        row.vehicleInsurance,
        row.physicalShipments,
        row.administrativeCost,
        row.finalAmount,
        row.flow
      ];

      return TableRow(children: getCells(cells));
    }).toList();
  }

  List<TableCell> getCells(List<dynamic> row) {
    return row.asMap().entries.map((entry) {
      return TableCell(
        child: Container(
          color: (entry.key >= 3 && entry.key <= 7)
              ? const Color.fromARGB(172, 206, 221, 254)
              : const Color.fromARGB(133, 255, 245, 236),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${entry.value}'),
          ),
        ),
      );
    }).toList();
  }
}
