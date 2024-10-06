The "main.dart" file redirects the user to the "CheckoutPage" as the initial page when someone launches the app.

The "CheckoutPage" has a  text button which when pressed will execute the "stripePaymentCheckout" function in the "stripe_service.dart" file.

The "stripePaymentCheckout" function requires some parameters related to the products to create the Stripe hosted Checkout Page.
So, some test product parameters are also passed when the button is pressed.

The "stripe_service.dart" handles the backend of the Stripe Checkout integration.

The code imports necessary libraries for handling JSON encoding/decoding (dart:convert), making HTTP requests (http), and integrating with Stripe Checkout (stripe_checkout).
The dart:async library is imported for working with asynchronous programming.

A class named StripeService is defined to encapsulate the Stripe integration functionality.

The Static function "createCheckoutSession" is used to create a checkout session on the server side by making a POST request to the Stripe API endpoint.

It takes a list of productItems and totalAmount as parameters.

It constructs a URL (url) for the Stripe Checkout session creation API endpoint.

It iterates through productItems and builds a query string (lineItems) containing information about each product (name, unit amount, currency, quantity).

The HTTP POST request is then made to the Stripe API with the constructed body, headers, and URL.

The response is processed, and the checkout session ID is extracted from the JSON response.

The checkout session ID is returned.

The stripePaymentCheckout function is the entry point for initiating a Stripe Checkout payment.

It calls the "createCheckoutSession" method to get the session ID.

It then uses the "redirectToCheckout" method from the stripe_checkout library to open the Stripe Checkout modal.

The method returns a Future that resolves to a result based on the user's interaction with the Stripe Checkout modal (redirected, success, canceled, or error).

Callback functions (onRedirected, onSuccess, onCancel, onError) can be provided to handle different scenarios.

Now the following code is working fine for mobile applications but as a Web App although the payments are being completed by the user the function "stripePaymentCheckout"
doesn't wait for the user to complete the transaction and it is being terminated prematurely. Thus, it only executes the "onRedirected" callback and prints "finished"
instead of waiting for the user to either complete or cancel the transaction. Therefore, we are unable to execute our "onSuccess" or "onCancel" callback functions Do note that this
is an issue only in the Web App as for mobile it does execute the "onSuccess" or the "onCancel" callback functions based on the status of the transaction before printing
"finished" and terminating the function.
