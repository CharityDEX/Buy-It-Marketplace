import 'package:eat_it/utils/relative_font_size.dart';
import 'package:eat_it/widgets/shared/rounded_container.dart';
import 'package:flutter/material.dart';
import 'package:eat_it/widgets/avatar_placeholder/avatar_pllaceholder.dart';

class AvatarWithButton extends StatelessWidget {
  final Function()? onPressed;
  final Image? image;
  final Icon? btnIcon;
  final double? avatarRadius;
  final Color? btnColor;
  final Color? iconColor;
  final double? btnRadius;

  const AvatarWithButton({
    super.key,
    this.iconColor,
    this.onPressed,
    this.image,
    this.btnColor,
    this.btnIcon,
    this.avatarRadius,
    this.btnRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        image != null
            ? CircleAvatar(
                radius: (avatarRadius ?? 60).fontSize,
                child: CircleAvatar(
                  radius: (avatarRadius ?? 60).fontSize,
                  backgroundImage: image?.image,
                ),
              )
            : const AvatarPlaceholder(),
        Positioned(
          bottom: 1,
          left: MediaQuery.of(context).size.width / 2,
          child: RoundedContainer(
              borerRadius: 100,
              color: btnColor,
              child: IconButton(
                onPressed: onPressed,
                icon: btnIcon ?? const Icon(Icons.abc),
                color: iconColor,
              )),
        ),
      ],
    );
  }
}
