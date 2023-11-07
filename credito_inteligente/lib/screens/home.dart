import 'package:credito_inteligente/screens/select_car.dart';
import 'package:credito_inteligente/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/car.dart';
import '../styles/styles.dart';
import '../widgets/button.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> currencies = ['SOLES', 'DÓLARES'];
  final List<String> rateTypes = ['TEA', 'TNA'];
  double ratePercentage = 3.42;

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
  String selectedLastInstallmentOption = 'Se renovará el vehículo';

  final TextEditingController vehicleValueController = TextEditingController();
  final TextEditingController initialQuotaController = TextEditingController();
  final TextEditingController rateController = TextEditingController();

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
                        hintText: getCurrency(),
                        onTextChanged: (string) {},
                        isNumber: true),
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
                                builder: (context) => const SelectCar(),
                              ),
                            );

                            if (selectedCar != null) {
                              print("ICUUUU");
                              setState(() {
                                currentVehicleValue = selectedCar.price.toInt();
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
                    const SizedBox(height: 12),
                    InputFieldWidget(
                        hintText: "0 %",
                        onTextChanged: (string) {},
                        isNumber: true),
                    const SizedBox(height: 30),
                    Text("Seguro desgravament Mensual (%)",
                        style: GoogleFonts.readexPro(
                            color: tertiaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    InputFieldWidget(
                        hintText: "0 %",
                        onTextChanged: (string) {},
                        isNumber: true),
                    const SizedBox(height: 30),
                    Text("Seguro vehícular Mensual (%)",
                        style: GoogleFonts.readexPro(
                            color: tertiaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    InputFieldWidget(
                        hintText: "0 %",
                        onTextChanged: (string) {},
                        isNumber: true),
                    const SizedBox(height: 30),
                    Text("Envío físico de estado de cuenta",
                        style: GoogleFonts.readexPro(
                            color: tertiaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    InputFieldWidget(
                        hintText: "${getCurrency()} 0",
                        onTextChanged: (string) {},
                        isNumber: true),
                    const SizedBox(height: 30),
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
                              groupValue: selectedLastInstallmentOption,
                              onChanged: (value) {
                                setState(() {
                                  selectedLastInstallmentOption = value!;
                                });
                              },
                            ),
                            Text(
                              "Se renovará el vehículo",
                              style: GoogleFonts.readexPro(
                                color: selectedLastInstallmentOption ==
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
                              groupValue: selectedLastInstallmentOption,
                              onChanged: (value) {
                                setState(() {
                                  selectedLastInstallmentOption = value!;
                                });
                              },
                            ),
                            Text(
                              "Se quedará con el auto",
                              style: GoogleFonts.readexPro(
                                color: selectedLastInstallmentOption ==
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
                              groupValue: selectedLastInstallmentOption,
                              onChanged: (value) {
                                setState(() {
                                  selectedLastInstallmentOption = value!;
                                });
                              },
                            ),
                            Text(
                              "Devolverá el auto",
                              style: GoogleFonts.readexPro(
                                color: selectedLastInstallmentOption ==
                                        'Devolverá el auto'
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
                      text: "Iniciar Sesión",
                      buttonColor: primaryColor,
                      textColor: textColor,
                      onPressed: () {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) => const Login2()));
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
