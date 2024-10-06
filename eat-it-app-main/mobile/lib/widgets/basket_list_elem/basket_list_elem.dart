import 'package:eat_it/utils/relative_font_size.dart';
import 'package:eat_it/widgets/shared/rounded_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BasketListElem extends StatelessWidget {
  final String foodType;
  final String foodName;
  final int quality;
  final String id;
  final Function onPressed;

  const BasketListElem(
      {super.key,
      required this.foodType,
      required this.foodName,
      required this.quality,
      required this.id,
      required this.onPressed});

  Color selectQualityColor(BuildContext context, int quality) {
    var qualityMark = {
      0: const Color(0xFFEB5757),
      33: const Color(0xFFF8CF61),
      66: Theme.of(context).primaryColor
    };

    Color color = const Color(0xFFEB5757);
    qualityMark.forEach((key, value) {
      if (quality > key) {
        color = value;
      }
    });
    return color;
  }

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      height: 72.fontSize,
      color: Colors.white,
      borerRadius: 10,
      child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 12.fontSize, horizontal: 18.fontSize),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      foodType,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: const Color(0xff999999),
                          fontSize: 10.fontSize,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins'),
                    ),
                    Text(
                      foodName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: const Color(0xff000000),
                          fontSize: 12.fontSize),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.fontSize),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: selectQualityColor(context, quality),
                            width: 2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    height: 48.fontSize,
                    width: 48.fontSize,
                    child: Center(
                        child: Text(quality.toString(),
                            style: TextStyle(
                                fontSize: 12.fontSize,
                                fontWeight: FontWeight.w800,
                                color: selectQualityColor(context, quality)))),
                  ),
                  IconButton(
                      onPressed: () => {onPressed(id)},
                      icon: SvgPicture.asset('assets/basketPage/trash.svg'))
                ],
              )
            ],
          )),
    );
  }
}
