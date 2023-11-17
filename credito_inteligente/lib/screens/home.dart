import 'package:credito_inteligente/models/client.dart';
import 'package:credito_inteligente/screens/plan_pago.dart';
import 'package:credito_inteligente/screens/select_car.dart';
import 'package:credito_inteligente/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/car.dart';
import '../models/user.dart';
import '../models/vehicle_loan.dart';
import '../services/vehicle_loan_service.dart';
import '../styles/styles.dart';
import '../widgets/button.dart';
import '../widgets/snack_bar.dart';

class Home extends StatefulWidget {
  final User user;
  const Home({super.key, required this.user});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> currencies = ['SOLES', 'DÓLARES'];
  final List<String> rateTypes = ['TEA', 'TNA'];
  double ratePercentage = 0;

  String selectedCurrency = 'SOLES';
  String selectedRate = 'TEA';

  int vehicleValue = 10000;
  double usdToPEN = 3.8;

  String vehicleValueErrorText = '';
  int currentVehicleValue = 10000;
  String changingVehicleValue = '';

  int minVehicleValueUSD = (10000 / 3.8).round();
  int maxVehicleValueUSD = (50000 / 3.8).round();
  int minVehicleValuePEN = 10000;
  int maxVehicleValuePEN = 50000;

  int minVehicleValue = 10000;
  int maxVehicleValue = 50000;
  double initialQuotaPercentage = 0.2;
  double initialQuota = 0;

  int selectedPeriod = 24;
  String selectedGracePeriod = 'Ninguno';
  String selectedLastQuota = 'Se renovará el vehículo';
  int selectedLoanPercentage = 30;
  String selectedTNACapitalization = 'Diaria';

  final TextEditingController vehicleValueController = TextEditingController();
  final TextEditingController initialQuotaController = TextEditingController();
  final TextEditingController rateController = TextEditingController();

  //data
  String clientName = '';
  String clientLastName = '';
  double mountlyIncome = 0;
  double rateAmount = 0;
  double desgravamentMontlyRate = 0;
  double vehicleInsuranceAnnualRate = 0;
  double physicalShipment = 0;
  double administrationExpenses = 0;
  double notaryExpenses = 0;
  double registryExpenses = 0;
  double gracePeriod = 0;
  double annualCOK = 0;

  bool buttonClicked = false;
  bool editMode = false;
  VehicleLoan existingVehicleLoan = VehicleLoan.empty();
  bool existingVehicleLoanFound = false;

  final TextEditingController _codeController = TextEditingController();

  bool vehicleValueIsValid(String value) {
    if (value.isEmpty) return false;

    double valueDouble = double.parse(value);
    int valueInt = valueDouble.round();

    if (selectedCurrency == 'DÓLARES') {
      if (valueInt < minVehicleValueUSD || valueInt > maxVehicleValueUSD) {
        setState(() {
          vehicleValueErrorText =
              'Valor entre \$$minVehicleValueUSD y \$$maxVehicleValueUSD';
        });
        return false;
      }
    } else {
      if (valueInt < minVehicleValuePEN || valueInt > maxVehicleValuePEN) {
        setState(() {
          vehicleValueErrorText =
              'Valor entre S/ $minVehicleValuePEN y S/ $maxVehicleValuePEN';
        });
        return false;
      }
    }

    return true;
  }

  void updateVehicleValue(String value) {
    if (!vehicleValueIsValid(value)) return;

    setState(() {
      vehicleValue = int.parse(value);
      currentVehicleValue = vehicleValue;
    });
  }

  void switchCurrency(String newCurrency) {
    if (newCurrency == selectedCurrency) return;

    setState(() {
      selectedCurrency = newCurrency;

      if (newCurrency == 'DÓLARES') {
        if (currentVehicleValue < minVehicleValueUSD) {
          currentVehicleValue = minVehicleValueUSD;
        } else if (currentVehicleValue > maxVehicleValueUSD) {
          currentVehicleValue = maxVehicleValueUSD;
        }

        minVehicleValue = minVehicleValueUSD;
        maxVehicleValue = maxVehicleValueUSD;
      } else {
        if (currentVehicleValue < minVehicleValuePEN) {
          currentVehicleValue = minVehicleValuePEN;
        } else if (currentVehicleValue > maxVehicleValuePEN) {
          currentVehicleValue = maxVehicleValuePEN;
        }

        minVehicleValue = minVehicleValuePEN;
        maxVehicleValue = maxVehicleValuePEN;
      }

      vehicleValueController.text = currentVehicleValue.toString();
    });
  }

  void switchRate(String newRate) {
    if (newRate == selectedRate) return;

    setState(() {
      selectedRate = newRate;
    });
  }

  String getInitialQuota() {
    initialQuota = currentVehicleValue * initialQuotaPercentage;

    if (selectedCurrency == 'DÓLARES') {
      return '\$ ${initialQuota.toStringAsFixed(2)}';
    } else {
      return 'S/ ${initialQuota.toStringAsFixed(2)}';
    }
  }

