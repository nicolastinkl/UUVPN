import 'package:flutter/material.dart';
import 'package:sail/constant/app_colors.dart';

class ProgressView extends StatelessWidget {
  const ProgressView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(
          color: AppColors.yellowColor,
        ),
      ),
    );
  }
}
