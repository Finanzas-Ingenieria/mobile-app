import 'package:credito_inteligente/models/client.dart';
import 'package:credito_inteligente/models/user.dart';

class VehicleLoan {
  int id;
  Client client;
  User user;
  String currency;
  String startedDate;
  double vehiclePrice;
  double loanPercentage;
  String rateType;
  double rateAmount;
  double desgravamenRate;
  double vehicleInsurance;
  double physicalShipment;
  int paymentPeriod;
  String graceType;
  int gracePeriod;
  String lastQuota;
  double notaryCosts;
  double registrationCosts;
  double appraisal;
  double administrationCosts;

  VehicleLoan({
    required this.id,
    required this.client,
    required this.user,
    required this.currency,
    required this.startedDate,
    required this.vehiclePrice,
    required this.loanPercentage,
    required this.rateType,
    required this.rateAmount,
    required this.desgravamenRate,
    required this.vehicleInsurance,
    required this.physicalShipment,
    required this.paymentPeriod,
    required this.graceType,
    required this.gracePeriod,
    required this.lastQuota,
    required this.notaryCosts,
    required this.registrationCosts,
    required this.appraisal,
    required this.administrationCosts,
  });

  factory VehicleLoan.fromJson(Map<String, dynamic> json) {
    return VehicleLoan(
      id: json['id'],
      client: Client.fromJson(json['client']),
      user: User.fromJson(json['user']),
      currency: json['currency'],
      startedDate: json['startedDate'],
      vehiclePrice: json['vehiclePrice'],
      loanPercentage: json['loanPercentage'],
      rateType: json['rateType'],
      rateAmount: json['rateAmount'],
      desgravamenRate: json['desgravamenRate'],
      vehicleInsurance: json['vehicleInsurance'],
      physicalShipment: json['physicalShipment'],
      paymentPeriod: json['paymentPeriod'],
      graceType: json['graceType'],
      gracePeriod: json['gracePeriod'],
      lastQuota: json['lastQuota'],
      notaryCosts: json['notaryCosts'],
      registrationCosts: json['registrationCosts'],
      appraisal: json['appraisal'],
      administrationCosts: json['administrationCosts'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'client': client.toJson(),
        'user': user.toJson(),
        'currency': currency,
        'startedDate': startedDate,
        'vehiclePrice': vehiclePrice,
        'loanPercentage': loanPercentage,
        'rateType': rateType,
        'rateAmount': rateAmount,
        'desgravamenRate': desgravamenRate,
        'vehicleInsurance': vehicleInsurance,
        'physicalShipment': physicalShipment,
        'paymentPeriod': paymentPeriod,
        'graceType': graceType,
        'gracePeriod': gracePeriod,
        'lastQuota': lastQuota,
        'notaryCosts': notaryCosts,
        'registrationCosts': registrationCosts,
        'appraisal': appraisal,
        'administrationCosts': administrationCosts,
      };

  @override
  String toString() {
    return 'VehicleLoan{id: $id, client: $client, user: $user, currency: $currency, startedDate: $startedDate, vehiclePrice: $vehiclePrice, loanPercentage: $loanPercentage, rateType: $rateType, rateAmount: $rateAmount, desgravamenRate: $desgravamenRate, vehicleInsurance: $vehicleInsurance, physicalShipment: $physicalShipment, paymentPeriod: $paymentPeriod, graceType: $graceType, gracePeriod: $gracePeriod, lastQuota: $lastQuota, notaryCosts: $notaryCosts, registrationCosts: $registrationCosts, appraisal: $appraisal, administrationCosts: $administrationCosts}';
  }
}
