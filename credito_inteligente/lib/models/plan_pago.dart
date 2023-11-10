import 'package:credito_inteligente/models/plan_pago_row.dart';
import 'package:credito_inteligente/models/vehicle_loan.dart';

class PlanPago {
  List<PlanPagoRow> planPagoRows;
  VehicleLoan vehicleLoan;
  PlanPago({required this.planPagoRows, required this.vehicleLoan});
}
