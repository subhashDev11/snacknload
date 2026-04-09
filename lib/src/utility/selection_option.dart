import 'package:flutter/widgets.dart';

class SelectionOption<T> {
  final String label;
  final T value;
  final IconData? icon;
  final bool isDestructive;

  const SelectionOption({
    required this.label,
    required this.value,
    this.icon,
    this.isDestructive = false,
  });
}
