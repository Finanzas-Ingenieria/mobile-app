import 'dart:convert';

import 'package:credito_inteligente/models/client.dart';
import 'package:credito_inteligente/models/user.dart';

import '../models/vehicle_loan.dart';
import 'package:http/http.dart' as http;

class VehicleLoanService {
  final String baseUrl = 'http://localhost:8090/api/vehicleLoans';

  String convertDate(String date) {
    List<String> dateList = date.split('/');
    String newDate = '${dateList[2]}-${dateList[1]}-${dateList[0]}';
    return newDate;
  }

  Future<VehicleLoan> createVehicleLoan(VehicleLoan vehicleLoan) async {
    final url = Uri.parse('$baseUrl/createLoan/${vehicleLoan.user.id}');
    vehicleLoan.startedDate = convertDate(vehicleLoan.startedDate);

    print("URL: $url");
    print("VehicleLoan: $vehicleLoan");

    try {
      final response = await http.post(
        url,
        headers: {'content-type': 'application/json'},
        body: jsonEncode(vehicleLoan.toJson()),
      );

      if (response.statusCode == 201) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        return VehicleLoan.fromJson(jsonData);
      } else {
        throw Exception(
            'Failed to create vehicleLoan. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create vehicleLoan. Error: $e');
    }
  }

  //endpoint http://localhost:8090/api/vehicleLoans/user/{userId}
  //get vehicleLoans by userId

  Future<List<VehicleLoan>> getVehicleLoansByUserId(int userId) async {
    final url = Uri.parse('$baseUrl/user/$userId');

    try {
      final response = await http.get(
        url,
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List<dynamic>;
        return jsonData
            .map((vehicleLoan) => VehicleLoan.fromJson(vehicleLoan))
            .toList();
      } else if (response.statusCode == 204) {
        return [];
      } else {
        throw Exception(
            'Failed to fetch vehicleLoans data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch vehicleLoans data. Error: $e');
    }
  }

  //get vehicleLoans by code
  //this is the endpoint http://localhost:8090/api/vehicleLoans/code/{code}
  Future<VehicleLoan> getVehicleLoansByCode(String code) async {
    final url = Uri.parse('$baseUrl/code/$code');

    try {
      final response = await http.get(
        url,
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        return VehicleLoan.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        return VehicleLoan(
          id: 0,
          code: '',
          client: Client(id: 0, name: "", lastname: ""),
          user: User(id: 0, name: "", lastname: "", email: "", password: ""),
          currency: '',
          startedDate: '',
          vehiclePrice: 0,
          loanPercentage: 0,
          rateType: '',
          rateAmount: 0,
          rateCapitalization: '',
          desgravamenRate: 0,
          vehicleInsurance: 0,
          physicalShipment: 0,
          paymentPeriod: 0,
          graceType: '',
          gracePeriod: 0,
          lastQuota: '',
          notaryCosts: 0,
          registrationCosts: 0,
          appraisal: 0,
          administrationCosts: 0,
        );
      } else {
        throw Exception(
            'Failed to fetch vehicleLoans data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch vehicleLoans data. Error: $e');
    }
  }
}
