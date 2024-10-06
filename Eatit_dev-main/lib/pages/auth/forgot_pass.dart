import 'package:eatit_dev/pages/auth/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:eatit_dev/widgets/widgets.dart';
import 'package:eatit_dev/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eatit_dev/helper/helper_function.dart';
import 'package:eatit_dev/pages/home_page.dart';
import 'package:eatit_dev/pages/search_page.dart';
import 'package:eatit_dev/pages/profile_page.dart';
import 'package:eatit_dev/pages/cart_page.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({super.key});

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  final formKey = GlobalKey<FormState>();
  String email = "";
  bool _isLoading = false;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor))
          : LayoutBuilder(
              builder: (context, constraints) {
                bool isNarrow = constraints.maxWidth < 600;

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (!isNarrow) const SizedBox(width: 30),
                            GestureDetector(
                              onTap: () {
                                nextScreen(context, const ProfilePage());
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
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
                            const SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                "Update password",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: isNarrow ? 24 : 32,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(height: 80),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: isNarrow ? 0 : 20,
                                  ),
                                  child: const Text(
                                    "Email",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff6A7769),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  width: isNarrow ? double.infinity : 632,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffF8F8F8),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      labelText: "Enter your Email",
                                      labelStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xffBEBEBE),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 16), // Align text inside the form field
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        email = val;
                                      });
                                    },
                                    validator: (val) {
                                      return RegExp(
                                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                              .hasMatch(val!)
                                          ? null
                                          : "Please Enter a valid email";
                                    },
                                  ),
                                ),
                                const SizedBox(height: 15),
                                ElevatedButton(
                                  onPressed: () {
                                    verifyEmail();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0XffA2CAA2),
                                  ),
                                  child: const Text(
                                    'Update Password',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff123113),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                if (!_isSignedIn)
                                  GestureDetector(
                                    child: const Text(
                                      "Sign in",
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    onTap: () {
                                      nextScreen(context, const AuthPage());
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future verifyEmail() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
        showSnackbar(context, Colors.green, "Password Reset Email has been sent.");
      } on FirebaseAuthException catch (e) {
        showSnackbar(context, Colors.red, e.message);
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