  String getCurrency() {
    if (selectedCurrency == 'DÓLARES') {
      return '\$';
    } else {
      return 'S/';
    }
  }

  @override
  void initState() {
    super.initState();
    print("HOME");
    print(widget.user);

    vehicleValueController.text =
        currentVehicleValue.toString(); // Initialize input field value

    changingVehicleValue = currentVehicleValue.toString();

    if (selectedCurrency == 'DÓLARES') {
      minVehicleValue = minVehicleValueUSD;
      maxVehicleValue = maxVehicleValueUSD;
    } else {
      minVehicleValue = minVehicleValuePEN;
      maxVehicleValue = maxVehicleValuePEN;
    }
  }

  void updateClientName(String text) {
    setState(() {
      clientName = text;
    });
  }

  void updateClientLastName(String text) {
    setState(() {
      clientLastName = text;
    });
  }

  void updateMonthlyIncome(String text) {
    setState(() {
      mountlyIncome = text.isNotEmpty ? double.parse(text) : 0;
    });
  }

  void updateAnnualRate(String text) {
    setState(() {
      rateAmount = double.parse(text);
    });
  }

  void updateDesgravamentRate(String text) {
    setState(() {
      desgravamentMontlyRate = text.isNotEmpty ? double.parse(text) : 0;
    });
  }

  void updateVehicleInsuranceRate(String text) {
    setState(() {
      vehicleInsuranceAnnualRate = text.isNotEmpty ? double.parse(text) : 0;
    });
  }

  void updatePhysicalShipment(String text) {
    setState(() {
      physicalShipment = text.isNotEmpty ? double.parse(text) : 0;
    });
  }

  void updateAdministrationExpenses(String text) {
    setState(() {
      administrationExpenses = text.isNotEmpty ? double.parse(text) : 0;
    });
  }

  void updateNotaryExpenses(String text) {
    setState(() {
      notaryExpenses = text.isNotEmpty ? double.parse(text) : 0;
    });
  }

  void updateRegistryExpenses(String text) {
    setState(() {
      registryExpenses = text.isNotEmpty ? double.parse(text) : 0;
    });
  }

  void updateGracePeriod(String text) {
    setState(() {
      gracePeriod = text.isNotEmpty ? double.parse(text) : 0;
    });
  }

  void updateAnnualCOK(String text) {
    setState(() {
      annualCOK = text.isNotEmpty ? double.parse(text) : 0;
    });
  }

  String getGraceType(String graceType) {
    if (graceType == 'Ninguno') {
      return 'S';
    } else if (graceType == 'Total') {
      return 'T';
    } else {
      return 'P';
    }
  }

  String getLastQuota(String lastQuota) {
    if (lastQuota == 'Se renovará el vehículo') {
      return 'RENOVAR';
    } else if (lastQuota == 'Se quedará con el auto') {
      return 'QUEDAR';
    } else {
      return 'DEVOLVER';
    }
  }

  DateTime addOneDay() {
    DateTime now = DateTime.now();
    DateTime newDate = DateTime(now.year, now.month, now.day + 1);
    return newDate;
  }

  String getVehiculeLoanCode(String clientName, String clientLastName) {
    String day = DateFormat('dd').format(addOneDay());
    clientName = clientName.toUpperCase();
    clientLastName = clientLastName.toUpperCase()[0];
    String code = 'PG-$day$clientName$clientLastName';
    return code;
  }

