import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:eatit_dev/pages/search_page.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

class DatabaseService{
  final String? uid;
    DatabaseService({this.uid});

    final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
    final CollectionReference sellerCollection = FirebaseFirestore.instance.collection("sellers");
    final CollectionReference productCollection = FirebaseFirestore.instance.collection("products");
    final CollectionReference orderCollection = FirebaseFirestore.instance.collection("orders");
    final CollectionReference payoutCollection = FirebaseFirestore.instance.collection("payouts");
    final CollectionReference ticketCollection = FirebaseFirestore.instance.collection("tickets");
    final CollectionReference reportCollection = FirebaseFirestore.instance.collection("reports");
    final CollectionReference addressCollection = FirebaseFirestore.instance.collection("addresses");
    final CollectionReference ethyCollection = FirebaseFirestore.instance.collection("ethy");
    final CollectionReference deleteSellersCollection = FirebaseFirestore.instance.collection("dellers");
    
    //Saving the user data
    Future savingUserData(String userName, String email)async{
      return await userCollection.doc(uid).set({
        "userName": userName,
        "email": email,
        "profilePic": "",
        "uid": uid,
        "day": 0,
        "month": 0,
        "year": 0,
        "gender": "",
        "interests": [],
        "sid": "",
        "address": "",
        "etsyBadge": "",
        "etsyVerified": false,
        "dateCreated": DateTime.now(),
    });
    }

    Future gettingUserData(String email) async{
      QuerySnapshot snapshot = await userCollection.where("email", isEqualTo: email).get();
      return snapshot;
    }

    late Rx<File?> _pickedImage;
  
  //Function to access gallery and pick an image
  Future<void> pickImageGallery()async{
  final PickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
  if(PickedImage!=null){
  }
  _pickedImage = Rx<File?>(File(PickedImage!.path));
  String downloadUrl = await _uploadToStorage(_pickedImage.value!);
  updateProfiePic(downloadUrl);
}

Future<void> pickImageCamera()async{
  final PickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
  if(PickedImage!=null){
  }
  _pickedImage = Rx<File?>(File(PickedImage!.path));
  String downloadUrl = await _uploadToStorage(_pickedImage.value!);
  updateProfiePic(downloadUrl);
}

// Function to upload the picked image to Storage
Future<String> _uploadToStorage(File image) async{
     Reference ref = FirebaseStorage.instance.ref().child('profilePic').child(FirebaseAuth.instance.currentUser!.uid);
     UploadTask uploadTask = ref.putFile(image);
     TaskSnapshot snap = await uploadTask;
     String downloadUrl = await snap.ref.getDownloadURL();
     return downloadUrl;
    }

Future<void> uploadToStorageWeb(Uint8List image) async {
  Reference ref = FirebaseStorage.instance.ref().child('profilePic').child(FirebaseAuth.instance.currentUser!.uid);
  UploadTask uploadTask = ref.putData(image);
  TaskSnapshot snap = await uploadTask;
  String downloadUrl = await snap.ref.getDownloadURL();
  updateProfiePic(downloadUrl);
}

Future<void> uploadEtsyBadgeToStorageWeb(Uint8List image) async {
  Reference ref = FirebaseStorage.instance.ref().child('EtsyBadge').child(FirebaseAuth.instance.currentUser!.uid);
  UploadTask uploadTask = ref.putData(image);
  TaskSnapshot snap = await uploadTask;
  String downloadUrl = await snap.ref.getDownloadURL();
  updateEtsyBadge(downloadUrl);
}

    //Function to update the profile photo
    Future updateProfiePic(String downloadUrl)async{
      DocumentReference userDocumentReference = userCollection.doc(uid);
      await userDocumentReference.update({
          "profilePic": downloadUrl,
        });
    }

  Future updateEtsyBadge(String downloadUrl)async{
      String ethyBadgeID = const Uuid().v1();
      DocumentReference userDocumentReference = userCollection.doc(uid);
      await userDocumentReference.update({
           "etsyBadge": downloadUrl,
          "etsyVerified": false,
      });
      return await ethyCollection.doc(ethyBadgeID).set({
        "ethyBadgeID": ethyBadgeID,
        "uid": uid,
        "badgeURL": downloadUrl,
        "isVerified": false,
        "dateUploaded": DateTime.now(),
      });
    }

    //Function to get the profile photo URL to display
    Future<String> getProfilePicUrl()async{
      DocumentReference userDocumentReference = userCollection.doc(uid);
      DocumentSnapshot documentSnapshot = await userDocumentReference.get();
      return documentSnapshot['profilePic'];
    }

    Future<String> getSid()async{
      DocumentReference sellerDocumentReference = sellerCollection.doc(uid);
      DocumentSnapshot documentSnapshot = await sellerDocumentReference.get();
      return documentSnapshot['sid'];
    }

