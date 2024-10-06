import 'dart:convert';

import 'package:eat_it/utils/relative_font_size.dart';
import 'package:eat_it/widgets/shared/rounded_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

class LeaderboardElem extends StatelessWidget {
  final int? position;
  final Image? image;
  final String? name;
  final int? points;
  final String? photo;

  const LeaderboardElem({
    super.key,
    this.position,
    this.image,
    this.points,
    this.name,
    this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      height: 72.fontSize,
      color: Colors.white,
      borerRadius: 15,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
        child: LayoutGrid(
          columnSizes: [30.fontSize.px, auto, auto, 1.fr, auto, 1.fr],
          rowSizes: const [auto],
          columnGap: 4,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                position.toString(),
                style: TextStyle(
                  fontSize: 14.fontSize,
                  color: const Color(0xFF4E4E4E),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 48.fontSize,
                height: 48.fontSize,
                child: Container(
                  child: photo != null
                      ? CircleAvatar(
                          backgroundImage:
                              MemoryImage(base64Decode(photo ?? '')),
                        )
                      : const CircleAvatar(backgroundColor: Colors.grey),
                ),
              ),
            ),
            SizedBox(width: 12.fontSize),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.fontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '$points pts',
                maxLines: 1,
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    overflow: TextOverflow.ellipsis,
                    color: const Color(0xFF196500),
                    fontSize: 14.fontSize),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
