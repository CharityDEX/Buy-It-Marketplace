import 'package:flutter/material.dart';

class OnboardingMessageData {
  const OnboardingMessageData({
    required this.title,
    required this.message,
    required this.image,
  });

  final String title;
  final String message;
  final String image;
}

class OnboardingMessage extends StatelessWidget {
  const OnboardingMessage({
    Key? key,
    required this.data,
  }) : super(key: key);

  final OnboardingMessageData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          data.title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const Spacer(flex: 3),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            data.message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const Spacer(flex: 5),
        const SizedBox(height: 12),
        Expanded(flex: 25, child: Image.asset(data.image)),
      ],
    );
  }
}
