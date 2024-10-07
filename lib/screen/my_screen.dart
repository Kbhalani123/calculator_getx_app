import 'package:calculator_getx_app/controller/calculate_controller.dart';
import 'package:calculator_getx_app/controller/theme_controller.dart';
import 'package:calculator_getx_app/utils/colors.dart';
import 'package:calculator_getx_app/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  final List<String> buttons = [
    "C", "DEL", "%", "/", "9", "8", "7", "x",
    "6", "5", "4", "-", "3", "2", "1", "+",
    "0", ".", "ANS", "=",
  ];

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final calculateController = Get.find<CalculateController>();

    return GetBuilder<ThemeController>(builder: (context) {
      return Scaffold(
        backgroundColor: themeController.isDark ? DarkColors.scaffoldBgColor : LightColors.scaffoldBgColor,
        body: Column(
          children: [
            GetBuilder<CalculateController>(builder: (context) {
              return outputSection(themeController, calculateController);
            }),
            inputSection(themeController, calculateController),
          ],
        ),
      );
    });
  }

  /// Input Section - Enter Numbers
  Widget inputSection(ThemeController themeController, CalculateController controller) {
    return Expanded(
      flex: 2,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: themeController.isDark ? DarkColors.sheetBgColor : LightColors.sheetBgColor,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: buttons.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
          itemBuilder: (context, index) {
            return buildButton(index, themeController, controller);
          },
        ),
      ),
    );
  }

  /// Builds buttons with predefined actions
  Widget buildButton(int index, ThemeController themeController, CalculateController controller) {
    final buttonText = buttons[index];
    final isOperatorButton = isOperator(buttonText);

    return CustomAppButton(
      buttonTapped: () => onButtonTapped(index, controller),
      color: isOperatorButton ? LightColors.operatorColor : (themeController.isDark ? DarkColors.btnBgColor : LightColors.btnBgColor),
      textColor: isOperatorButton ? Colors.white : (themeController.isDark ? Colors.white : Colors.black),
      text: buttonText,
    );
  }

  /// Button action based on index
  void onButtonTapped(int index, CalculateController controller) {
    switch (index) {
      case 0:
        controller.clearInputAndOutput(); // C
        break;
      case 1:
        controller.deleteBtnAction(); // DEL
        break;
      case 19:
        controller.equalPressed(); // EQUAL
        break;
      default:
        controller.onBtnTapped(buttons, index);
        break;
    }
  }

  /// Output Section - Show Result
  Widget outputSection(ThemeController themeController, CalculateController controller) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            themeSwitcher(themeController),
            resultDisplay(controller, themeController),
          ],
        ),
      ),
    );
  }

  /// Theme Switcher
  Widget themeSwitcher(ThemeController themeController) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: GetBuilder<ThemeController>(builder: (controller) {
        return AdvancedSwitch(
          controller: controller.switcherController,
          activeImage: const AssetImage('assets/day_sky.png'),
          inactiveImage: const AssetImage('assets/night_sky.jpg'),
          activeColor: Colors.green,
          inactiveColor: Colors.grey,
          activeChild: Text(
            'Day',
            style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          inactiveChild: Text(
            'Night',
            style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(1000)),
          width: 100.0,
          height: 45.0,
          enabled: true,
          disabledOpacity: 0.5,
        );
      }),
    );
  }

  /// Result Display Area
  Widget resultDisplay(CalculateController controller, ThemeController themeController) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, top: 70),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            child: Text(
              controller.userInput,
              style: GoogleFonts.ubuntu(color: themeController.isDark ? Colors.white : Colors.black, fontSize: 38),
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            child: Text(
              controller.userOutput,
              style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold, color: themeController.isDark ? Colors.white : Colors.black, fontSize: 60),
            ),
          ),
        ],
      ),
    );
  }

  /// Check if the input is an operator
  bool isOperator(String input) {
    return ["%", "/", "x", "-", "+", "="].contains(input);
  }
}