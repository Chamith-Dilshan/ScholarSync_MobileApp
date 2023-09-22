import 'package:flutter/material.dart';
import 'package:scholarsync/constants/icon_constants.dart';
import 'package:scholarsync/theme/palette.dart';
import '../../utils/student_repository.dart';
import 'circular_icon_button.dart';

class ProfileInfo extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String degreeProgram;
  final String batch;
  final String studentId;
  final String profileImageUrl;
  final String id;

  const ProfileInfo({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.degreeProgram,
    required this.batch,
    required this.studentId,
    required this.profileImageUrl,
    required this.id,
  });

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(widget.profileImageUrl),
                    radius: 90 / 2,
                  ),
                ),
              ),
              Positioned(
                bottom: -(20 / 1000),
                right: -(20 / 1000),
                child: CircularIconButton(
                  buttonSize: 20,
                  iconAsset: IconConstants.cameraIcon,
                  iconColor: PaletteLightMode.whiteColor,
                  buttonColor: PaletteLightMode.secondaryGreenColor,
                  onPressed: () {
                    StudentRepository.updateProfileImageURL(
                        widget.id, widget.studentId);
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${widget.firstName} ${widget.lastName} - ${widget.studentId}',
            style: const TextStyle(
              fontSize: 20,
              color: PaletteLightMode.whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            widget.degreeProgram,
            style: const TextStyle(
              color: PaletteLightMode.whiteColor,
              fontSize: 14,
            ),
          ),
          Text(
            'Batch - ${widget.batch}',
            style: const TextStyle(
              color: PaletteLightMode.whiteColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
