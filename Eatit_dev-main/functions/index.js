const functions = require("firebase-functions");
const logger = require("firebase-functions/logger");

const secretKey = "sk_test_51ON8jKBdYxXKd2igdWXMKhR19H5G1Er5ykshAIoohQZFQnbi6E8zUEGTKbzvbxRFL93Qoo3Q7i1XyFXmkJjK2s9J00BxTt3HIY";
const stripeWebhookSecret = "whsec_rwicQ5CDk924O5pfKCpuqZmidNyfMfal";

const uuid = require("uuid");

const stripe = require("stripe")(secretKey);
const {initializeApp} = require("firebase-admin/app");
const {
  getFirestore,
  FieldValue,
  Timestamp,
} = require("firebase-admin/firestore");

initializeApp();

exports.withdrawSellerBalance = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("failed-precondition", "The function must be called " +
      "while authenticated.");
  }

  const uid = context.auth.uid;
  logger.debug(`uid: ${uid}`);

  const host = data.host;
  const sellerSnapshot = await getFirestore().collection("sellers")
    .where("uid", "==", uid)
    .get()

  if (sellerSnapshot.docs.length === 0) {
    throw  new functions.https.HttpsError("invalid-argument", "Could not find your info");
  }

  const sellerInfo = sellerSnapshot.docs[0].data();
  if (!sellerInfo || sellerInfo.sellerRevenue <= 0) {
    throw  new functions.https.HttpsError("invalid-argument", "Your balance is zero");
  }

  if (!sellerInfo.stripeAccountId) {
    return {
      "type": "NO_STRIPE_ACCOUNT",
      "url": await connectStripeAccount(sellerSnapshot.docs[0].id, host)
    }
  }

  const transfer = await stripe.transfers.create({
    amount: sellerInfo.sellerRevenue * 100,
    currency: "gbp",
    destination: sellerInfo.stripeAccountId,
  });


  logger.info(transfer);
  await initiatePayout(sellerInfo.stripeAccountId, uid, sellerInfo.stripeAccountId);

  return { "status" : "ok" }
});

exports.createStripeCheckoutSession = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("failed-precondition", "The function must be called " +
      "while authenticated.");
  }

  const uid = context.auth.uid;
  const {host, address} = data;

  const snapshot = await getFirestore()
    .collection("products")
    .where("cart", "array-contains", uid)
    .where("isAvailable", "==", true).get();

  const docs = snapshot.docs;

  let lineItems = [];

  docs.forEach(function(doc) {
    let docData = doc.data();
    let lineItem = {
      price_data: {
        currency: "GBP",
        product_data: {
          name: docData.title || "Eatit Payment",
          description: docData.description,
          images: docData.productUrl ? [docData.productUrl] : [],
          metadata: {
            "product_fb_id": doc.id,
            "product_fb_pid": doc.id,
            "product_fb_sid": docData.sid,
            "product_fb_quantity": docData.quantity,
          },
        },
        unit_amount: docData.price * 100,
      },
      quantity: 1,
    };

    lineItems.push(lineItem);
  });


  const session = await stripe.checkout.sessions.create({
    client_reference_id: uid,
    metadata: {address},
    line_items: lineItems,
    mode: "payment",
    success_url: `${host}/stripe_callback.html?success=true`,
    cancel_url: `${host}/stripe_callback.html?success=false`,
  });

  logger.info(session);

  return {"url": session.url};
});

exports.stripeWebhook = functions.https.onRequest(async (request, response) => {
  let sig = request.headers["stripe-signature"];

  logger.info(sig);

  try {
    let event = stripe.webhooks.constructEvent(request.rawBody, sig, stripeWebhookSecret);


    logger.info(event);
    logger.info(event.type);

    if (event.type === "checkout.session.completed") {
      response.status(200).json({});

      let uid = event.data.object.client_reference_id;
      let address = event.data.object.metadata.address;

      const lineItemsResponse = await stripe.checkout.sessions.listLineItems(event.data.object.id, {
        expand: ["data.price.product"],
      });

      logger.info(lineItemsResponse.data);

      for (let i = 0; i < lineItemsResponse.data.length; i++) {
        logger.info(i);
        let item = lineItemsResponse.data[i];
        logger.info(item);
        let metadata = item.price.product.metadata;
        let price = Math.round(item.amount_total / 100);

        await buyProducts(uid, metadata.product_fb_pid, address, price, metadata.product_fb_sid, metadata.product_fb_quantity);
        await getFirestore().collection("products").doc(metadata.product_fb_pid).update({
          "cart": FieldValue.arrayRemove(uid),
        });
      }
    }
  } catch (err) {
    logger.error(err);
    response.status(400).end();
  }
});

connectStripeAccount = async (sid, host) => {
  logger.debug("We are creating stripe account");

  const account = await stripe.accounts.create({
    country: "GB",
    type: "standard",
  });

  const accountLink = await stripe.accountLinks.create({
    account: account.id,
    success_url: `${host}/stripe_callback.html?success=true`,
    refresh_url: `${host}/stripe_callback.html?success=false`,
    type: "account_onboarding",
  });

  await getFirestore().collection("sellers").doc(sid).update({
    stripeAccountId: account.id,
  });

  logger.debug(accountLink.url + " go and connect");
  return accountLink.url;
};


addCart = async (uid, pid, cart) => {
  const productCollection = getFirestore().collection("products");

  if (cart.contains(uid)) {
    await productCollection.doc(pid).update({
      "cart": FieldValue.arrayRemove([uid]),
    });
  } else {
    await productCollection.doc(pid).update({
      "cart": FieldValue.arrayUnion([uid]),
    });
  }
};

buyProducts = async (uid, pid, address, price, sid, quantity) => {
  let oid = uuid.v4();
  let newQuantity = quantity - 1;
  await getFirestore().collection("users").doc(uid).update({
    "address": address,
  });

  if (newQuantity < 1) {
    await getFirestore().collection("products").doc(pid).update({
      "isAvailable": false,
    });
  }

  await getFirestore().collection("products").doc(pid).update({
    "quantity": FieldValue.increment(-1),
  });

  await getFirestore().collection("orders").doc(oid).set({
    "oid": oid,
    "sid": sid,
    "pid": pid,
    "uid": uid,
    "address": address,
    "price": price,
    "isUserCompleted": false,
    "isSellerCompleted": false,
    "isCompleted": false,
    "dateOrdered": Timestamp.now(),
    "dateCompleted": Timestamp.now(),
  });
};

initiatePayout = async (amount, uid, stripeAccountId) => {
  const payoutId =  uuid.v4();
  let documentSnapshot=  await getFirestore().collection("users").doc(uid).get();
  let data = documentSnapshot.data();

  let { sid, userName, email } = data;
  await getFirestore().collection("sellers").doc(sid).update({ 'sellerRevenue': 0.0, });

  await getFirestore().collection("payouts").doc(payoutId).set({
    payoutId,
    userName,
    email,
    stripeAccountId,
    amount,
    sid,
    uid,
    datePayoutCreated:  Timestamp.now(),
    datePayoutCompleted: Timestamp.now(),
    isPayoutCompleted: true,
  });
}
