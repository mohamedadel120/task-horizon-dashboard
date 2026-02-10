import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/theming/font_weight_helper.dart';

class TextStyles {
  static const String _fontFamily = 'Changa';

  static TextStyle _createTextStyle({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
  }) {
    return TextStyle(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: color,
      fontFamily: _fontFamily,
    );
  }

  static TextStyle font24BlackBold = _createTextStyle(
    fontSize: 24,
    fontWeight: FontWeightHelper.bold,
    color: Colors.black,
  );
  static TextStyle font20BlackBold = _createTextStyle(
    fontSize: 20,
    fontWeight: FontWeightHelper.bold,
    color: Colors.black,
  );

  static TextStyle font14GreenBold = _createTextStyle(
    fontSize: 14,
    fontWeight: FontWeightHelper.bold,
    color: ColorManager.textDark50,
  );

  static TextStyle font32GreenBold = _createTextStyle(
    fontSize: 32,
    fontWeight: FontWeightHelper.bold,
    color: ColorManager.mainColor,
  );

  static TextStyle font13BlueSemiBold = _createTextStyle(
    fontSize: 13,
    fontWeight: FontWeightHelper.semiBold,
    color: ColorManager.mainColor,
  );

  static TextStyle font13DarkBlueMedium = _createTextStyle(
    fontSize: 13,
    fontWeight: FontWeightHelper.medium,
    color: ColorManager.darkBlue,
  );

  static TextStyle font13DarkBlueRegular = _createTextStyle(
    fontSize: 13,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.darkBlue,
  );

  static TextStyle font24GreenBold = _createTextStyle(
    fontSize: 24,
    fontWeight: FontWeightHelper.bold,
    color: ColorManager.mainColor,
  );

  static TextStyle font16WhiteSemiBold = _createTextStyle(
    fontSize: 16,
    fontWeight: FontWeightHelper.semiBold,
    color: Colors.white,
  );
  static TextStyle font16GrayRegular = _createTextStyle(
    fontSize: 16,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.gray,
  );
  static TextStyle font17BlackRegular = _createTextStyle(
    fontSize: 17,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.textDark100,
  );

  static TextStyle font13GrayRegular = _createTextStyle(
    fontSize: 13,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.gray,
  );

  static TextStyle font12GrayRegular = _createTextStyle(
    fontSize: 12,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.gray,
  );
  static TextStyle font24BlueBold = _createTextStyle(
    fontSize: 24,
    fontWeight: FontWeightHelper.bold,
    color: ColorManager.mainColor,
  );

  static TextStyle font12GrayMedium = _createTextStyle(
    fontSize: 12,
    fontWeight: FontWeightHelper.medium,
    color: ColorManager.gray,
  );

  static TextStyle font12DarkBlueRegular = _createTextStyle(
    fontSize: 12,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.darkBlue,
  );
  static TextStyle font12DarkBlueBold = _createTextStyle(
    fontSize: 12,
    fontWeight: FontWeightHelper.bold,
    color: ColorManager.darkBlue,
  );

  static TextStyle font12BlueRegular = _createTextStyle(
    fontSize: 12,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.mainColor,
  );

  static TextStyle font13BlueRegular = _createTextStyle(
    fontSize: 13,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.mainColor,
  );

  static TextStyle font14GrayRegular = _createTextStyle(
    fontSize: 14,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.gray,
  );

  static TextStyle font14LightGrayRegular = _createTextStyle(
    fontSize: 14,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.lightGray,
  );
  static TextStyle font14WhiteRegular = _createTextStyle(
    fontSize: 14,
    fontWeight: FontWeightHelper.regular,
    color: Colors.white,
  );

  static TextStyle font14DarkBlueMedium = _createTextStyle(
    fontSize: 14,
    fontWeight: FontWeightHelper.medium,
    color: ColorManager.darkBlue,
  );

  static TextStyle font14DarkBlueBold = _createTextStyle(
    fontSize: 14,
    fontWeight: FontWeightHelper.bold,
    color: ColorManager.darkBlue,
  );

  static TextStyle font16WhiteMedium = _createTextStyle(
    fontSize: 16,
    fontWeight: FontWeightHelper.medium,
    color: Colors.white,
  );
  static TextStyle font16BlackRegular = _createTextStyle(
    fontSize: 16,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.textDark70,
  );
  static TextStyle font16BlackMedium = _createTextStyle(
    fontSize: 16,
    fontWeight: FontWeightHelper.medium,
    color: ColorManager.textDark70,
  );
  static TextStyle font16BlackSemiBold = _createTextStyle(
    fontSize: 16,
    fontWeight: FontWeightHelper.semiBold,
    color: ColorManager.textDark70,
  );
  static TextStyle font16WhiteRegular = _createTextStyle(
    fontSize: 16,
    fontWeight: FontWeightHelper.regular,
    color: Colors.white,
  );

  static TextStyle font16OrangeRegular = _createTextStyle(
    fontSize: 16,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.accent100,
  );

  static TextStyle font14BlueSemiBold = _createTextStyle(
    fontSize: 14,
    fontWeight: FontWeightHelper.semiBold,
    color: ColorManager.mainColor,
  );
  static TextStyle font14BlackRegular = _createTextStyle(
    fontSize: 14,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.textDark70,
  );
  static TextStyle font12BlackRegular = _createTextStyle(
    fontSize: 12,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.textDark50,
  );
  static TextStyle font12BlackMedium = _createTextStyle(
    fontSize: 12,
    fontWeight: FontWeightHelper.medium,
    color: ColorManager.textDark50,
  );

  static TextStyle font15DarkBlueMedium = _createTextStyle(
    fontSize: 15,
    fontWeight: FontWeightHelper.medium,
    color: ColorManager.darkBlue,
  );

  static TextStyle font18DarkBlueBold = _createTextStyle(
    fontSize: 18,
    fontWeight: FontWeightHelper.bold,
    color: ColorManager.darkBlue,
  );

  static TextStyle font18DarkBlueSemiBold = _createTextStyle(
    fontSize: 18,
    fontWeight: FontWeightHelper.semiBold,
    color: ColorManager.darkBlue,
  );

  static TextStyle font18WhiteMedium = _createTextStyle(
    fontSize: 18,
    fontWeight: FontWeightHelper.medium,
    color: Colors.white,
  );

  static TextStyle font18BlackSemiBold = _createTextStyle(
    fontSize: 18,
    fontWeight: FontWeightHelper.semiBold,
    color: Colors.black,
  );

  static TextStyle font10WhiteRegular = _createTextStyle(
    fontSize: 10,
    fontWeight: FontWeightHelper.regular,
    color: Colors.white,
  );

  static TextStyle font10GrayRegular = _createTextStyle(
    fontSize: 10,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.gray,
  );

  static TextStyle font10WhiteSemiBold = _createTextStyle(
    fontSize: 10,
    fontWeight: FontWeightHelper.semiBold,
    color: Colors.white,
  );

  static TextStyle font12WhiteSemiBold = _createTextStyle(
    fontSize: 12,
    fontWeight: FontWeightHelper.semiBold,
    color: Colors.white,
  );

  static TextStyle font12OrangeRegular = _createTextStyle(
    fontSize: 12,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.orange,
  );

  static TextStyle font12BlueMedium = _createTextStyle(
    fontSize: 12,
    fontWeight: FontWeightHelper.medium,
    color: ColorManager.mainColor,
  );
}
