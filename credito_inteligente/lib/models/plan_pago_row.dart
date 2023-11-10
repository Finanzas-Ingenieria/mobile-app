class PlanPagoRow {
  int month;
  String date;
  double ratePercentage;
  String gracePeriod;
  double initialCapital;
  double interest;
  double quota;
  double amortization;
  double lifeEnsurance;
  double secureInGood;
  double physicalShipments;
  double finalCapital;
  double flow;

  PlanPagoRow({
    required this.month,
    required this.date,
    required this.ratePercentage,
    required this.gracePeriod,
    required this.initialCapital,
    required this.interest,
    required this.quota,
    required this.amortization,
    required this.lifeEnsurance,
    required this.secureInGood,
    required this.physicalShipments,
    required this.finalCapital,
    required this.flow,
  });
}
