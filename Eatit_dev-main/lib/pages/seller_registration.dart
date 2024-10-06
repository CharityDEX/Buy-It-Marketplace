import 'package:eatit_dev/pages/cart_page.dart';
import 'package:eatit_dev/pages/seller/seller_invetory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eatit_dev/pages/profile_page.dart';
import 'package:eatit_dev/widgets/widgets.dart';
import 'package:eatit_dev/pages/home_page.dart';
import 'package:eatit_dev/services/database_service.dart';
import 'search_page.dart';

class SellerRegistration extends StatefulWidget {
  const SellerRegistration({super.key});

  @override
  State<SellerRegistration> createState() => _SellerRegistrationState();
}

class _SellerRegistrationState extends State<SellerRegistration> {
  final formKey = GlobalKey<FormState>();
  String sellerName = "";
  String sellerAddress = "";
  String sellerBusinessName = "";
  String sellerBankAccNo = "";
  String sellerMobileNo = "";
  String bio = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: Container(
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
                      GestureDetector(
                        onTap: () {
                          nextScreen(context, const SearchPage());
                        },
                        child: Container(
                          width: 210,
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
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: 16.0),
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
                      nextScreen(context, const ProfilePage());
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 5.0),
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
                  padding: EdgeInsets.only(
                    left: 400,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Let's make business!",
                        style: TextStyle(
                          color: Colors.black, // Adjust your color
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 5,),
                      Text(
                    "Add some details about your shop to start selling products",
                    style: TextStyle(
                      color: Colors.black, // Adjust your color
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 30,
              ),
            ),
            Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      left: 5,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
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
                                "Shop name (optional)",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff6A7769)),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "You can give your shop a unique name otherwise your products will be sold under your name as stated in the profile section.",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xffBEBEBE)),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: 632,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Color(0xffF8F8F8),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextFormField(
                                  onChanged: (val) {
                                    setState(() {
                                      sellerBusinessName = val;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Enter shop name",
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 16),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Shop Description (max. 500 characters)",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff6A7769)),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: 632,
                                height: 109,
                                decoration: BoxDecoration(
                                  color: Color(0xffF8F8F8),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextFormField(
                                  onChanged: (val) {
                                    setState(() {
                                      bio = val;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Enter shop description",
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 16),
                                  ),
                                  maxLines: 3,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "Please enter shop description";
                                    } else if (val.length > 500) {
                                      return "Description cannot exceed 500 characters";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Phone number",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff6A7769)),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: 632,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Color(0xffF8F8F8),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextFormField(
                                  onChanged: (val) {
                                    setState(() {
                                      sellerMobileNo = val;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Enter mobile number",
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 16),
                                  ),
                                  validator: (val) {
                                    return val!.isEmpty
                                        ? "Please enter your phone number"
                                        : null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Full name",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff6A7769)),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: 632,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Color(0xffF8F8F8),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextFormField(
                                  onChanged: (val) {
                                    setState(() {
                                      sellerName = val;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Enter full name",
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 16),
                                  ),
                                  validator: (val) {
                                    return val!.isEmpty
                                        ? "Please enter full name"
                                        : null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Address",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff6A7769)),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: 632,
                                height: 109,
                                decoration: BoxDecoration(
                                  color: Color(0xffF8F8F8),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextFormField(
                                  onChanged: (val) {
                                    setState(() {
                                      sellerAddress = val;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Enter address",
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 16),
                                  ),
                                  validator: (val) {
                                    return val!.isEmpty
                                        ? "Please enter your address"
                                        : null;
                                  },
                                  maxLines: 3,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  registerSeller();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0XffA2CAA2),
              ),
              child: const Text(
                'Create shop',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff123113)),
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  registerSeller() async {
    if (formKey.currentState!.validate()) {
      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).savingSellerData(
          sellerName, sellerMobileNo, sellerBankAccNo, sellerAddress, bio);
      nextScreenReplace(context, const SellerInventoryPage());
    }
  }
}
