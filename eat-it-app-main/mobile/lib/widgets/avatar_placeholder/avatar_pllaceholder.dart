import 'package:eat_it/utils/relative_font_size.dart';
import 'package:eat_it/widgets/shared/rounded_container.dart';
import 'package:flutter/material.dart';

class AvatarPlaceholder extends StatelessWidget {
  final double? size;

  const AvatarPlaceholder({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
        color: Colors.grey,
        borerRadius: (size == null ? 60.0 : (size! / 2)).fontSize,
        width: (size ?? 120).fontSize,
        height: (size ?? 120).fontSize,
        child: const Align(
          alignment: Alignment.center,
          child: Icon(Icons.person),
        ));
  }
}
