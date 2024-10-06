import 'dart:async';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:eatit/pages/home_page.dart';
import 'package:eatit/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

Widget resolveStripePage(String address, Map<String, int> orderQuantities) =>
    _WebStripePaymentPage(address, orderQuantities);

class _WebStripePaymentPage extends StatefulWidget {
  final String address;
  final Map<String, int> orderQuantities;

  const _WebStripePaymentPage(this.address, this.orderQuantities);

  @override
  State<_WebStripePaymentPage> createState() => _WebStripePaymentPageState();
}

class _WebStripePaymentPageState extends State<_WebStripePaymentPage> {
  StreamSubscription? _tabEventSubs;

  Future<void> _load() async {
    try {
      final bool isMobile = MediaQuery.of(context).size.width < 600;
      final newTab = isMobile ? null : html.window.open('', '_blank');

      final result = await FirebaseFunctions.instance
          .httpsCallable("createStripeCheckoutSession")
          .call({"host": Uri.base.origin, "address": widget.address, "orderQuantities": widget.orderQuantities});
      final url = result.data['url'];

      if (isMobile) {
        html.window.location.href = url;
      } else {
        newTab?.location.href = url;
      }

      _tabEventSubs?.cancel();
      _tabEventSubs = html.window.onMessage.listen((event) {
        final data = event.data.toString();
        _onReceiveData(data);
      });
    } catch (_) {
      _showGeneralErrorSnackBar();
    }
  }

  void _onReceiveData(String data) {
    Navigator.of(context).pop();
    nextScreenReplace(context, const HomePage());
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _tabEventSubs?.cancel();
    super.dispose();
  }

  void _showGeneralErrorSnackBar() {
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger.showSnackBar(
        const SnackBar(content: Text('Oops. Something went wrong')));
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black.withOpacity(0.8),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
