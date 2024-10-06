import 'package:eatit_dev/pages/seller/stripe/stripe_connect_page.dart';
import 'package:flutter/material.dart';
import 'package:eatit_dev/widgets/widgets.dart';

class PayoutPage extends StatefulWidget {
  final double amount;

  const PayoutPage({super.key, required this.amount});

  @override
  State<PayoutPage> createState() => _PayoutPageState();
}

class _PayoutPageState extends State<PayoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.grey.shade200,
        title: Text(
          "Payout",
          style: TextStyle(
            color: Colors.green.shade900,
            fontSize: 27,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: Text(
              "Total Amount Payable: ${widget.amount}",
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Total Amount Payable is calculated by the sum of the price of total items sold minus the 5% commission on the price of each item.",
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 20),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            child: const Text(
              "Withdraw Amount",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            onPressed: () => _askPayoutConfirmation(),
          ),
          const SizedBox(height: 10),
          const Text(
            "Amount withdrawn should reflect in the bank account of your withdraw method in 2-3 business days.",
            style: TextStyle(fontSize: 12),
          ),
          const Text("If you get an 'INTERNAL' error, please check later. It usually takes 7 days for Stripe to transfer your funds", 
                              style: TextStyle(fontSize: 14,
                              fontWeight: FontWeight.w500, color: Colors.red),),
        ],
      ),
    );
  }

  Future<void> _askPayoutConfirmation() async {
    if (widget.amount <= 0) {
      showSnackbar(
          context, Colors.red, 'You dont not have a sufficient amount');
      return;
    }

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Withdrawl"),
          content: const Text("Are you sure you want to withdraw the amount."),
          actions: [
            IconButton(
              onPressed: Navigator.of(context).pop,
              icon: const Icon(Icons.cancel, color: Colors.red),
            ),
            IconButton(
              onPressed: () async {
                Navigator.of(context).pop();

                Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const StripeConnectPage(),
                  opaque: false,
                ));
              },
              icon: const Icon(
                Icons.done,
                color: Colors.green,
              ),
            ),
          ],
        );
      },
    );
  }
}
