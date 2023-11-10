import 'package:credito_inteligente/models/plan_pago_row.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomTable extends StatefulWidget {
  const CustomTable({super.key});

  @override
  State<CustomTable> createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  late List<PlanPagoRow> rows;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    rows = getPlanPagoRows();
  }

  List<PlanPagoRow> getPlanPagoRows() {
    return [
      PlanPagoRow(
          month: 0,
          date: DateFormat('y/M/d').format(DateTime.now()),
          ratePercentage: 1.98,
          gracePeriod: 'T',
          initialCapital: 43000,
          interest: 393.45,
          quota: 273.32,
          amortization: 102.21,
          lifeEnsurance: 9.87,
          secureInGood: 20.83,
          physicalShipments: 10,
          finalCapital: 42897.79,
          flow: 907.67),
      PlanPagoRow(
          month: 1,
          date: DateFormat('y/M/d').format(DateTime.now()),
          ratePercentage: 1.98,
          gracePeriod: 'T',
          initialCapital: 43000,
          interest: 393.45,
          quota: 273.32,
          amortization: 102.21,
          lifeEnsurance: 9.87,
          secureInGood: 20.83,
          physicalShipments: 10,
          finalCapital: 42897.79,
          flow: 907.67),
      PlanPagoRow(
          month: 2,
          date: DateFormat('y/M/d').format(DateTime.now()),
          ratePercentage: 1.98,
          gracePeriod: 'T',
          initialCapital: 43000,
          interest: 393.45,
          quota: 273.32,
          amortization: 102.21,
          lifeEnsurance: 9.87,
          secureInGood: 20.83,
          physicalShipments: 10,
          finalCapital: 42897.79,
          flow: 907.67),
      PlanPagoRow(
          month: 3,
          date: DateFormat('y/M/d').format(DateTime.now()),
          ratePercentage: 1.98,
          gracePeriod: 'T',
          initialCapital: 43000,
          interest: 393.45,
          quota: 273.32,
          amortization: 102.21,
          lifeEnsurance: 9.87,
          secureInGood: 20.83,
          physicalShipments: 10,
          finalCapital: 42897.79,
          flow: 907.67),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: scrollController, // Add the scrollController
          child: buildDataTable(),
        ),
      ),
    );
  }

  Widget buildDataTable() {
    final columns = [
      'N°',
      'Fecha',
      'TEM',
      'P.G',
      'Saldo Inicial',
      'Interes',
      'Cuota',
      'Amortizacion',
      'Seguro Desgrav.',
      'Seguro Vehicular',
      'Envío Físico',
      'Saldo Final',
      'Flujo'
    ];

    return DataTable(columns: getColumns(columns), rows: getRows(rows));
  }

  List<DataColumn> getColumns(List<String> columns) =>
      columns.map((String column) => DataColumn(label: Text(column))).toList();

  List<DataRow> getRows(List<PlanPagoRow> rows) => rows.map((PlanPagoRow row) {
        final cells = [
          row.month,
          row.date,
          row.ratePercentage,
          row.gracePeriod,
          row.initialCapital,
          row.interest,
          row.quota,
          row.amortization,
          row.lifeEnsurance,
          row.secureInGood,
          row.physicalShipments,
          row.finalCapital,
          row.flow,
        ];

        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<dynamic> row) =>
      row.map((data) => DataCell(Text('$data'))).toList();
}
