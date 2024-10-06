import 'package:flutter/material.dart';

class ModalCard extends StatelessWidget {
  final Widget child;

  const ModalCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: AlignmentDirectional.bottomCenter, children: [
      Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black54, offset: Offset(0, 4), blurRadius: 4)
          ],
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        // padding: const EdgeInsets.all(16),
        child: Container(
            padding:
                const EdgeInsets.only(top: 25, left: 16, right: 16, bottom: 16),
            child: child),
      ),
      Positioned(
        top: 12,
        child: Container(
          decoration: const BoxDecoration(
              color: Color(0xFFF1F3FB),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          width: 40,
          height: 5,
          margin: const EdgeInsets.only(bottom: 10),
        ),
      ),
    ]);
  }
}
