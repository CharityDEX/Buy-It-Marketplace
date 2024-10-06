import 'package:flutter/material.dart';
import 'stripe_page_resolver.dart'
    if (dart.library.html) 'stripe_page_resolver_web.dart'
    if (dart.library.io) 'stripe_page_resolver_mobiel.dart';

class StripePaymentPage extends StatelessWidget {
  final String address;

  const StripePaymentPage({required this.address, super.key});

  @override
  Widget build(BuildContext context) {
    return resolveStripePage(address);
  }
}
