import 'package:flutter/material.dart';
import '../../core/constants.dart';
class CategoryFilter extends StatelessWidget {
  final String? selected;
  final ValueChanged<String?> onChanged;

  const CategoryFilter({super.key, this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selected,
      hint: const Text('Select Category'),
      items: AppConstants.categories
          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
          .toList(),
      onChanged: onChanged,
    );
  }
}
