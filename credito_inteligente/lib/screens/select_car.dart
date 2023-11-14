import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/car.dart';
import '../styles/styles.dart';

class SelectCar extends StatefulWidget {
  final String currency;
  const SelectCar({
    super.key,
    required this.currency,
  });

  @override
  State<SelectCar> createState() => _SelectCarState();
}

class _SelectCarState extends State<SelectCar> {
  @override
  Widget build(BuildContext context) {
    final List<Car> cars = [
      Car(
        imagePath: 'assets/images/chevrolet_onix.jpg',
        name: 'Chevrolet Onix',
        color: const Color.fromARGB(255, 34, 152, 168),
        colorName: "Azul",
        price: 45000,
        usdPrice: double.parse((45000 / 3.8).toStringAsFixed(2)),
      ),
      Car(
        imagePath: 'assets/images/DFSK_Glory_580.png',
        name: 'DFSK Glory 580',
        color: Colors.red,
        colorName: "Rojo",
        price: 43000,
        usdPrice: double.parse((43000 / 3.8).toStringAsFixed(2)),
      ),
      Car(
        imagePath: 'assets/images/Geely_GX3.png',
        name: 'Geely GX3',
        color: const Color.fromARGB(255, 34, 152, 168),
        colorName: "Azul",
        price: 39000,
        usdPrice: double.parse((39000 / 3.8).toStringAsFixed(2)),
      ),
      Car(
        imagePath: 'assets/images/toyota_hilux.png',
        name: 'Toyota Hilux',
        color: const Color.fromARGB(255, 212, 212, 212),
        colorName: "Plomo",
        price: 49000,
        usdPrice: double.parse((49000 / 3.8).toStringAsFixed(2)),
      ),
      Car(
        imagePath: 'assets/images/kia_soluto.png',
        name: 'Kia Soluto',
        color: const Color.fromARGB(255, 212, 212, 212),
        colorName: "Plomo",
        price: 41000,
        usdPrice: double.parse((41000 / 3.8).toStringAsFixed(2)),
      ),
      Car(
        imagePath: 'assets/images/toyota_rush.jpg',
        color: const Color.fromARGB(255, 212, 212, 212),
        name: 'Toyota Rush',
        colorName: "Plomo",
        price: 47000,
        usdPrice: double.parse((47000 / 3.8).toStringAsFixed(2)),
      ),
      Car(
        imagePath: 'assets/images/kia_picanto.jpg',
        name: 'Kia Picanto',
        color: const Color.fromARGB(255, 212, 212, 212),
        colorName: "Plomo",
        price: 43000,
        usdPrice: double.parse((43000 / 3.8).toStringAsFixed(2)),
      ),
      Car(
          imagePath: 'assets/images/toyota_etios.jpg',
          name: 'Toyota Etios',
          color: const Color.fromARGB(255, 43, 43, 43),
          colorName: "Negro",
          price: 49700,
          usdPrice: double.parse((49700 / 3.8).toStringAsFixed(2))),
      Car(
          imagePath: 'assets/images/toyota_yaris.png',
          name: 'Toyota Yaris',
          color: Colors.black,
          colorName: "Negro",
          price: 46000,
          usdPrice: double.parse((46000 / 3.8).toStringAsFixed(2))),
    ];

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Center(
                  child: Text(
                    "Escoja un Auto",
                    style: GoogleFonts.readexPro(
                      color: tertiaryColor,
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  "Autos Nuevos",
                  style: GoogleFonts.readexPro(
                    color: tertiaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  color: tertiaryColor,
                  height: 4,
                  width: double.infinity,
                ),
                const SizedBox(height: 5),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: cars.length,
                    itemBuilder: (context, index) {
                      final car = cars[index];
                      return ListTile(
                        leading: Image.network(
                          car.imagePath,
                          width: 100,
                          fit: BoxFit.contain,
                        ),
                        title: Text(car.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: car.color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(car.colorName),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  widget.currency == "SOLES"
                                      ? "S/ ${car.price}"
                                      : "\$ ${car.usdPrice.round()}",
                                  style: GoogleFonts.readexPro(
                                    color: tertiaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Spacer(),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(car);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.black),
                                  ),
                                  child: const Text('Seleccionar',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
