import 'package:cloud_functions/cloud_functions.dart';
import 'package:eatit/pages/seller/seller_revenue.dart';
import 'package:flutter/material.dart';
import '../../../widgets/widgets.dart';
import 'stripe_page_resolver.dart'
    if (dart.library.html) 'stripe_page_resolver_web.dart'
    if (dart.library.io) 'stripe_page_resolver_mobile.dart';

class StripeConnectPage extends StatefulWidget {
  const StripeConnectPage({
    super.key,
  });

  @override
  State<StripeConnectPage> createState() => _StripeConnectPageState();
}

class _StripeConnectPageState extends State<StripeConnectPage> {
  String? _stripeConnectionUrl = null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _withdrawAmount());
  }

  @override
  Widget build(BuildContext context) {
    if (_stripeConnectionUrl != null)
      return resolveStripePage(
        _stripeConnectionUrl!,
      );

    return ColoredBox(
      color: Colors.black.withOpacity(0.8),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _withdrawAmount() async {
    try {
      final result = await FirebaseFunctions.instance
          .httpsCallable("withdrawSellerBalance")
          .call({"host": Uri.base.origin});

      final data = result.data;
      if (!mounted) return;

      if (data['type'] == 'NO_STRIPE_ACCOUNT') {
        _handleAccountCreation(context, data['url'].toString());
      } else {
        showSnackbar(
            context, Colors.green, "Your payout was initiated successfully.");
        nextScreenReplace(context, const SellerRevenuePage());
      }
    } on FirebaseFunctionsException catch (ex) {
      if (!mounted) return;
      showSnackbar(context, Colors.red, ex.message);
      Navigator.of(context).pop();
    }
  }

  Future<void> _handleAccountCreation(BuildContext context, String url) async {
    var shouldCreate = false;

    final result = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Connect Stripe'),
        content: const Text(
          'We need to connect your stripe account to transfer your revenue there',
        ),
        actions: [
          IconButton(
            onPressed: Navigator.of(context).pop,
            icon: const Icon(
              Icons.cancel,
              color: Colors.red,
            ),
          ),
          IconButton(
            onPressed: () {
              shouldCreate = true;
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.done,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );

    if (shouldCreate && mounted) {
      setState(() => _stripeConnectionUrl = url);
    } else if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
