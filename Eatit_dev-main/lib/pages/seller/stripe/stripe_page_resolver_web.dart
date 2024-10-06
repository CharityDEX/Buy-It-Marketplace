import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:html' as html;

Widget resolveStripePage(String address) =>
    _WebStripePaymentPage(address);

class _WebStripePaymentPage extends StatefulWidget {
  final String urlLink;

  const _WebStripePaymentPage(this.urlLink);

  @override
  State<_WebStripePaymentPage> createState() => _WebStripePaymentPageState();
}

class _WebStripePaymentPageState extends State<_WebStripePaymentPage> {
  StreamSubscription? _tabEventSubs;

  void _load()  {
    print('Trying to open');
    html.window.open(widget.urlLink, "new tab");

    _tabEventSubs?.cancel();
    _tabEventSubs = html.window.onMessage.listen((event) {
      final data = event.data.toString();
      _onReceiveData(data);
    });
  }

  void _onReceiveData (String data) {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _load();
    });
  }

  @override
  void dispose() {
    _tabEventSubs?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black.withOpacity(0.8),
      child: const Center(child: CircularProgressIndicator(
        color: Colors.green,
      )),
    );
  }
}