    //Saving the seller data
    Future savingSellerData(String sellerName, String sellerMobileNo, String sellerBankAccNo, String sellerAddress, String bio)async{
      String sid = const Uuid().v1();
      final documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      String userName = documentSnapshot['userName'];
      String email = documentSnapshot['email'];
      await updateSID(sid);
      return await sellerCollection.doc(sid).set({
        "sellerName": sellerName,
        "userName": userName,
        "email": email,
        "sellerMobileNo": sellerMobileNo,
        "sellerBankAccNo": sellerBankAccNo,
        "sellerAddress": sellerAddress,
        "bio": bio,
        "sid": sid,
        "uid": uid,
        "deletion": false,
        "sellerRevenue": 0.0,
        "lifetimeRevenue": 0.0,
        "sellerItemsSold": 0,
        "dateSellerCreated": DateTime.now(),
    });
    }

    Future updateSID(String sid)async{
      DocumentReference userDocumentReference = userCollection.doc(uid);
      await userDocumentReference.update({
          "sid": sid,
        });
    }

  Future<String> pickProductImageGallery(String userName, String uid, String title)async{
    final PickedImage = await ImagePicker().pickImage(source: ImageSource.gallery,);
    if(PickedImage!=null){
    }
    _pickedImage = Rx<File?>(File(PickedImage!.path));
    return PickedImage.path;
}

Future<String> pickProductImageCamera(String userName, String uid, String title) async{
  final PickedImage = await ImagePicker().pickImage(source: ImageSource.camera,);
  if(PickedImage!=null){
  }
  _pickedImage = Rx<File?>(File(PickedImage!.path));
  return PickedImage.path;
}

     void uploadProductToStorage(File image, String userName, String uid, String title, String description, String email, double price, int quantity, String productType, String cities, double discountedPrice, bool isDiscounted, bool ethyStatus) async{
     String pid = const Uuid().v6();
     final documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
     String sid = documentSnapshot['sid'];
     Reference ref = FirebaseStorage.instance.ref().child('products').child(pid);
     UploadTask uploadTask = ref.putFile(image);
     TaskSnapshot snap = await uploadTask;
     String productUrl = await snap.ref.getDownloadURL();
     saveProduct(productUrl, userName, email, uid, title, description, pid, sid, price, quantity, productType, cities, discountedPrice, isDiscounted, ethyStatus);
    }

  Future<void> uploadProductToStorageWeb(Uint8List image, String userName, String uid, String title, String description, String email, double price, int quantity, String productType, String cities, double discountedPrice, bool isDiscounted, bool ethyStatus) async {
  String pid = const Uuid().v6();
  final documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
  String sid = documentSnapshot['sid'];
  final Reference ref = FirebaseStorage.instance.ref().child('products').child(pid);
  final UploadTask uploadTask = ref.putData(image);
  final TaskSnapshot snap = await uploadTask;
  if (snap.state == TaskState.success) {
    final String productUrl = await snap.ref.getDownloadURL();
    await saveProduct(productUrl, userName, email, uid, title, description, pid, sid, price, quantity, productType, cities, discountedPrice, isDiscounted, ethyStatus);
  }
}

    Future saveProduct(String productUrl, String userName, String email, String uid, String title, String description, String pid, String sid, double price, int quantity, String productType, String cities, double discountedPrice, bool isDiscounted, bool ethyStatus) async{
      double discount = 0.0;
      if(isDiscounted==true)
      {
        discount = (discountedPrice/price)*100;
      }
      return await productCollection.doc(pid).set({
        "userName": userName,
        "email": email,
        "uid": uid,
        "pid": pid,
        "sid": sid,
        "cities": cities,
        "isDiscounted": isDiscounted,
        "discountedPerice": discountedPrice,
        "discount": discount,
        "productUrl": productUrl,
        "title": title,
        "ethyStatus": ethyStatus,
        "productType": productType,
        "description": description,
        "price": price,
        "quantity": quantity,
        "isAvailable": true,
        "likes": [],
        "dislikes": [],
        "cart": [],
        "datePosted": DateTime.now(),
    });
    }

    Future<void> likeProduct(String pid, List likes)async{
        if(likes.contains(uid)){
          await productCollection.doc(pid).update({
            'likes': FieldValue.arrayRemove([uid]),
          });
        }
        else{
          await productCollection.doc(pid).update({
            'likes': FieldValue.arrayUnion([uid]), 
            'dislikes': FieldValue.arrayRemove([uid]),
          });
        }
    }

