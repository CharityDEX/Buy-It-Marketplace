import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eatit_dev/helper/helper_function.dart';
import 'package:eatit_dev/services/auth_service.dart';
import 'package:eatit_dev/services/database_service.dart';
import 'package:eatit_dev/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eatit_dev/pages/home_page.dart';
import 'package:eatit_dev/pages/search_page.dart';
import 'package:eatit_dev/pages/profile_page.dart';
import 'package:eatit_dev/pages/seller/seller_invetory.dart';
import 'package:eatit_dev/pages/cart_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  AuthService authService = AuthService();
  String userName = "";
  bool ethyStatus = false;
  String email = "";
  String title = "";
  String productType = "";
  String description = "";
  String cities = "";
  double price = 0;
  int quantity = 0;
  bool isDiscounted = false;
  double discountedPrice = 0.0;
  late String postPreview = "";
  Uint8List webImage = Uint8List(8);

  @override
  void initState() {
    gettingUserData();
    super.initState();
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
                                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isNarrow = constraints.maxWidth < 600;
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isNarrow ? 16.0 : 30.0),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: isNarrow ? MainAxisAlignment.center : MainAxisAlignment.start,
                    children: [
                      if (!isNarrow) const SizedBox(width: 30),
                      Padding(
                        padding: EdgeInsets.only(left: isNarrow ? 0 : 150),
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
                      if (!isNarrow)
                        const Padding(
                          padding: EdgeInsets.only(left: 400),
                          child: Text(
                            "Add item",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (isNarrow)
                    const Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Text(
                        "Add item",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                      ),
                      SizedBox(
                        height: 84,
                        width: 84,
                        child: kIsWeb
                            ? postPreview != ""
                                ? Image.memory(
                                    webImage,
                                    width: 100,
                                    height: 100,
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
                        left: 70,
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
                                                          title);
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
                                                      title);
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
                      buildFormField(isNarrow),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (postPreview != "") {
                        if (title != "" &&
                            description != "" &&
                            productType != "" &&
                            price > 0 &&
                            quantity > 0) {
                          if (isDiscounted == true &&
                              discountedPrice >= 0 &&
                              discountedPrice < price) {
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Confirm Product Post"),
                                    content: const Text("Are you sure you want to Post this Product?"),
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
                                          kIsWeb
                                              ? DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                                                  .uploadProductToStorageWeb(
                                                      webImage,
                                                      userName,
                                                      FirebaseAuth.instance.currentUser!.uid,
                                                      title,
                                                      description,
                                                      email,
                                                      price,
                                                      quantity,
                                                      productType,
                                                      cities,
                                                      discountedPrice,
                                                      isDiscounted,
                                                      ethyStatus)
                                              : DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                                                  .uploadProductToStorage(
                                                      File(postPreview),
                                                      userName,
                                                      FirebaseAuth.instance.currentUser!.uid,
                                                      title,
                                                      description,
                                                      email,
                                                      price,
                                                      quantity,
                                                      productType,
                                                      cities,
                                                      discountedPrice,
                                                      isDiscounted,
                                                      ethyStatus);
                                          nextScreenReplace(context, const AddProductPage());
                                          showSnackbar(context, Colors.green, "Product Posted Successfully!");
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
                                    title: const Text("Confirm Product Post"),
                                    content: const Text("Are you sure you want to Post this Product?"),
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
                                          kIsWeb
                                              ? DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                                                  .uploadProductToStorageWeb(
                                                      webImage,
                                                      userName,
                                                      FirebaseAuth.instance.currentUser!.uid,
                                                      title,
                                                      description,
                                                      email,
                                                      price,
                                                      quantity,
                                                      productType,
                                                      cities,
                                                      discountedPrice,
                                                      isDiscounted,
                                                      ethyStatus)
                                              : DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                                                  .uploadProductToStorage(
                                                      File(postPreview),
                                                      userName,
                                                      FirebaseAuth.instance.currentUser!.uid,
                                                      title,
                                                      description,
                                                      email,
                                                      price,
                                                      quantity,
                                                      productType,
                                                      cities,
                                                      discountedPrice,
                                                      isDiscounted,
                                                      ethyStatus);
                                          nextScreenReplace(context, const ProfilePage());
                                          showSnackbar(context, Colors.green, "Product Posted Successfully!");
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
                          showSnackbar(context, Colors.red, "Please fill all the fields properly");
                        }
                      } else {
                        showSnackbar(context, Colors.red, "Please select an image.");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0XffA2CAA2),
                    ),
                    child: const Text(
                      'Add item',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff123113)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  Widget buildFormField(bool isNarrow) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        buildFormInput("Item Name", "Enter Name", TextInputType.text, (val) {
          setState(() {
            title = val;
          });
        }, isNarrow),
        const SizedBox(height: 10),
        buildFormInput("Cities Delivered", "Separate two or more cities with a comma.", TextInputType.text, (val) {
          setState(() {
            cities = val;
          });
        }, isNarrow),
        const SizedBox(height: 10),
        buildFormInput("Item Description", "Tell buyers about your product", TextInputType.text, (val) {
          setState(() {
            description = val;
          });
        }, isNarrow, isTextArea: true),
        const SizedBox(height: 10),
        buildFormInput("Initial Price", "£ Enter amount", TextInputType.numberWithOptions(decimal: true), (val) {
          setState(() {
            price = double.parse(val);
          });
        }, isNarrow, isNumeric: true),
        const SizedBox(height: 10),
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
        if (isDiscounted) ...[
          const SizedBox(height: 10),
          buildFormInput("Discounted Price", "£ Enter discounted amount", TextInputType.numberWithOptions(decimal: true), (val) {
            setState(() {
              discountedPrice = double.parse(val);
            });
          }, isNarrow, isNumeric: true),
          ElevatedButton(
            onPressed: () {
              setState(() {
                discountedPrice = 0.0;
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
        const SizedBox(height: 10),
        buildDropdownInput("Product Category", productType, [
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
        ], (val) {
          setState(() {
            productType = val!;
          });
        }, isNarrow),
        const SizedBox(height: 10),
        buildFormInput("Set Limited Amount", "Amount (pcs)", TextInputType.number, (val) {
          setState(() {
            quantity = int.parse(val);
          });
        }, isNarrow, isNumeric: true),
      ],
    );
  }

  Widget buildFormInput(String label, String hint, TextInputType inputType, Function(String) onChanged, bool isNarrow, {bool isTextArea = false, bool isNumeric = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xff6A7769)),
        ),
        const SizedBox(height: 5),
        Container(
          width: isNarrow ? double.infinity : 632,
          height: isTextArea ? 109 : 48,
          decoration: BoxDecoration(
            color: Color(0xffF8F8F8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            onChanged: onChanged,
            keyboardType: inputType,
            inputFormatters: isNumeric ? [
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
            ] : null,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 12, vertical: isTextArea ? 16 : 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDropdownInput(String label, String value, List<String> items, Function(String?) onChanged, bool isNarrow) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xff6A7769)),
        ),
        const SizedBox(height: 5),
        Container(
          width: isNarrow ? double.infinity : 632,
          height: 48,
          decoration: BoxDecoration(
            color: Color(0xffF8F8F8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            value: value.isEmpty ? null : value,
            onChanged: onChanged,
            items: items.map<DropdownMenuItem<String>>((String value) {
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
    );
  }

  Future<void> pickImageWeb() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final Uint8List fileBytes = await image.readAsBytes();
      setState(() {
        webImage = fileBytes;
        postPreview = "a";
      });
    }
  }
}
