import 'dart:ui';

class Car {
  final String imagePath;
  final String name;
  final Color color;
  final String colorName;
  final double price;
  final double usdPrice;

  Car({
    required this.imagePath,
    required this.name,
    required this.colorName,
    required this.color,
    required this.price,
    required this.usdPrice,
  });
}
