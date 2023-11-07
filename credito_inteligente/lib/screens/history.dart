import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../styles/styles.dart';

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> userData = [
      {
        'name': 'John Doe',
        'time': '13:23',
        'amount': 4000,
      },
      {
        'name': 'John Doe',
        'time': '13:23',
        'amount': 4000,
      },
      {
        'name': 'John Doe',
        'time': '13:23',
        'amount': 4000,
      },
      {
        'name': 'John Doe',
        'time': '13:23',
        'amount': 4000,
      },
      {
        'name': 'John Doe',
        'time': '13:23',
        'amount': 4000,
      },
      {
        'name': 'John Doe',
        'time': '13:23',
        'amount': 4000,
      },
      {
        'name': 'John Doe',
        'time': '13:23',
        'amount': 4000,
      },
      {
        'name': 'John Doe',
        'time': '13:23',
        'amount': 4000,
      },
      {
        'name': 'John Doe',
        'time': '13:23',
        'amount': 4000,
      },
      {
        'name': 'John Doe',
        'time': '13:23',
        'amount': 4000,
      },
      {
        'name': 'John Doe',
        'time': '13:23',
        'amount': 4000,
      },
      {
        'name': 'John Doe',
        'time': '13:23',
        'amount': 4000,
      },
      {
        'name': 'John Doe',
        'time': '13:23',
        'amount': 4000,
      },
      // Add more user data entries as needed
    ];

    Color generateRandomColor() {
      final Random random = Random();
      final int r = random
          .nextInt(256); // Generate a random value for the red channel (0-255)
      final int g = random.nextInt(
          256); // Generate a random value for the green channel (0-255)
      final int b = random
          .nextInt(256); // Generate a random value for the blue channel (0-255)

      return Color.fromARGB(255, r, g, b); // Create and return a Color object
    }

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
                    "Historial",
                    style: GoogleFonts.readexPro(
                      color: tertiaryColor,
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  "Planes generados",
                  style: GoogleFonts.readexPro(
                    color: tertiaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.8, // Set a fixed height for the list
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: userData.length,
                    itemBuilder: (context, index) {
                      final user = userData[index];
                      final initials = user['name'][0].toUpperCase();

                      return ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: generateRandomColor(),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                              child: Text(
                            initials,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w400),
                          )),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(user['name']),
                            const SizedBox(width: 8),
                            Text(user['amount'].toString()),
                          ],
                        ),
                        subtitle: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(user['time']),
                                const Text('Crédito'),
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