    Future<void> dislikeProduct(String pid, List dislikes)async{
        if(dislikes.contains(uid)){
          await productCollection.doc(pid).update({
            'dislikes': FieldValue.arrayRemove([uid]),
          });
        }
        else{
          await productCollection.doc(pid).update({
            'dislikes': FieldValue.arrayUnion([uid]), 
            'likes': FieldValue.arrayRemove([uid]),
          });
        }
    }

    Future<void> addCart(String pid, List cart)async{
        if(cart.contains(uid)){
          await productCollection.doc(pid).update({
            'cart': FieldValue.arrayRemove([uid]),
          });
        }
        else{
          await productCollection.doc(pid).update({
            'cart': FieldValue.arrayUnion([uid]),
          });
        }
    }

    Future<void> buyProducts(String pid, String address, num price, String sid, int quantity, int orderQuantity)async{
      String oid = const Uuid().v8();
      int newQuantity = quantity - orderQuantity;
      await userCollection.doc(uid).update({
        'address': address
      });
      if(newQuantity < 1){
        await productCollection.doc(pid).update({
        'isAvailable': false,
      });
      }
      await productCollection.doc(pid).update({
        'quantity': FieldValue.increment(-orderQuantity)
      });
      savingOrderData(uid!, sid, pid, oid, address, price, orderQuantity);
    }

    Future savingOrderData(String uid, String sid, String pid, String oid, String address, num price, int orderQuantity)async{
      return await orderCollection.doc(oid).set({
        "oid": oid,
        "sid": sid,
        "pid": pid,
        "uid": uid,
        "address": address,
        "price": price,
        "orderQuantity": orderQuantity,
        "isUserCompleted": false,
        "isSellerCompleted": false,
        "isCompleted": false,
        "dateOrdered": DateTime.now(),
        "dateCompleted": DateTime.now(),
    });
    }

    Future<void> removeProduct(String pid)async{
        await productCollection.doc(pid).update({
            'isAvailable': false,
          });
    }

    Future<void> orderCompleted(String oid)async{
      final documentSnapshot = await FirebaseFirestore.instance.collection('orders').doc(oid).get();
      final prodDocumentSnapshot = await FirebaseFirestore.instance.collection('products').doc(documentSnapshot['pid']).get();
      String sid = documentSnapshot['sid'];
      num price = documentSnapshot['price'];
      int quantity = documentSnapshot['orderQuantity'];
      bool isDiscounted = prodDocumentSnapshot['isDiscounted'];
      num discountedPerice = prodDocumentSnapshot['discountedPerice'];
        await orderCollection.doc(oid).update({
            'isCompleted': true,
            'dateCompleted': DateTime.now(),
          });
          isDiscounted?
          await sellerCollection.doc(sid).update({
          'sellerRevenue': FieldValue.increment(double.parse((quantity * (discountedPerice - (0.05 * discountedPerice))).toStringAsFixed(2))),
          'lifetimeRevenue': FieldValue.increment(double.parse((quantity * (discountedPerice - (0.05 * discountedPerice))).toStringAsFixed(2))),
          'sellerItemsSold': FieldValue.increment(quantity)
        }):

        await sellerCollection.doc(sid).update({
          'sellerRevenue': FieldValue.increment(double.parse((quantity * (price - (0.05 * price))).toStringAsFixed(2))),
          'lifetimeRevenue': FieldValue.increment(double.parse((quantity * (price - (0.05 * price))).toStringAsFixed(2))),
          'sellerItemsSold': FieldValue.increment(quantity)
        });

    }

    Future<void> userOrderCompleted(String oid)async{
        await orderCollection.doc(oid).update({
          'isUserCompleted': true,
          });
    }

    Future<void> sellerOrderCompleted(String oid)async{
        await orderCollection.doc(oid).update({
            'isSellerCompleted': true,
          });
    }

    //Search
    searchByTitle(String title, String _selectedProductType, SortOptions sortOption, bool ethyApproved) async {
  Query query = productCollection
      .where("title", isEqualTo: title)
      .where('isAvailable', isEqualTo: true)
      .where('productType', isEqualTo: _selectedProductType);
  
  if (ethyApproved) {
    query = query.where('ethyStatus', isEqualTo: true);
  }

  switch (sortOption) {
    case SortOptions.LowToHigh:
      query = query.orderBy("price");
      break;
    case SortOptions.HighToLow:
      query = query.orderBy("price", descending: true);
      break;
    case SortOptions.Latest:
      break;
  }

  QuerySnapshot querySnapshot = await query.get();
  return querySnapshot;
}

    
    Future<void> postReview(String pid, String text, String uid, String userName, String profilePic) async{
        String rid = const Uuid().v1();
        await productCollection.doc(pid).collection('reviews').doc(rid).set({
          'profilePic': profilePic,
          'userName': userName,
          'uid': uid,
          'text': text,
          'rid': rid,
          'datePublished': DateTime.now(),
        });
    }

