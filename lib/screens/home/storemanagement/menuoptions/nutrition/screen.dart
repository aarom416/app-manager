import 'package:flutter/material.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';

import '../model.dart';
import 'nutrition_form.dart';

class NutritionInputScreen extends StatefulWidget {
  String title;
  NutritionModel nutrition;
  int servingAmount;
  String servingAmountType;
  Function(NutritionModel, int, String, BuildContext) onConfirm;

  NutritionInputScreen({super.key, required this.title, required this.nutrition, required this.servingAmount, required this.servingAmountType, required this.onConfirm});

  @override
  State<NutritionInputScreen> createState() => _NutritionInputScreenState();
}

class _NutritionInputScreenState extends State<NutritionInputScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: widget.title),
      body: NutritionForm(nutrition: widget.nutrition, servingAmount: widget.servingAmount, servingAmountType: widget.servingAmountType, onChanged: widget.onConfirm),
    );
  }
}
