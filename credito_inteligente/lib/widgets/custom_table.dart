import 'package:credito_inteligente/models/plan_pago_row.dart';
import 'package:credito_inteligente/styles/styles.dart';
import 'package:credito_inteligente/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTable extends StatefulWidget {
  final List<PlanPagoRow> rows;

  const CustomTable({super.key, required this.rows});

  @override
  State<CustomTable> createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  List<PlanPagoRow> get rows => widget.rows;
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 251, 255),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(5),
          margin: MediaQuery.of(context).size.width > webScreenWidth
              ? const EdgeInsets.symmetric(horizontal: 10)
              : const EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
            children: [
              const SizedBox(height: 10),
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 80, 98, 197),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Cronograma de Pagos",
                      style: GoogleFonts.readexPro(
                        color: textColor,
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    CustomButton(
                        buttonHeight: 50,
                        width: 250,
                        text: "Regresar",
                        fontSize: 18,
                        buttonColor: const Color.fromARGB(255, 97, 114, 208),
                        textColor: textColor,
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.84,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,

                    controller: scrollController, // Add the scrollController
                    child: buildDataTable(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