    Future<void> postChat(String oid, String text, String uid, String userName, String profilePic) async{
        String cid = const Uuid().v1();
        await orderCollection.doc(oid).collection('chats').doc(cid).set({
          'profilePic': profilePic,
          'userName': userName,
          'uid': uid,
          'text': text,
          'cid': cid,
          'datePublished': DateTime.now(),
        });
    }

    Future initiatePayout(double amount, String withdrawMethod, int mobileNo)async{
      String payoutID = const Uuid().v1();
      final documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      String sid = documentSnapshot['sid'];
      String userName = documentSnapshot['userName'];
      String email = documentSnapshot['email'];
      await sellerCollection.doc(sid).update({
        'sellerRevenue': 0.0,
      });
      return await payoutCollection.doc(payoutID).set({
        "payoutID": payoutID,
        "userName": userName,
        "email": email,
        "mobileNo": mobileNo,
        "amount": amount,
        "sid": sid,
        "uid": uid,
        "withdrawMethod": withdrawMethod,
        "datePayoutCreated": DateTime.now(),
        "datePayoutCompleted": DateTime.now(),
        "isPayoutCompleted": false,
    });
    }

Future createSupportTicket(String uid, String userName, String email, String subject, String description, XFile? image) async {
  String ticketID = const Uuid().v1();
  String? imageUrl;

  if (image != null) {
    final storageRef = FirebaseStorage.instance.ref().child('support_tickets/$ticketID.png');
    if (kIsWeb) {
      await storageRef.putData(await image.readAsBytes());
    } else {
      await storageRef.putFile(File(image.path));
    }
    imageUrl = await storageRef.getDownloadURL();
  }

  return await ticketCollection.doc(ticketID).set({
    "ticketID": ticketID,
    "userName": userName,
    "email": email,
    "uid": uid,
    "subject": subject,
    "description": description,
    "imageUrl": imageUrl,
    "dateTicketCreated": DateTime.now(),
    "isTicketCompleted": false,
  });
}



    Future<void> updateSellerData(String sid, String userName, String sellerAddress, String sellerMobileNo, String bio)async{
        await sellerCollection.doc(sid).update({
            "userName": userName,
            "sellerAddress": sellerAddress,
            "sellerMobileNo": sellerMobileNo,
            "bio": bio,
          });
          await userCollection.doc(uid).update({
            "userName": userName,
          });
    }

    Future createReport(String userName, String title, String description, String price, String pid, String productUrl, String sid, String reason)async{
      return await reportCollection.doc(pid).set({
        "pid": pid,
        "userName": userName,
        "title": title,
        "price": price,
        "description": description,
        "productUrl": productUrl,
        "reason": reason,
        "dateReportCreated": DateTime.now(),
        "isReportChecked": false,
    });
    }

    Future<void> updateUserData(String uid, String userName, int day, int month, int year, String gender, List interests) async{
          await userCollection.doc(uid).update({
            "userName": userName,
            "gender": gender,
            "day": day,
            "month": month,
            "year": year,
            "interests": interests,
          });
    }

    Future createAddress(String uid, String country, String city, String street, String postalCode, String addressOther)async{
      return await addressCollection.doc(uid).set({
        "uid": uid,
        "country": country,
        "city": city,
        "street": street,
        "postalCode": postalCode,
        "addressOther": addressOther,
        "dateAddressCreated": DateTime.now(),
    });
    }

    Future<void> rateProduct(String pid, double rating) async {
    final ratingDoc = productCollection.doc(pid).collection('ratings').doc(uid);
    final ratingSnapshot = await ratingDoc.get();

    if (ratingSnapshot.exists) {
      await ratingDoc.update({'rating': rating});
    } else {
      await ratingDoc.set({'rating': rating});
    }
  }

  Future<void> removeRating(String pid) async {
    final ratingDoc = productCollection.doc(pid).collection('ratings').doc(uid);
    await ratingDoc.delete();
  }

   Future<void> deleteUser(String password) async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Delete the user from the Firestore collection
        await userCollection.doc(user.uid).delete();

        // Reauthenticate the user if necessary
        try {
          await user.reauthenticateWithCredential(
            EmailAuthProvider.credential(email: user.email!, password: password),
          );
        } catch (e) {
          if (kDebugMode) {
            print('Reauthentication failed: ${e.toString()}');
          }
          return;
        }

        // Delete the user from Firebase Authentication
        await user.delete();
      }
    } catch (err) {
      if (kDebugMode) {
        print(err.toString());
      }
    }
  }

  Future<void> deleteSeller(String sid) async{
    await sellerCollection.doc(sid).update({
            "deletion": true,
          });
    return await deleteSellersCollection.doc(sid).set({
      'sid': sid,
      'dateDeleteInitiated': DateTime.now(),
    });
  }
}
