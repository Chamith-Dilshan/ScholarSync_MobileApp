import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scholarsync/constants/icon_constants.dart';
import 'package:scholarsync/constants/image_constants.dart';
import 'package:scholarsync/theme/palette.dart';

class ProfileInfo extends StatelessWidget {
  final String studentName;
  final String degree;
  final String batch;

  const ProfileInfo({
    super.key,
    required this.studentName,
    required this.degree,
    required this.batch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 700,
      height: 220,
      decoration: BoxDecoration(
        color: PaletteLightMode.primaryGreenColor,
        border: Border.all(
          color: PaletteLightMode.primaryGreenColor,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      //backgroundImage: AssetImage(ImageConstants.profileImage), // Add your image path here
                    ),
                    Container(
                      width: 32, // Set the desired width for the container
                      height: 32, // Set the desired height for the container
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: PaletteLightMode
                            .secondaryGreenColor, // Choose the background color you want for the camera icon
                      ),
                      child: IconButton(
                        onPressed: () {
                          // Handle camera icon pressed (profile edit page)
                        },
                        iconSize: 18, // Set the desired icon size
                        icon: SvgPicture.asset(IconConstants.cameraIcon),
                        color: PaletteLightMode.whiteColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  studentName,
                  style: const TextStyle(
                    fontSize: 20,
                    color: PaletteLightMode.whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  degree,
                  style: const TextStyle(
                    color: PaletteLightMode.whiteColor,
                    fontSize: 14,
                  ),
                ),
                Text(
                  batch,
                  style: const TextStyle(
                    color: PaletteLightMode.whiteColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
