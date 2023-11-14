import 'package:credito_inteligente/screens/plan_pago.dart';
import 'package:credito_inteligente/services/vehicle_loan_service.dart';
import 'package:credito_inteligente/styles/styles.dart';
import 'package:credito_inteligente/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/input_field.dart';
import '../widgets/snack_bar.dart';

class BuscarPlanPago extends StatefulWidget {
  const BuscarPlanPago({super.key});

  @override
  State<BuscarPlanPago> createState() => _BuscarPlanPagoState();
}

class _BuscarPlanPagoState extends State<BuscarPlanPago> {
  final _codeController = TextEditingController();

  void _updateInputCode(String text) {
    setState(() {
      _codeController.text = text;
    });
  }

  void searchPaymentPlan() {
    String code = _codeController.text;

    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: CustomSnackBarContent(
            mainTile: "Campo Vacío",
            errorText: "Por favor ingresa el código de tu plan de pagos",
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          duration: Duration(seconds: 4),
        ),
      );
      return;
    }

    VehicleLoanService().getVehicleLoansByCode(code).then((vehicleLoans) {
      if (vehicleLoans.id == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: CustomSnackBarContent(
              mainTile: "No Encontrado",
              errorText:
                  "No se encontró un plan de pagos con el código ingresado",
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
            duration: Duration(seconds: 4),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PlanDePago(vehicleLoan: vehicleLoans, fromHistory: true),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'Buscar Plan del Pagos',
          style: GoogleFonts.readexPro(
            fontSize: 22,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal:
                MediaQuery.of(context).size.width > webScreenWidth ? 400 : 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¿Ya tienes un plan de pagos?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Ingresa el código de tu plan de pagos para ver los detalles',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            InputFieldWidget(
                hintText: "Código", onTextChanged: _updateInputCode),
            const SizedBox(height: 20),
            CustomButton(
                text: "Buscar",
                buttonColor: primaryColor,
                textColor: textColor,
                onPressed: () {
                  searchPaymentPlan();
                })
          ],
        ),
      ),
    );
  }
}
