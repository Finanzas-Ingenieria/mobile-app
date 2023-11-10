import 'package:credito_inteligente/models/client.dart';
import 'package:credito_inteligente/models/user.dart';

class VehicleLoan {
  int id;
  Client client;
  User user;
  String currency;
  String startedDate;
  double vehiclePrice;
  String rate;
  double rateAmount;
  double desgravamenRate;
  double vehicleInsurance;
  double physicalShipment;
  int paymentPeriod;
  String graceType;
  int gracePeriod;
  String lastQuota;

  VehicleLoan({
    required this.id,
    required this.client,
    required this.user,
    required this.currency,
    required this.startedDate,
    required this.vehiclePrice,
    required this.rate,
    required this.rateAmount,
    required this.desgravamenRate,
    required this.vehicleInsurance,
    required this.physicalShipment,
    required this.paymentPeriod,
    required this.graceType,
    required this.gracePeriod,
    required this.lastQuota,
  });
}
