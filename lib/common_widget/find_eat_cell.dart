// lib/common_widget/find_eat_cell.dart

import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class FindEatCell extends StatelessWidget {
  final Map<String, dynamic> fObj;
  final int index;

  const FindEatCell({super.key, required this.index, required this.fObj});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final bool isEven = index.isEven;

    return Container(
      margin: const EdgeInsets.all(8),
      width: media.width * 0.5,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isEven
              ? [
                  TColor.primaryColor2.withValues(alpha: 0.5),
                  TColor.primaryColor1.withValues(alpha: 0.5),
                ]
              : [
                  TColor.secondaryColor2.withValues(alpha: 0.5),
                  TColor.secondaryColor1.withValues(alpha: 0.5),
                ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(75),
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar di kanan atas
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                (fObj['image'] ?? '').toString(),
                width: media.width * 0.3,
                height: media.width * 0.25,
                fit: BoxFit.contain,
              ),
            ],
          ),

          // Nama
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              (fObj['name'] ?? '').toString(),
              style: TextStyle(
                color: TColor.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Jumlah item
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              (fObj['number'] ?? '').toString(),
              style: TextStyle(color: TColor.gray, fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(height: 15),

          // Tombol
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SizedBox(
              width: 90,
              height: 25,
              child: RoundButton(
                fontSize: 12,
                type: isEven
                    ? RoundButtonType.bgGradient
                    : RoundButtonType.bgSGradient,
                title: 'Select',
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
