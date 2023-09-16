import 'package:flutter/material.dart';
import 'package:scholarsync/theme/palette.dart';

class LecturerInformation extends StatelessWidget {
  final String id;
  final String name;
  final String email;
  final String imageUrl;

  const LecturerInformation({super.key, 
    required this.id,
    required this.name,
    required this.email,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
      decoration: BoxDecoration(
        color: PaletteLightMode.backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: PaletteLightMode.shadowColor,
            offset: Offset(8, 8),
            blurRadius: 24,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: AssetImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                name,
                style:
                    const TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6.0),
              Text(
                email,
                style: const TextStyle(
                    fontSize: 14, 
                    color: PaletteLightMode.secondaryTextColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
