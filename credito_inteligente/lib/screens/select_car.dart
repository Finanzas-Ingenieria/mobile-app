import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/car.dart';
import '../styles/styles.dart';

class SelectCar extends StatelessWidget {
  const SelectCar({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Car> cars = [
      Car(
        imageUrl:
            'https://w7.pngwing.com/pngs/38/708/png-transparent-car-mercedes-car-love-compact-car-vehicle.png',
        name: 'Hyundai 54',
        color: Colors.blue,
        price: 25000.0,
      ),
      Car(
        imageUrl:
            'https://w7.pngwing.com/pngs/38/708/png-transparent-car-mercedes-car-love-compact-car-vehicle.png',
        name: 'Car 2',
        color: Colors.red,
        price: 30000.0,
      ),
      Car(
        imageUrl:
            'https://w7.pngwing.com/pngs/38/708/png-transparent-car-mercedes-car-love-compact-car-vehicle.png',
        name: 'Car 3',
        color: Colors.green,
        price: 35000.0,
      ),
      Car(
        imageUrl:
            'https://w7.pngwing.com/pngs/38/708/png-transparent-car-mercedes-car-love-compact-car-vehicle.png',
        name: 'Car 1',
        color: Colors.blue,
        price: 25000.0,
      ),
      Car(
        imageUrl:
            'https://w7.pngwing.com/pngs/38/708/png-transparent-car-mercedes-car-love-compact-car-vehicle.png',
        name: 'Car 2',
        color: Colors.red,
        price: 30000.0,
      ),
      Car(
        imageUrl:
            'https://w7.pngwing.com/pngs/38/708/png-transparent-car-mercedes-car-love-compact-car-vehicle.png',
        name: 'Car 3',
        color: Colors.green,
        price: 35000.0,
      ),
      Car(
        imageUrl:
            'https://w7.pngwing.com/pngs/38/708/png-transparent-car-mercedes-car-love-compact-car-vehicle.png',
        name: 'Car 1',
        color: Colors.blue,
        price: 25000.0,
      ),
      Car(
        imageUrl:
            'https://w7.pngwing.com/pngs/38/708/png-transparent-car-mercedes-car-love-compact-car-vehicle.png',
        name: 'Car 2',
        color: Colors.red,
        price: 30000.0,
      ),
      Car(
        imageUrl:
            'https://w7.pngwing.com/pngs/38/708/png-transparent-car-mercedes-car-love-compact-car-vehicle.png',
        name: 'Car 3',
        color: Colors.green,
        price: 35000.0,
      ),
      // Add more cars as needed
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
                    "Escoja el coche",
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
                          car.imageUrl,
                          width: 80,
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
                                const Text("Red"),
                              ],
                            ),
                            Row(
                              children: [
                                Text('\$${car.price.toStringAsFixed(2)}'),
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
