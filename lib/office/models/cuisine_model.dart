import 'package:flutter/material.dart';

class Cuisine {
  int? id;
  String name;
  int price;
  String description;
  String image;
  List<CuisineOptionCategory> optionCategories;

  Cuisine(
      {this.id,
      required this.name,
      required this.price,
      required this.description,
      required this.image,
      this.optionCategories = const []});
}

class CuisineCategory {
  String name;
  String description;
  List<Cuisine> cuisines;
  CuisineCategory({required this.name, required this.cuisines, required this.description});

  CuisineCategory copyWith({
    String? name,
    String? description,
    List<Cuisine>? cuisines,
  }) {
    return CuisineCategory(
      name: name ?? this.name,
      description: description ?? this.description,
      cuisines: cuisines ?? this.cuisines,
    );
  }
}

class Nutrition {
  int? calories;
  int? protein;
  int? fat;
  int? carbohydrate;

  int? glucose;
  int? sodium;
  int? saturatedFat;

  Nutrition({
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbohydrate,
    required this.glucose,
    required this.sodium,
    required this.saturatedFat,
  });
}

class CuisineOptionCategory {
  int? id;
  List<CuisineOption> options;
  bool isEssential;
  String name;
  int minimumSelection;
  int maximumSelection;

  CuisineOptionCategory(
      {this.id,
      required this.name,
      this.options = const [],
      this.isEssential = false,
      this.minimumSelection = 0,
      this.maximumSelection = 0});

  CuisineOptionCategory copyWith({
    int? id,
    List<CuisineOption>? options,
    String? name,
    bool? isEssential,
    int? minimumSelection,
    int? maximumSelection,
  }) {
    return CuisineOptionCategory(
      id: id ?? this.id,
      options: options ?? this.options,
      name: name ?? this.name,
      isEssential: isEssential ?? this.isEssential,
      minimumSelection: minimumSelection ?? this.minimumSelection,
      maximumSelection: maximumSelection ?? this.maximumSelection,
    );
  }
}

class CuisineOption {
  String? name;
  int? price;

  CuisineOption({this.name, this.price});

  CuisineOption copyWith({
    String? name,
    int? price,
  }) {
    return CuisineOption(
      name: name ?? this.name,
      price: price ?? this.price,
    );
  }
}
