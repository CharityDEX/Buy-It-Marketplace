import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stripe_checkout/stripe_checkout.dart';
import 'dart:async';

class StripeService{
  static String secretKey = "STRIPE_SECRET_KEY";
  static String publishableKey = "STRIPE_PUBLISHABLE_KEY";

static Future<dynamic> createCheckoutSession(
  List<dynamic> productItems,
  totalAmount,
) async{
  final url = Uri.parse("https://api.stripe.com/v1/checkout/sessions");

  String lineItems = "";
  int index = 0;

  productItems.forEach((val) { 
    var productPrice = (val["productPrice"] * 100).round().toString();
    lineItems += "&line_items[$index][price_data][product_data][name]=${val['productName']}&line_items[$index][price_data][unit_amount]=$productPrice&line_items[$index][price_data][currency]=EUR&line_items[$index][quantity]=${val['qty'].toString()}";
    index++;
  },);
  final response = await http.post(url,
  body: 'success_url=https://checkout.stripe.dev/success&mode=payment$lineItems',
  headers: {
    'Authorization': 'Bearer $secretKey',
    'Content-Type': 'application/x-www-form-urlencoded',
  },
);
  //print(response.body);
  return json.decode(response.body)["id"];
}

static Future<dynamic> stripePaymentCheckout(
  productItems,
  subTotal,
  context,
  mounted,
  {
    onRedirected,
    onSuccess,
    onCancel,
    onError,
  }
) async{
  final String sessionId = await createCheckoutSession(productItems, subTotal);
  final result = await redirectToCheckout(context: context, sessionId: sessionId, publishableKey: publishableKey, successUrl:"https://checkout.stripe.dev/success", canceledUrl: "https://checkout.stripe.dev/cancel");
  if(mounted){
    final text = result.when(redirected: () => onRedirected(), success: () => onSuccess(), canceled: () => onCancel(), error: (e)=> onError());
    print("finished");
    return text;
  }
}


}
