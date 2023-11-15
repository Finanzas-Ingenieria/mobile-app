import 'package:credito_inteligente/models/client.dart';
import 'package:credito_inteligente/models/user.dart';

class VehicleLoan {
  int id;
  String code;
  Client client;
  User user;
  String currency;
  String startedDate;
  double vehiclePrice;
  double loanPercentage;
  String rateType;
  double rateAmount;
  String rateCapitalization;
  double desgravamenRate;
  double vehicleInsurance;
  double annualCok;
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
    required this.code,
    required this.client,
    required this.user,
    required this.currency,
    required this.startedDate,
    required this.vehiclePrice,
    required this.loanPercentage,
    required this.rateType,
    required this.rateAmount,
    required this.rateCapitalization,
    required this.desgravamenRate,
    required this.vehicleInsurance,
    required this.annualCok,
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
      code: json['code'],
      client: Client.fromJson(json['client']),
      user: User.fromJson(json['user']),
      currency: json['currency'],
      startedDate: json['startedDate'],
      vehiclePrice: json['vehiclePrice'],
      loanPercentage: json['loanPercentage'],
      rateType: json['rateType'],
      rateAmount: json['rateAmount'],
      rateCapitalization: json['rateCapitalization'],
      desgravamenRate: json['desgravamenRate'],
      vehicleInsurance: json['vehicleInsurance'],
      annualCok: json['annualCok'],
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
        'code': code,
        'client': client.toJson(),
        'user': user.toJson(),
        'currency': currency,
        'startedDate': startedDate,
        'vehiclePrice': vehiclePrice..toStringAsFixed(4),
        'loanPercentage': loanPercentage.toStringAsFixed(4),
        'rateType': rateType,
        'rateAmount': rateAmount..toStringAsFixed(4),
        'rateCapitalization': rateCapitalization,
        'desgravamenRate': desgravamenRate.toStringAsFixed(6),
        'vehicleInsurance': vehicleInsurance.toStringAsFixed(6),
        'annualCok': annualCok.toStringAsFixed(6),
        'physicalShipment': physicalShipment.toStringAsFixed(4),
        'paymentPeriod': paymentPeriod,
        'graceType': graceType,
        'gracePeriod': gracePeriod,
        'lastQuota': lastQuota,
        'notaryCosts': notaryCosts.toStringAsFixed(4),
        'registrationCosts': registrationCosts.toStringAsFixed(4),
        'appraisal': appraisal,
        'administrationCosts': administrationCosts.toStringAsFixed(4),
      };

  @override
  String toString() {
    return 'VehicleLoan{id: $id, code: $code, client: $client, user: $user, currency: $currency, startedDate: $startedDate, vehiclePrice: $vehiclePrice, loanPercentage: $loanPercentage, rateType: $rateType, rateAmount: $rateAmount,  rateCapitalization: $rateCapitalization ,desgravamenRate: $desgravamenRate, vehicleInsurance: $vehicleInsurance, annualCok: $annualCok, physicalShipment: $physicalShipment, paymentPeriod: $paymentPeriod, graceType: $graceType, gracePeriod: $gracePeriod, lastQuota: $lastQuota, notaryCosts: $notaryCosts, registrationCosts: $registrationCosts, appraisal: $appraisal, administrationCosts: $administrationCosts}';
  }

  //.empty constructor
  VehicleLoan.empty()
      : id = 0,
        code = '',
        client = Client.empty(),
        user = User.empty(),
        currency = '',
        startedDate = '',
        vehiclePrice = 0,
        loanPercentage = 0,
        rateType = '',
        rateAmount = 0,
        rateCapitalization = '',
        desgravamenRate = 0,
        vehicleInsurance = 0,
        annualCok = 0,
        physicalShipment = 0,
        paymentPeriod = 0,
        graceType = '',
        gracePeriod = 0,
        lastQuota = '',
        notaryCosts = 0,
        registrationCosts = 0,
        appraisal = 0,
        administrationCosts = 0;
}
