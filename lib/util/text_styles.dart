import 'package:flutter/material.dart';
import 'package:findmepcparts/util/colors.dart';

final appBarTitleTextStyle = TextStyle(
  color: AppColors.appBarTitleColor,
  fontFamily: 'Roboto',
  fontWeight: FontWeight.bold,
  fontSize: 40.0,
  letterSpacing: -0.7,
);

final numberTextStyle = TextStyle(
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w800,
  fontSize: 17.0,
  color: AppColors.bodyLabelColor,
);

final buttonTextStyle = TextStyle(
  fontFamily: 'Roboto',
  fontSize: 17.0,
  color: AppColors.buttonTextColor,
  fontWeight: FontWeight.w600,
);

final bodyLabelStyle = TextStyle(
  fontFamily: 'Roboto',
  fontSize: 17.0,
  color: AppColors.bodyLabelColor,
  fontWeight: FontWeight.w600,
);

final bodyTitleStyle = TextStyle(
  fontFamily: 'Roboto',
  fontSize: 20.0,
  color: AppColors.bodyTitleColor,
);

final bodyTextStyle = TextStyle(
  fontFamily: 'Roboto',
  fontSize: 14.0,
  color: AppColors.bodyTextColor,
);

final navigationBarIconTextStyle = TextStyle(
  fontFamily: 'Roboto',
  fontSize: 30.0,
  color: AppColors.navigationBarIconTextColor,
  fontWeight: FontWeight.w900,
);

final settingsHeadline = TextStyle(
  fontFamily: 'Roboto',
  fontSize: 26,
  fontWeight: FontWeight.bold,
  color: AppColors.appBarTitleColor,
);

final settingsTitle = TextStyle(
  fontFamily: 'Roboto',
  fontSize: 20,
  fontWeight: FontWeight.w600,
  color: AppColors.bodyTitleColor,
);

final settingsBody = TextStyle(
  fontFamily: 'Roboto',
  fontSize: 24,
  color: AppColors.bodyTextColor,
);

final settingsMuted = TextStyle(
  fontFamily: 'Roboto',
  fontSize: 16,
  color: Color(0xFF757575),
);

final buttonStyle = ElevatedButton.styleFrom(
  backgroundColor: AppColors.buttonBackgroundColor,
  foregroundColor: AppColors.buttonTextColor,
);

final loginButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: AppColors.buttonBackgroundColor,
  foregroundColor: AppColors.buttonTextColor,
  minimumSize: const Size.fromHeight(50),
);

final guestButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: AppColors.buttonTextColor,
  
  foregroundColor: AppColors.buttonBackgroundColor,
  minimumSize: const Size.fromHeight(50),
  side: const BorderSide(
    color: Colors.grey, // or AppColors.yourBorderColor
    width: 2, // optional: border width
  ),
);

final logoTextStyle = TextStyle(
  fontSize: 28,
  color: Colors.white,
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w300,
);
final logoTextStyle2 = TextStyle(
  fontSize: 28,
  color: Colors.black,
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w900,
);

final formBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8),
  borderSide: BorderSide(color: Colors.black, width: 1.5),
);
