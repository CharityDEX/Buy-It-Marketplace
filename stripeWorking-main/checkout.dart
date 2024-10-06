import 'package:flutter/material.dart';
import 'package:test_stripe/stripe_service.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.grey.shade200,
        title: Text("buy products", style: TextStyle(color: Colors.green.shade900, fontSize: 27,),),
      ),
      body: Center(
        child: TextButton(
          onPressed: () async{
            var items = [
              {
                "productPrice": 4,
                "productName": "Test Product 1",
                "qty": 10,
              },
              {
                "productPrice": 5,
                "productName": "Test Product 2",
                "qty": 15,
              },
              {
                "productPrice": 3,
                "productName": "Test Product 3",
                "qty": 17,
              },
            ];
            await StripeService.stripePaymentCheckout(items, 500, context, mounted,
            onRedirected: (){
              print("Redirected");
            },
             onSuccess: (){
              print("Success");
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CheckoutPage()));
            },
            onCancel: (){
              print("Cancel");
            },
            onError: (e){
              print("Error: +${e.toString()}");
            },
            );
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(1))),
          ),
          child: const Text("Checkout"),
        ),
      ),
    );
  }
}