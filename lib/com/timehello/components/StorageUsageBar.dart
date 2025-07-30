import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StorageSection {
  final String label;
  final Color color;
  final double size;

  StorageSection(this.label, this.color, this.size);
}

class StorageUsageBar extends StatelessWidget {
  final double totalStorage;
  final double usedStorage;
  final List<StorageSection> sections;

  StorageUsageBar({
    required this.totalStorage,
    required this.usedStorage,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Macintosh HD  ${usedStorage.toStringAsFixed(2)}GB/${totalStorage.toStringAsFixed(2)}GB 已使用',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 10),
        Container(
          width: 300,
          height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.black),
          ),
          child: Stack(
            children: sections.map((section) {
              double widthFactor = section.size / totalStorage;
              return FractionallySizedBox(
                widthFactor: widthFactor,
                child: Container(
                  decoration: BoxDecoration(
                    color: section.color,
                    borderRadius: widthFactor == 1
                        ? BorderRadius.circular(5)
                        : BorderRadius.horizontal(left: Radius.circular(5)),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: sections.map((section) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    color: section.color,
                  ),
                  SizedBox(width: 4),
                  Text(section.label),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}