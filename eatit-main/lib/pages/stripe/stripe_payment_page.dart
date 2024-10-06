import 'package:flutter/material.dart';
import 'stripe_page_resolver.dart'
    if (dart.library.html) 'stripe_page_resolver_web.dart'
    if (dart.library.io) 'stripe_page_resolver_mobiel.dart';

class StripePaymentPage extends StatelessWidget {
  final String address;
  final Map<String, int> orderQuantities;

  const StripePaymentPage({required this.address, required this.orderQuantities, super.key});

  @override
  Widget build(BuildContext context) {
    return resolveStripePage(address, orderQuantities);
  }
}
