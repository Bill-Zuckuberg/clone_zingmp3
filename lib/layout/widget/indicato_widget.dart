import 'package:flutter/material.dart';
import 'package:clone_zingmp3/mics/colors.dart' as colors;

class Indicato extends StatelessWidget {
  final bool isActive;
  const Indicato({Key? key, required this.isActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      width: isActive ? 22.0 : 8.0,
      height: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
          color: isActive
              ? colors.AppColors.appColor
              : colors.AppColors.appUnSelectColor,
          borderRadius: BorderRadius.circular(8)),
    );
  }
}
