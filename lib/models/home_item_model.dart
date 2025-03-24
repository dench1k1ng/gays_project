import 'package:flutter/material.dart';
import 'category_model.dart';
import 'sound_button.dart';

/// Абстрактный класс для элементов домашнего экрана
abstract class HomeItem {}

/// Категория (от сервера)
class CategoryItem extends HomeItem {
  final Category category;
  CategoryItem(this.category);
}

/// Кастомная карточка со звуком (вручную)
class CustomCardItem extends HomeItem {
  final String title;
  final String imagePath;
  final SoundButton? linkedSound;
  final VoidCallback? onTap;
  final Color? color;

  CustomCardItem({
    required this.title,
    required this.imagePath,
    this.linkedSound,
    this.onTap,
    this.color,
  });
}
