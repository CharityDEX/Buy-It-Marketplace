import 'package:eat_it/utils/relative_font_size.dart';
import 'package:eat_it/widgets/shared/rounded_container.dart';
import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final Color? backgroundColor;
  final Color? color;
  final Widget icon;
  final String? text;
  final String? num;

  const Tile({
    super.key,
    this.backgroundColor,
    this.color,
    this.text,
    required this.icon,
    this.num,
  });

  @override
  Widget build(BuildContext context) {
    return (RoundedContainer(
      borerRadius: 20,
      color: backgroundColor,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          13.fontSize,
          20.fontSize,
          0,
          20.fontSize,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icon(icon, color: color),
                icon,
                const SizedBox(height: 10),
                Text(
                  text ?? '',
                  style: TextStyle(
                    fontSize: 12.fontSize,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  num ?? '',
                  style: TextStyle(
                    fontSize: 26.fontSize,
                    color: color,
                    fontWeight: FontWeight.w900,
                  ),
                )
              ],
            ),
            // Container(
            //   padding: const EdgeInsets.all(5),
            //   child: Icon(Icons.more_vert, color: color, size: 20),
            // ),
          ],
        ),
      ),
    ));
  }
}