  void validateData() {
    //validate data
    bool gracePeriodIsValid = false;

    if (selectedGracePeriod != "Ninguno" &&
        (gracePeriod > 0 && gracePeriod <= 6)) {
      gracePeriodIsValid = true;
    } else if (selectedGracePeriod == "Ninguno") {
      gracePeriodIsValid = true;
    }

    //print notary expenses
    print("Notary Expenses: $notaryExpenses");

    if (clientName.isNotEmpty &&
            clientLastName.isNotEmpty &&
            vehicleValueIsValid(changingVehicleValue) &&
            (rateAmount >= 8 && rateAmount <= 24) &&
            desgravamentMontlyRate > 0 &&
            vehicleInsuranceAnnualRate > 0 &&
            administrationExpenses > 0 &&
            notaryExpenses > 0 &&
            selectedCurrency == "SOLES"
        ? mountlyIncome > 1500
        : mountlyIncome > 1500 / 3.8 &&
            registryExpenses > 0 &&
            gracePeriodIsValid) {
      print("Why is this not working?");
      print("Notary Expenses: $notaryExpenses");

      Client newClient = Client(
        id: 0,
        name: clientName,
        lastname: clientLastName,
      );

      //create new vehicle loan
      VehicleLoan newVehicleLoan = VehicleLoan(
          id: 0,
          code: getVehiculeLoanCode(clientName, clientLastName),
          client: newClient,
          currency: selectedCurrency == 'DÓLARES' ? 'USD' : 'PEN',
          loanPercentage: selectedLoanPercentage.toDouble() / 100,
          startedDate: DateFormat('dd/MM/yyyy').format(addOneDay()),
          vehiclePrice: currentVehicleValue.toDouble(),
          rateAmount: rateAmount / 100,
          rateCapitalization: selectedTNACapitalization,
          desgravamenRate: desgravamentMontlyRate / 100,
          vehicleInsurance: vehicleInsuranceAnnualRate / 100,
          annualCok: annualCOK / 100,
          physicalShipment: physicalShipment,
          paymentPeriod: selectedPeriod,
          graceType: getGraceType(selectedGracePeriod),
          gracePeriod: gracePeriod
              .toInt(), //validate that must be lower than payment period
          lastQuota: getLastQuota(selectedLastQuota),
          administrationCosts: administrationExpenses,
          appraisal: 0,
          notaryCosts: notaryExpenses,
          registrationCosts: registryExpenses,
          rateType: selectedRate,
          user: widget.user);

      print(newVehicleLoan);

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PlanDePago(vehicleLoan: newVehicleLoan)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: CustomSnackBarContent(
            mainTile: "Campos Incompletos!",
            errorText:
                "Por favor, ingrese todos los datos correctamente para continuar",
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  void _updateExistingVehicleLoanCode(String text) {
    setState(() {
      _codeController.text = text;
    });
  }

  void searchExistingPaymentPlanByCode() {
    String code = _codeController.text;

    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: CustomSnackBarContent(
            mainTile: "Campo Vacío",
            errorText: "Por favor ingresa el código del plan de pagos",
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
        setState(() {
          existingVehicleLoanFound = true;
          existingVehicleLoan = vehicleLoans;
          clientName = existingVehicleLoan.client.name;

          clientLastName = existingVehicleLoan.client.lastname;
          mountlyIncome = 0;
          selectedCurrency =
              existingVehicleLoan.currency == 'USD' ? 'DÓLARES' : 'SOLES';
          currentVehicleValue = existingVehicleLoan.vehiclePrice.round();
          vehicleValueController.text = currentVehicleValue.toString();
          rateAmount = existingVehicleLoan.rateAmount * 100;
          desgravamentMontlyRate = existingVehicleLoan.desgravamenRate * 100;
          selectedPeriod = existingVehicleLoan.paymentPeriod;
          vehicleInsuranceAnnualRate = double.parse(
              (existingVehicleLoan.vehicleInsurance * 100).toStringAsFixed(3));
          annualCOK = existingVehicleLoan.annualCok * 100;
          physicalShipment = existingVehicleLoan.physicalShipment;
          administrationExpenses = existingVehicleLoan.administrationCosts;
          notaryExpenses = existingVehicleLoan.notaryCosts;
          registryExpenses = existingVehicleLoan.registrationCosts;
          selectedLoanPercentage =
              (existingVehicleLoan.loanPercentage * 100).round();
          selectedRate = existingVehicleLoan.rateType;
          selectedTNACapitalization = existingVehicleLoan.rateCapitalization;
          selectedGracePeriod = existingVehicleLoan.graceType == 'S'
              ? 'Ninguno'
              : existingVehicleLoan.graceType == 'T'
                  ? 'Total'
                  : 'Parcial';
          gracePeriod = existingVehicleLoan.gracePeriod.toDouble();
          selectedLastQuota = existingVehicleLoan.lastQuota == 'RENOVAR'
              ? 'Se renovará el vehículo'
              : existingVehicleLoan.lastQuota == 'QUEDAR'
                  ? 'Se quedará con el auto'
                  : 'Devolverá el vehículo';

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const CustomSnackBarContent(
                topPosition: -5,
                mainTile: "¡Plan de Pagos Encontrado!",
                errorText: "Se cargaron los datos del plan de pagos",
                backgroundColor: Color.fromARGB(255, 63, 118, 195),
                iconsColor: Color.fromARGB(255, 34, 75, 132),
              ),
              behavior: SnackBarBehavior.floating,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.78),
              backgroundColor: Colors.transparent,
              elevation: 0,
              duration: const Duration(seconds: 3),
            ),
          );
        });

        print("Client Name: $clientName");
      }
    });
  }

  void updatePaymentPlan() {
    //validate data
    bool gracePeriodIsValid = false;

    if (selectedGracePeriod != "Ninguno" &&
        (gracePeriod > 0 && gracePeriod <= 6)) {
      gracePeriodIsValid = true;
    } else if (selectedGracePeriod == "Ninguno") {
      gracePeriodIsValid = true;
    }

    if (clientName.isNotEmpty &&
        clientLastName.isNotEmpty &&
        vehicleValueIsValid(changingVehicleValue) &&
        (rateAmount >= 8 && rateAmount <= 24) &&
        desgravamentMontlyRate > 0 &&
        vehicleInsuranceAnnualRate > 0 &&
        administrationExpenses > 0 &&
        notaryExpenses > 0 &&
        registryExpenses > 0 &&
        gracePeriodIsValid) {
      Client newClient = Client(
        id: existingVehicleLoan.client.id,
        name: existingVehicleLoan.client.name,
        lastname: existingVehicleLoan.client.lastname,
      );

      //create new vehicle loan
      VehicleLoan newVehicleLoan = VehicleLoan(
          id: existingVehicleLoan.id,
          code: existingVehicleLoan.code,
          client: newClient,
          currency: selectedCurrency == 'DÓLARES' ? 'USD' : 'PEN',
          loanPercentage: selectedLoanPercentage.toDouble() / 100,
          startedDate: existingVehicleLoan.startedDate,
          vehiclePrice: currentVehicleValue.toDouble(),
          rateAmount: rateAmount / 100,
          rateCapitalization: selectedTNACapitalization,
          desgravamenRate: desgravamentMontlyRate / 100,
          vehicleInsurance: vehicleInsuranceAnnualRate / 100,
          annualCok: annualCOK / 100,
          physicalShipment: physicalShipment,
          paymentPeriod: selectedPeriod,
          graceType: getGraceType(selectedGracePeriod),
          gracePeriod: gracePeriod.toInt(),
          lastQuota: getLastQuota(selectedLastQuota),
          administrationCosts: administrationExpenses,
          appraisal: 0,
          notaryCosts: notaryExpenses,
          registrationCosts: registryExpenses,
          rateType: selectedRate,
          user: widget.user);

      print(newVehicleLoan);

      VehicleLoanService().updateVehicleLoan(newVehicleLoan).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const CustomSnackBarContent(
              topPosition: -5,
              mainTile: "¡Plan de Pagos Actualizado!",
              errorText: "Se actualizaron los datos del plan de pagos",
              backgroundColor: Color.fromARGB(255, 63, 118, 195),
              iconsColor: Color.fromARGB(255, 34, 75, 132),
            ),
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.78),
            backgroundColor: Colors.transparent,
            elevation: 0,
            duration: const Duration(seconds: 3),
          ),
        );

        setState(() {
          clientName = '';
          clientLastName = '';
          mountlyIncome = 0;
          selectedCurrency = 'SOLES';
          currentVehicleValue = 10000;
          vehicleValueController.text = currentVehicleValue.toString();
          rateAmount = 0;
          desgravamentMontlyRate = 0;
          vehicleInsuranceAnnualRate = 0;
          physicalShipment = 0;
          administrationExpenses = 0;
          notaryExpenses = 0;
          registryExpenses = 0;
          selectedLoanPercentage = 30;
          selectedRate = 'TEA';
          selectedTNACapitalization = 'Diaria';
          selectedGracePeriod = 'Ninguno';
          gracePeriod = 0;
          selectedLastQuota = 'Se renovará el vehículo';
          annualCOK = 0;
          selectedPeriod = 24;
          editMode = false;
          existingVehicleLoanFound = false;
          existingVehicleLoan = VehicleLoan.empty();
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: CustomSnackBarContent(
            mainTile: "Campos Incompletos!",
            errorText:
                "Por favor, ingrese todos los datos correctamente para continuar",
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text(
            'Crédito Vehicular Compra Inteligente',
            style: GoogleFonts.readexPro(
              fontSize: 22,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        body: ListView(
          children: [
            Container(
                margin: MediaQuery.of(context).size.width < webScreenWidth
                    ? const EdgeInsets.symmetric(horizontal: 40)
                    : const EdgeInsets.symmetric(horizontal: 180),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 45,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Crear Plan de Pago",
                              style: GoogleFonts.readexPro(
                                  color: const Color.fromARGB(255, 40, 56, 64),
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500),
                            ),
                            //edit icon button
                            const SizedBox(width: 15),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  editMode = true;
                                });
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: primaryColor,
                              ),
                            ),
                            //create a clean icon button
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  clientName = '';
                                  clientLastName = '';
                                  mountlyIncome = 0;
                                  selectedCurrency = 'SOLES';
                                  currentVehicleValue = 10000;
                                  vehicleValueController.text =
                                      currentVehicleValue.toString();
                                  rateAmount = 0;
                                  desgravamentMontlyRate = 0;
                                  vehicleInsuranceAnnualRate = 0;
                                  physicalShipment = 0;
                                  administrationExpenses = 0;
                                  notaryExpenses = 0;
                                  registryExpenses = 0;
                                  selectedLoanPercentage = 30;
                                  selectedRate = 'TEA';
                                  selectedTNACapitalization = 'Diaria';
                                  selectedGracePeriod = 'Ninguno';
                                  gracePeriod = 24;
                                  selectedLastQuota = 'Se renovará el vehículo';
                                  annualCOK = 0;
                                  existingVehicleLoanFound = false;
                                  editMode = false;
                                  existingVehicleLoan = VehicleLoan.empty();
                                });
                              },
                              icon: const Icon(
                                Icons.cleaning_services,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                        editMode
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CustomButton(
                                      buttonHeight: 50,
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      text: "Buscar",
                                      buttonColor: primaryColor,
                                      textColor: textColor,
                                      onPressed: () {
                                        searchExistingPaymentPlanByCode();
                                      }),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: InputFieldWidget(
                                        hintText:
                                            "Ingrese el código del Plan de Pagos",
                                        onTextChanged:
                                            _updateExistingVehicleLoanCode),
                                  ),
                                ],
                              )
                            : Container(),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text("Datos del Cliente",
                        style: GoogleFonts.readexPro(
                            color: tertiaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 24),
                    InputFieldWidget(
                        hintText:
                            existingVehicleLoanFound ? clientName : "Nombres",
                        onTextChanged: updateClientName),
                    const SizedBox(height: 5),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Text("Ingrese un nombre válido",
                          textAlign: TextAlign.right,
                          style: GoogleFonts.poppins(
                              color: clientName.isEmpty && buttonClicked
                                  ? Colors.red
                                  : const Color.fromARGB(255, 255, 255, 255),
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ]),
                    const SizedBox(height: 11),
                    InputFieldWidget(
                        hintText: existingVehicleLoanFound
                            ? clientLastName
                            : "Apellidos",
                        onTextChanged: updateClientLastName),
                    const SizedBox(height: 5),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Text("Ingrese un apellido válido",
                          textAlign: TextAlign.right,
                          style: GoogleFonts.poppins(
                              color: clientLastName.isEmpty && buttonClicked
                                  ? Colors.red
                                  : const Color.fromARGB(255, 255, 255, 255),
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ]),
                    const SizedBox(height: 30),
                    Text("Moneda",
                        style: GoogleFonts.readexPro(
                            color: tertiaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: currencies
                          .map((currency) => FilterChip(
                                label: Container(
                                    width: 120,
                                    height: 30,
                                    alignment: Alignment.center,
                                    child: Text(
                                      currency,
                                      style: GoogleFonts.readexPro(
                                        color: selectedCurrency == currency
                                            ? Colors.white
                                            : homeInputFileTextColor,
                                      ),
                                    )),
                                selected: selectedCurrency == currency,
                                onSelected: (selected) {
                                  switchCurrency(currency);
                                },
                                selectedColor: primaryColor,
                                backgroundColor: chipUnselectedColor,
                                checkmarkColor: Colors.white,
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 30),
                    Text("Ingreso Mensual",
                        style: GoogleFonts.readexPro(
                            color: tertiaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    InputFieldWidget(
                        hintText: getCurrency(),
                        onTextChanged: updateMonthlyIncome,
                        isNumber: true),
                    const SizedBox(height: 5),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Text(
                          selectedCurrency == 'DÓLARES'
                              ? "El ingreso mensual debe ser mayor a \$${(1500 / 3.8).toStringAsFixed(2)}"
                              : "El ingreso mensual debe ser mayor  a S/ 1500.00",
                          textAlign: TextAlign.right,
                          style: GoogleFonts.poppins(
                              color: (selectedCurrency == "SOLES"
                                          ? mountlyIncome <= 1500
                                          : mountlyIncome <= 1500 / 3.8) &&
                                      buttonClicked
                                  ? Colors.red
                                  : const Color.fromARGB(255, 255, 255, 255),
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ]),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Valor del vehículo",
                            style: GoogleFonts.readexPro(
                                color: tertiaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500)),
                        CustomButton(
                          buttonHeight: 40,
                          radius: 50,
                          fontSize: 15,
                          width: 130,
                          text: "Seleccionar",
                          buttonColor: primaryColor,
                          textColor: textColor,
                          onPressed: () async {
                            Car? selectedCar =
                                await Navigator.of(context).push<Car>(
                              MaterialPageRoute(
                                builder: (context) =>
                                    SelectCar(currency: selectedCurrency),
                              ),
                            );

                            if (selectedCar != null) {
                              setState(() {
                                currentVehicleValue =
                                    selectedCurrency == 'DÓLARES'
                                        ? selectedCar.usdPrice.round()
                                        : selectedCar.price.round();
                                vehicleValueController.text =
                                    currentVehicleValue.toString();
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SliderTheme(
                      data: SliderTheme.of(context)
                          .copyWith(valueIndicatorColor: primaryColor),
                      child: Slider(
                          value: currentVehicleValue.toDouble(),
                          min: minVehicleValue.toDouble(),
                          max: maxVehicleValue.toDouble(),
                          divisions: 100,
                          label: currentVehicleValue.toString(),
                          activeColor: primaryColor,
                          onChanged: (value) {
                            setState(() {
                              print(value);
                              currentVehicleValue = value.round();
                              vehicleValueController.text =
                                  currentVehicleValue.toString();
                              changingVehicleValue =
                                  currentVehicleValue.toString();
                            });
                          }),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextField(
                        controller: vehicleValueController,
                        //focusNode: _focusNode,
                        //obscureText: widget.obscureText,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          hintText: vehicleValueController.text,
                          filled: true,
                          fillColor: primaryColorLight,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: primaryColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: primaryColor),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            //falta validar que este dentro del rango
                            changingVehicleValue = value;
                            if (value.isEmpty ||
                                (selectedCurrency == "SOLES" &&
                                        (int.parse(value) >
                                            maxVehicleValuePEN) ||
                                    (int.parse(value) < minVehicleValuePEN)) ||
                                (selectedCurrency == "DÓLARES" &&
                                        (int.parse(value) >
                                            maxVehicleValueUSD) ||
                                    (int.parse(value) < minVehicleValueUSD))) {
                              return;
                            }
                            print("object$value");
                            currentVehicleValue = int.parse(value);
                            //vehicleValueController.text = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Text(vehicleValueErrorText,
                          textAlign: TextAlign.right,
                          style: GoogleFonts.poppins(
                              color: vehicleValueIsValid(changingVehicleValue)
                                  ? const Color.fromARGB(255, 255, 255, 255)
                                  : Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ]),
                    const SizedBox(height: 15),
                    Text("Cuota Inicial",
                        style: GoogleFonts.readexPro(
                            color: tertiaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: TextField(
                        controller: initialQuotaController,
                        readOnly: true, // Make the TextField uneditable
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          hintText: getInitialQuota(),
                          filled: true,
                          fillColor: primaryColorLight,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: primaryColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: primaryColor),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text("Se abonará el 20% como cuota inicial",
                        textAlign: TextAlign.right,
                        style: GoogleFonts.poppins(
                            color: const Color.fromARGB(255, 148, 148, 148),
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 39),
                    Text("Porcentaje del prestamo",
                        style: GoogleFonts.readexPro(
                            color: tertiaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Radio button for 2 meses
                        Row(
                          children: [
                            Radio(
                              value: 30,
                              groupValue: selectedLoanPercentage,
                              onChanged: (value) {
                                setState(() {
                                  selectedLoanPercentage = value!;
                                });
                              },
                            ),
                            Text(
                              "30%",
                              style: GoogleFonts.readexPro(
                                color: selectedLoanPercentage == 2
                                    ? primaryColor
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),

                        // Radio button for 3 meses
                        Row(
                          children: [
                            Radio(
                              value: 40,
                              groupValue: selectedLoanPercentage,
                              onChanged: (value) {
                                setState(() {
                                  selectedLoanPercentage = value!;
                                });
                              },
                            ),
                            Text(
                              "40%",
                              style: GoogleFonts.readexPro(
                                color: selectedLoanPercentage == 3
                                    ? primaryColor
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text("Tipo de tasa (%)",
                        style: GoogleFonts.readexPro(
                            color: tertiaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: rateTypes
                          .map((rate) => FilterChip(
                                label: Container(
                                    width: 120,
                                    height: 30,
                                    alignment: Alignment.center,
                                    child: Text(
                                      rate,
                                      style: GoogleFonts.readexPro(
                                        color: selectedRate == rate
                                            ? Colors.white
                                            : homeInputFileTextColor,
                                      ),
                                    )),
                                selected: selectedRate == rate,
                                onSelected: (selected) {
                                  switchRate(rate);
                                },
                                selectedColor: primaryColor,
                                backgroundColor: chipUnselectedColor,
                                checkmarkColor: Colors.white,
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    InputFieldWidget(
                        hintText: existingVehicleLoanFound
                            ? rateAmount.toString()
                            : "0 %",
                        onTextChanged: updateAnnualRate,
                        isNumber: true),
                    const SizedBox(height: 5),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Text("Este valor debe estar entre 8% y 24%",
                          textAlign: TextAlign.right,
                          style: GoogleFonts.poppins(
                              color: (rateAmount < 8 || rateAmount > 24) &&
                                      buttonClicked
                                  ? Colors.red
                                  : const Color.fromARGB(255, 255, 255, 255),
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ]),
                    selectedRate == 'TNA'
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 15),
                              Text("Perido de Capitalización",
                                  style: GoogleFonts.readexPro(
                                      color: tertiaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Radio button for 2 meses
                                  Row(
                                    children: [
                                      Radio(
                                        value: "Diaria",
                                        groupValue: selectedTNACapitalization,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedTNACapitalization = value!;
                                          });
                                        },
                                      ),
                                      Text(
                                        "Diaria",
                                        style: GoogleFonts.readexPro(
                                          color: selectedTNACapitalization ==
                                                  "Diaria"
                                              ? primaryColor
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Radio button for 3 meses
                                  Row(
                                    children: [
                                      Radio(
                                        value: "Mensual",
                                        groupValue: selectedTNACapitalization,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedTNACapitalization = value!;
                                          });
                                        },
                                      ),
                                      Text(
                                        "Mensual",
                                        style: GoogleFonts.readexPro(
                                          color: selectedTNACapitalization ==
                                                  "Mensual"
                                              ? primaryColor
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          )
                        : Container(),
                    const SizedBox(height: 20),
                    Text("Seguro desgravament Mensual (%)",
                        style: GoogleFonts.readexPro(
                            color: tertiaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    InputFieldWidget(
                        hintText: existingVehicleLoanFound
                            ? desgravamentMontlyRate.toString()
                            : "0 %",
                        onTextChanged: updateDesgravamentRate,
                        isNumber: true),
                    const SizedBox(height: 5),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Text("Este valor tiene que ser mayor a 0",
                          textAlign: TextAlign.right,
                          style: GoogleFonts.poppins(
                              color: (desgravamentMontlyRate == 0) &&
                                      buttonClicked
                                  ? Colors.red
                                  : const Color.fromARGB(255, 255, 255, 255),
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ]),
                    const SizedBox(height: 20),
                    Text("Seguro vehícular Anual (%)",
                        style: GoogleFonts.readexPro(
                            color: tertiaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    InputFieldWidget(
                        hintText: existingVehicleLoanFound
                            ? vehicleInsuranceAnnualRate.toString()
                            : "0 %",
                        onTextChanged: updateVehicleInsuranceRate,
                        isNumber: true),
                    const SizedBox(height: 5),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Text("Este valor tiene que ser mayor a 0",
                          textAlign: TextAlign.right,
                          style: GoogleFonts.poppins(
                              color: (vehicleInsuranceAnnualRate == 0) &&
                                      buttonClicked
                                  ? Colors.red
                                  : const Color.fromARGB(255, 255, 255, 255),
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ]),
                    const SizedBox(height: 20),
                    Text("COK Anual (%)",
                        style: GoogleFonts.readexPro(
                            color: tertiaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    InputFieldWidget(
                        hintText: existingVehicleLoanFound
                            ? annualCOK.toString()
                            : "0 %",
                        onTextChanged: updateAnnualCOK,
                        isNumber: true),
                    const SizedBox(height: 5),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Text("Este valor tiene que ser mayor a 0",
                          textAlign: TextAlign.right,
                          style: GoogleFonts.poppins(
                              color: (vehicleInsuranceAnnualRate == 0) &&
                                      buttonClicked
                                  ? Colors.red
                                  : const Color.fromARGB(255, 255, 255, 255),
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ]),
                    const SizedBox(height: 20),
                    Text("Envío físico de estado de cuenta (Mensual)",
                        style: GoogleFonts.readexPro(
                            color: tertiaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    InputFieldWidget(
                        hintText:
                            "${getCurrency()} ${existingVehicleLoanFound ? physicalShipment.toString() : "0"}",
                        onTextChanged: updatePhysicalShipment,
                        isNumber: true),
                    const SizedBox(height: 35),
                    Text("Gastos de Administración (Mensual)",
                        style: GoogleFonts.readexPro(
                            color: tertiaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    InputFieldWidget(
                        hintText:
                            "${getCurrency()} ${existingVehicleLoanFound ? administrationExpenses.toString() : "0"}",
                        onTextChanged: updateAdministrationExpenses,
                        isNumber: true),
                    const SizedBox(height: 5),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Text("Este valor tiene que ser mayor a 0",
                          textAlign: TextAlign.right,
                          style: GoogleFonts.poppins(
                              color: (administrationExpenses == 0) &&
                                      buttonClicked
                                  ? Colors.red
                                  : const Color.fromARGB(255, 255, 255, 255),
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ]),
                    const SizedBox(height: 20),
                    Text("Costes Notariales",
                        style: GoogleFonts.readexPro(
                            color: tertiaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    InputFieldWidget(
                        hintText:
                            "${getCurrency()} ${existingVehicleLoanFound ? notaryExpenses.toString() : "0"}",
                        onTextChanged: updateNotaryExpenses,
                        isNumber: true),
                    const SizedBox(height: 5),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Text("Este valor tiene que ser mayor a 0",
                          textAlign: TextAlign.right,
                          style: GoogleFonts.poppins(
                              color: (notaryExpenses == 0) && buttonClicked
                                  ? Colors.red
                                  : const Color.fromARGB(255, 255, 255, 255),
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ]),
                    const SizedBox(height: 20),
                    Text("Costes Registrales",
                        style: GoogleFonts.readexPro(
                            color: tertiaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    InputFieldWidget(
                        hintText:
                            "${getCurrency()} ${existingVehicleLoanFound ? registryExpenses.toString() : "0"}",
                        onTextChanged: updateRegistryExpenses,
                        isNumber: true),
                    const SizedBox(height: 5),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Text("Este valor tiene que ser mayor a 0",
                          textAlign: TextAlign.right,
                          style: GoogleFonts.poppins(
                              color: (registryExpenses == 0) && buttonClicked
                                  ? Colors.red
                                  : const Color.fromARGB(255, 255, 255, 255),
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ]),
                    const SizedBox(height: 25),
                    Text("Periodo de pago (Meses)",
                        style: GoogleFonts.readexPro(
                            color: tertiaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Radio button for 2 meses
                        Row(
                          children: [
                            Radio(
                              value: 24,
                              groupValue: selectedPeriod,
                              onChanged: (value) {
                                setState(() {
                                  selectedPeriod = value!;
                                });
                              },
                            ),
                            Text(
                              "24 meses",
                              style: GoogleFonts.readexPro(
                                color: selectedPeriod == 2
                                    ? primaryColor
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),

                        // Radio button for 3 meses
                        Row(
                          children: [
                            Radio(
                              value: 36,
                              groupValue: selectedPeriod,
                              onChanged: (value) {
                                setState(() {
                                  selectedPeriod = value!;
                                });
                              },
                            ),
                            Text(
                              "36 meses",
                              style: GoogleFonts.readexPro(
                                color: selectedPeriod == 3
                                    ? primaryColor
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text("Periodo de gracia (Meses)",
                        style: GoogleFonts.readexPro(
                            color: tertiaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    Column(
                      children: [
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Ninguno',
                              groupValue: selectedGracePeriod,
                              onChanged: (value) {
                                setState(() {
                                  selectedGracePeriod = value!;
                                });
                              },
                            ),
                            Text(
                              "Ninguno",
                              style: GoogleFonts.readexPro(
                                color: selectedGracePeriod == 'Ninguno'
                                    ? primaryColor
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Total',
                              groupValue: selectedGracePeriod,
                              onChanged: (value) {
                                setState(() {
                                  selectedGracePeriod = value!;
                                });
                              },
                            ),
                            Text(
                              "Total",
                              style: GoogleFonts.readexPro(
                                color: selectedGracePeriod == 'Total'
                                    ? primaryColor
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Parcial',
                              groupValue: selectedGracePeriod,
                              onChanged: (value) {
                                setState(() {
                                  selectedGracePeriod = value!;
                                });
                              },
                            ),
                            Text(
                              "Parcial",
                              style: GoogleFonts.readexPro(
                                color: selectedGracePeriod == 'Parcial'
                                    ? primaryColor
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    selectedGracePeriod != 'Ninguno'
                        ? Column(
                            children: [
                              const SizedBox(height: 10),
                              InputFieldWidget(
                                hintText: existingVehicleLoanFound
                                    ? gracePeriod.toString()
                                    : "0 meses",
                                onTextChanged: updateGracePeriod,
                              ),
                              const SizedBox(height: 5),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                        "Este valor tiene que ser mayor a 0 y maximo 6 meses",
                                        textAlign: TextAlign.right,
                                        style: GoogleFonts.poppins(
                                            color: (gracePeriod <= 0 ||
                                                        gracePeriod > 6) &&
                                                    buttonClicked
                                                ? Colors.red
                                                : const Color.fromARGB(
                                                    255, 255, 255, 255),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600)),
                                  ]),
                              const SizedBox(height: 10),
                            ],
                          )
                        : const SizedBox(height: 0),
                    const SizedBox(height: 20),
                    Text("Tras pagar la última cuota",
                        style: GoogleFonts.readexPro(
                            color: tertiaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    Column(
                      children: [
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Se renovará el vehículo',
                              groupValue: selectedLastQuota,
                              onChanged: (value) {
                                setState(() {
                                  selectedLastQuota = value!;
                                });
                              },
                            ),
                            Text(
                              "Se renovará el vehículo",
                              style: GoogleFonts.readexPro(
                                color: selectedLastQuota ==
                                        'Se renovará el vehículo'
                                    ? primaryColor
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Se quedará con el auto',
                              groupValue: selectedLastQuota,
                              onChanged: (value) {
                                setState(() {
                                  selectedLastQuota = value!;
                                });
                              },
                            ),
                            Text(
                              "Se quedará con el auto",
                              style: GoogleFonts.readexPro(
                                color: selectedLastQuota ==
                                        'Se quedará con el auto'
                                    ? primaryColor
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Devolverá el auto',
                              groupValue: selectedLastQuota,
                              onChanged: (value) {
                                setState(() {
                                  selectedLastQuota = value!;
                                });
                              },
                            ),
                            Text(
                              "Devolverá el auto",
                              style: GoogleFonts.readexPro(
                                color: selectedLastQuota == 'Devolverá el auto'
                                    ? primaryColor
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: existingVehicleLoanFound
                          ? "Actualizar Plan de Pagos"
                          : "Generar Plan de Pagos",
                      buttonColor: primaryColor,
                      textColor: textColor,
                      onPressed: () {
                        existingVehicleLoanFound
                            ? {updatePaymentPlan()}
                            : {
                                setState(() {
                                  buttonClicked = true;
                                }),
                                validateData()
                              };
                      },
                    ),
                    const SizedBox(height: 50),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
