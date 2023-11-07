import 'package:credito_inteligente/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../styles/styles.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> currencies = ['SOLES', 'DÓLARES'];

  String selectedCurrency = 'SOLES';
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

  final TextEditingController vehicleValueController = TextEditingController();
  final TextEditingController initialQuotaController = TextEditingController();

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

  String getInitialQuota() {
    initialQuota = currentVehicleValue * initialQuotaPercentage;

    if (selectedCurrency == 'DÓLARES') {
      return '\$${initialQuota.toStringAsFixed(2)}';
    } else {
      return 'S/ ${initialQuota.toStringAsFixed(2)}';
    }
  }

  @override
  void initState() {
    super.initState();

    vehicleValueController.text =
        currentVehicleValue.toString(); // Initialize input field value

    if (selectedCurrency == 'DÓLARES') {
      minVehicleValue = minVehicleValueUSD;
      maxVehicleValue = maxVehicleValueUSD;
    } else {
      minVehicleValue = minVehicleValuePEN;
      maxVehicleValue = maxVehicleValuePEN;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 60,
                    ),
                    Text(
                      "Crédito Vehicular\nCompra Inteligente",
                      style: GoogleFonts.readexPro(
                          color: tertiaryColor,
                          fontSize: 30,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 30),
                    Text("Datos del Cliente",
                        style: GoogleFonts.readexPro(
                            color: tertiaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 24),
                    InputFieldWidget(
                        hintText: "Nombres", onTextChanged: (string) {}),
                    const SizedBox(height: 11),
                    InputFieldWidget(
                        hintText: "Apellidos", onTextChanged: (string) {}),
                    const SizedBox(height: 39),
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
                        hintText: "S/",
                        onTextChanged: (string) {},
                        isNumber: true),
                    const SizedBox(height: 30),
                    Text("Valor del vehículo",
                        style: GoogleFonts.readexPro(
                            color: tertiaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
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
                                    value.length >
                                        maxVehicleValuePEN.toString().length) ||
                                (selectedCurrency == "DÓLARES" &&
                                    value.toString().length >
                                        maxVehicleValueUSD.toString().length)) {
                              return;
                            }

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



          


                  ],
                )),
          ],
        ),
      ),
    );
  }
}
