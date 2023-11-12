class PlanPagoRow {
  int month;
  String gracePeriod;
  String date;
  double fc_initialAmount;
  double fc_interest;
  int fc_amortization;
  double fc_lifeEnsurance;
  double fc_finalAmount;
  double initialAmount;
  double interestAmount;
  double quota;
  double amortization;
  double lifeEnsurance;
  double vehicleInsurance;
  double physicalShipments;
  double administrativeCost;
  double finalAmount;
  double flow;

  PlanPagoRow({
    required this.month,
    required this.gracePeriod,
    required this.date,
    required this.fc_initialAmount,
    required this.fc_interest,
    required this.fc_amortization,
    required this.fc_lifeEnsurance,
    required this.fc_finalAmount,
    required this.initialAmount,
    required this.interestAmount,
    required this.quota,
    required this.amortization,
    required this.lifeEnsurance,
    required this.vehicleInsurance,
    required this.physicalShipments,
    required this.administrativeCost,
    required this.finalAmount,
    required this.flow,
  });
}
