import 'package:cached_network_image/cached_network_image.dart';
import 'package:eatit/pages/home_page.dart';
import 'package:eatit/pages/search_page.dart';
import 'package:eatit/pages/seller/seller_invetory.dart';
import 'package:flutter/material.dart';
import 'package:eatit/helper/helper_function.dart';
import 'package:eatit/services/auth_service.dart';
import 'package:eatit/widgets/widgets.dart';
import 'package:eatit/pages/profile_page.dart';
import 'package:eatit/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eatit/pages/cart_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class EditProductPage extends StatefulWidget {
  final String title;
  final String productType;
  final String description;
  final String cities;
  final double price;
  final double discountedPerice;
  final bool isDiscounted;
  final String postPreview;
  final String pid;
  final String sid;
  final int amount;

  const EditProductPage(
      {super.key,
      required this.title,
      required this.productType,
      required this.description,
      required this.cities,
      required this.price,
      required this.discountedPerice,
      required this.isDiscounted,
      required this.postPreview,
      required this.amount,
      required this.pid,
      required this.sid});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  AuthService authService = AuthService();
  String userName = "";
  String email = "";
  bool ethyStatus = false;

  late TextEditingController titleController;
  late TextEditingController productTypeController;
  late TextEditingController descriptionController;
  late TextEditingController citiesController;
  late TextEditingController priceController;
  late TextEditingController discountedPriceController;
  late TextEditingController quantityController;

  bool isDiscounted = false;
  late String postPreview;
  Uint8List webImage = Uint8List(8);

  @override
  void initState() {
    getEthyStatus();
    super.initState();
    gettingUserData();

    titleController = TextEditingController(text: widget.title);
    productTypeController = TextEditingController(text: widget.productType);
    descriptionController = TextEditingController(text: widget.description);
    citiesController = TextEditingController(text: widget.cities);
    priceController = TextEditingController(text: widget.price.toString());
    discountedPriceController =
        TextEditingController(text: widget.discountedPerice.toString());
    quantityController = TextEditingController(text: widget.amount.toString());

    isDiscounted = widget.isDiscounted;
    postPreview = widget.postPreview;
  }

  @override
  void dispose() {
    titleController.dispose();
    productTypeController.dispose();
    descriptionController.dispose();
    citiesController.dispose();
    priceController.dispose();
    discountedPriceController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
      });
    });
  }

  getEthyStatus() async {
    final documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      ethyStatus = documentSnapshot['etsyVerified'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Determine if the screen is narrow or wide
              bool isNarrow = constraints.maxWidth < 600;

              return Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            child: const Text(
                              "Buy It",
                              style: TextStyle(
                                color: Color(0xff415141),
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onTap: () {
                              nextScreen(context, const HomePage());
                            },
                          ),
                          const SizedBox(width: 16.0),
                          if (!isNarrow)
                            GestureDetector(
                              onTap: () {
                                nextScreen(context, const SearchPage());
                              },
                              child: Container(
                                width: 220,
                                height: 40,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: const Color(0xffF8F8F8),
                                  border: Border.all(color: const Color(0xffF8F8F8)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      "e.g. Mesh shopping bag",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (isNarrow)
                            IconButton(
                              icon: const Icon(
                                Icons.search,
                                color: Color(0xff415141),
                                size: 24,
                              ),
                              onPressed: () {
                                nextScreen(context, const SearchPage());
                              },
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.tag_faces_outlined,
                                  color: Color(0xff171717),
                                  size: 27,
                                ),
                                onPressed: () {
                                  nextScreen(context, const ProfilePage());
                                },
                              ),
                              const Text(
                                "Profile",
                                style: TextStyle(
                                  color: Color(0xff171717),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16.0),
                          Column(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.shopping_bag_outlined,
                                  color: Color(0xff171717),
                                  size: 27,
                                ),
                                onPressed: () {
                                  nextScreen(context, const CartPage());
                                },
                              ),
                              const Text(
                                "Cart",
                                style: TextStyle(
                                  color: Color(0xff171717),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 150),
                  child: GestureDetector(
                    onTap: () {
                      nextScreen(context, const SellerInventoryPage());
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: const Color(0XffECF4EC),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Color(0xff123113),
                            size: 28,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 400),
                  child: Text(
                    "Edit item",
                    style: TextStyle(
                      color: Colors.black, // Adjust your color
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            Stack(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                ),
                SizedBox(
                  height: 84,
                  width: 84,
                  child: kIsWeb
                      ? postPreview == ""
                          ? Image.memory(
                              webImage,
                              width: 100,
                              height: 100,
                            )
                          : CachedNetworkImage(
                              imageUrl: postPreview,
                              fit: BoxFit.contain,
                              errorWidget: (context, error, stackTrace) {
                                return Image.asset(
                                  "assets/empty_cart.png",
                                  width: 100,
                                  height: 100,
                                );
                              },
                            )
                      : Image(
                          image: FileImage(File(postPreview)),
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              "assets/empty_cart.png",
                              width: 100,
                              height: 100,
                            );
                          },
                        ),
                ),
                Positioned(
                  bottom: -10,
                  left: 10,
                  child: IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  kIsWeb
                                      ? Container()
                                      : TextButton(
                                          onPressed: () async {
                                            postPreview = await DatabaseService(
                                                    uid: FirebaseAuth.instance.currentUser!.uid)
                                                .pickProductImageCamera(
                                                    userName,
                                                    FirebaseAuth.instance.currentUser!.uid,
                                                    titleController.text);
                                            setState(() {});
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            'Click from Camera',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                  TextButton(
                                    onPressed: () async {
                                      if (kIsWeb) {
                                        pickImageWeb();
                                      } else {
                                        postPreview = await DatabaseService(
                                                uid: FirebaseAuth.instance.currentUser!.uid)
                                            .pickProductImageGallery(
                                                userName,
                                                FirebaseAuth.instance.currentUser!.uid,
                                                titleController.text);
                                      }
                                      setState(() {});
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'Pick from Gallery',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    icon: const Icon(Icons.add_a_photo),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 5),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                ),
                Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Item Name",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff6A7769)),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              width: 632,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Color(0xffF8F8F8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextField(
                                controller: titleController,
                                decoration: const InputDecoration(
                                  hintText: "Enter Name",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 16),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Cities Delivered",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff6A7769)),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              width: 632,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Color(0xffF8F8F8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextField(
                                controller: citiesController,
                                decoration: const InputDecoration(
                                  hintText: "Seperate two or more cities with a comma.",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 16),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Item Description",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff6A7769)),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              width: 632,
                              height: 109,
                              decoration: BoxDecoration(
                                color: Color(0xffF8F8F8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextField(
                                controller: descriptionController,
                                decoration: const InputDecoration(
                                  hintText: "Tell buyers about your product",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 180),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Initial Price",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff6A7769)),
                                  ),
                              const Text("Product Price cannot be lower than 4 Pounds", 
                              style: TextStyle(fontSize: 12,
                              fontWeight: FontWeight.w500, color: Color(0xff6A7769)),),
                              const SizedBox(height: 5,),
                                  const SizedBox(height: 5),
                                  Container(
                                    width: 632,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: Color(0xffF8F8F8),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: TextField(
                                      controller: priceController,
                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                                        TextInputFormatter.withFunction((oldValue, newValue) {
                                          if (newValue.text.isEmpty) {
                                            return newValue;
                                          }
                                          final double? value = double.tryParse(newValue.text);
                                          if (value == null || value < 4) {
                                            return oldValue;
                                          }
                                          return newValue;
                                        }),
                                      ],
                                      decoration: const InputDecoration(
                                        hintText: "£ Enter amount",
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isDiscounted = true;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey.shade100),
                              child: const Text(
                                '% Add Discount',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff82A182)),
                              ),
                            ),
                          ],
                        ),
                        if (isDiscounted)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 180),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    const Text(
                                      "Discounted Price",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff6A7769),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 632,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: Color(0xffF8F8F8),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: TextField(
                                            controller: discountedPriceController,
                                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                                              TextInputFormatter.withFunction((oldValue, newValue) {
                                                if (newValue.text.isEmpty) {
                                                  return newValue;
                                                }
                                                final double? value = double.tryParse(newValue.text);
                                                if (value == null || value < 4) {
                                                  return oldValue;
                                                }
                                                return newValue;
                                              }),
                                            ],
                                            decoration: const InputDecoration(
                                              hintText: "£ Enter discounted amount",
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 16),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              discountedPriceController.text = '0.0';
                                              isDiscounted = false;
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.grey.shade100),
                                          child: const Text(
                                            '% Remove Discount',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xffE42D36)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Product Category",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff6A7769)),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              width: 632,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Color(0xffF8F8F8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButtonFormField<String>(
                                value: productTypeController.text,
                                onChanged: (newValue) {
                                  setState(() {
                                    productTypeController.text = newValue!;
                                  });
                                },
                                items: <String>[
                                  'Physical Goods',
                                  'Local Services',
                                  'Ticketed Events',
                                  'Fashion',
                                  'Accessories',
                                  'Beauty',
                                  'Home',
                                  'Crafts',
                                  'Lifestyle',
                                  'Wellness',
                                  'Gifts',
                                  'Other',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                decoration: const InputDecoration(
                                  hintText: "Product Category",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 16),
                                ),
                                dropdownColor: Color(0xffF8F8F8),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Set Limited Amount",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff6A7769)),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              width: 632,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Color(0xffF8F8F8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextField(
                                controller: quantityController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  TextInputFormatter.withFunction((oldValue, newValue) {
                                    if (newValue.text.isEmpty) {
                                      return newValue;
                                    }
                                    final int? value = int.tryParse(newValue.text);
                                    if (value == null || value <= 0) {
                                      return oldValue;
                                    }
                                    return newValue;
                                  }),
                                ],
                                decoration: const InputDecoration(
                                  hintText: "Amount (pcs)",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (postPreview == "") {
                      if (titleController.text != "" &&
                          descriptionController.text != "" &&
                          double.parse(priceController.text) > 0 &&
                          int.parse(quantityController.text) > 0) {
                        if (isDiscounted == true &&
                            double.parse(discountedPriceController.text) >= 0 &&
                            double.parse(discountedPriceController.text) <
                                double.parse(priceController.text)) {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Confirm Edit"),
                                  content: const Text(
                                      "Are you sure you want to Edit this Product?"),
                                  actions: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: const Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        try {
                                          DatabaseService(
                                                  uid: FirebaseAuth
                                                      .instance.currentUser!.uid)
                                              .removeProduct(widget.pid);
                                          kIsWeb
                                              ? DatabaseService(
                                                      uid: FirebaseAuth.instance
                                                          .currentUser!.uid)
                                                  .uploadProductToStorageWeb(
                                                      webImage,
                                                      userName,
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      titleController.text,
                                                      descriptionController.text,
                                                      email,
                                                      double.parse(priceController.text),
                                                      int.parse(quantityController.text),
                                                      productTypeController.text,
                                                      citiesController.text,
                                                      double.parse(
                                                          discountedPriceController.text),
                                                      isDiscounted,
                                                      ethyStatus)
                                              : DatabaseService(
                                                      uid: FirebaseAuth.instance
                                                          .currentUser!.uid)
                                                  .uploadProductToStorage(
                                                      File(postPreview),
                                                      userName,
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      titleController.text,
                                                      descriptionController.text,
                                                      email,
                                                      double.parse(priceController.text),
                                                      int.parse(quantityController.text),
                                                      productTypeController.text,
                                                      citiesController.text,
                                                      double.parse(
                                                          discountedPriceController.text),
                                                      isDiscounted,
                                                      ethyStatus);
                                        } catch (e) {
                                          if (kDebugMode) {
                                            print("The error is ${e.toString()}");
                                          }
                                        }

                                        nextScreenReplace(context, const ProfilePage());
                                        showSnackbar(context, Colors.green,
                                            "Product Updated Successfully!");
                                      },
                                      icon: const Icon(
                                        Icons.done,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                );
                              });
                        }
                        if (isDiscounted == false) {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Confirm Edit"),
                                  content: const Text(
                                      "Are you sure you want to Edit this Product?"),
                                  actions: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: const Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        DatabaseService(
                                                uid: FirebaseAuth.instance.currentUser!.uid)
                                            .removeProduct(widget.pid);
                                        kIsWeb
                                            ? DatabaseService(
                                                    uid: FirebaseAuth.instance.currentUser!.uid)
                                                .uploadProductToStorageWeb(
                                                    webImage,
                                                    userName,
                                                    FirebaseAuth.instance.currentUser!.uid,
                                                    titleController.text,
                                                    descriptionController.text,
                                                    email,
                                                    double.parse(priceController.text),
                                                    int.parse(quantityController.text),
                                                    productTypeController.text,
                                                    citiesController.text,
                                                    double.parse(
                                                        discountedPriceController.text),
                                                    isDiscounted,
                                                    ethyStatus)
                                            : DatabaseService(
                                                    uid: FirebaseAuth.instance.currentUser!.uid)
                                                .uploadProductToStorage(
                                                    File(postPreview),
                                                    userName,
                                                    FirebaseAuth.instance.currentUser!.uid,
                                                    titleController.text,
                                                    descriptionController.text,
                                                    email,
                                                    double.parse(priceController.text),
                                                    int.parse(quantityController.text),
                                                    productTypeController.text,
                                                    citiesController.text,
                                                    double.parse(
                                                        discountedPriceController.text),
                                                    isDiscounted,
                                                    ethyStatus);
                                        nextScreenReplace(context, const ProfilePage());
                                        showSnackbar(context, Colors.green,
                                            "Product Updated Successfully!");
                                      },
                                      icon: const Icon(
                                        Icons.done,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                );
                              });
                        }
                      } else {
                        showSnackbar(context, Colors.red,
                            "Please fill all the fields properly");
                      }
                    } else {
                      if (titleController.text != "" &&
                          descriptionController.text != "" &&
                          double.parse(priceController.text) > 0 &&
                          int.parse(quantityController.text) > 0) {
                        if (isDiscounted == true &&
                            double.parse(discountedPriceController.text) >= 0 &&
                            double.parse(discountedPriceController.text) <
                                double.parse(priceController.text)) {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Confirm Edit"),
                                  content: const Text(
                                      "Are you sure you want to Edit this Product?"),
                                  actions: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: const Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        DatabaseService(
                                                uid: FirebaseAuth.instance.currentUser!.uid)
                                            .removeProduct(widget.pid);
                                        DatabaseService(
                                                uid: FirebaseAuth.instance.currentUser!.uid)
                                            .saveProduct(
                                                postPreview,
                                                userName,
                                                email,
                                                FirebaseAuth.instance.currentUser!.uid,
                                                titleController.text,
                                                descriptionController.text,
                                                widget.pid,
                                                widget.sid,
                                                double.parse(priceController.text),
                                                int.parse(quantityController.text),
                                                productTypeController.text,
                                                citiesController.text,
                                                double.parse(discountedPriceController.text),
                                                isDiscounted,
                                                ethyStatus);
                                        nextScreenReplace(context, const ProfilePage());
                                        showSnackbar(context, Colors.green,
                                            "Product Updated Successfully!");
                                      },
                                      icon: const Icon(
                                        Icons.done,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                );
                              });
                        }
                        if (isDiscounted == false) {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Confirm Edit"),
                                  content: const Text(
                                      "Are you sure you want to Edit this Product?"),
                                  actions: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: const Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        DatabaseService(
                                                uid: FirebaseAuth.instance.currentUser!.uid)
                                            .removeProduct(widget.pid);
                                        DatabaseService(
                                                uid: FirebaseAuth.instance.currentUser!.uid)
                                            .saveProduct(
                                                postPreview,
                                                userName,
                                                email,
                                                FirebaseAuth.instance.currentUser!.uid,
                                                titleController.text,
                                                descriptionController.text,
                                                widget.pid,
                                                widget.sid,
                                                double.parse(priceController.text),
                                                int.parse(quantityController.text),
                                                productTypeController.text,
                                                citiesController.text,
                                                double.parse(discountedPriceController.text),
                                                isDiscounted,
                                                ethyStatus);
                                        nextScreenReplace(context, const ProfilePage());
                                        showSnackbar(context, Colors.green,
                                            "Product Updated Successfully!");
                                      },
                                      icon: const Icon(
                                        Icons.done,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                );
                              });
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0XffA2CAA2),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff123113)),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Confirm Terminate"),
                            content: const Text(
                                "Are you sure you want to Terminate this Product?"),
                            actions: [
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  DatabaseService(
                                          uid: FirebaseAuth.instance.currentUser!.uid)
                                      .removeProduct(widget.pid);
                                      Navigator.of(context).pop();
                                      nextScreenReplace(context, const ProfilePage());
                                },
                                icon: const Icon(
                                  Icons.done,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          );
                        });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade100,
                  ),
                  child: const Text(
                    'Terminate Item',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.red),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  Future<void> pickImageWeb() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final Uint8List fileBytes = await image.readAsBytes();
      setState(() {
        webImage = fileBytes;
        postPreview = "";
      });
    }
  }
}

class PositiveIntegerInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final int? value = int.tryParse(newValue.text);
    if (value == null || value <= 0) {
      return oldValue;
    }
    return newValue;
  }
}
