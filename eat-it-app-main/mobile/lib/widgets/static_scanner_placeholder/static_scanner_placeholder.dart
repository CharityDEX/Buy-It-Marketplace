import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class StaticScannerPlaceholder extends StatelessWidget {
  final bool isLoading;

  const StaticScannerPlaceholder({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.width * 0.35,
      decoration: BoxDecoration(
          color: Colors.white24,
          border: Border.all(color: Colors.white, width: 5),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: isLoading
          ? const SpinKitCircle(
              color: Colors.white,
              size: 52,
            )
          : const Icon(
              Icons.search,
              size: 36,
              color: Colors.white,
            ),
    );
  }
}
