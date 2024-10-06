import 'package:eatit_dev/pages/auth/password_recovery.dart';
import 'package:flutter/material.dart';
import 'package:eatit_dev/widgets/widgets.dart';
import 'package:eatit_dev/pages/home_page.dart';
import 'package:eatit_dev/services/auth_service.dart';
import 'package:eatit_dev/helper/helper_function.dart';
import 'package:eatit_dev/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:eatit_dev/pages/search_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String userName = "";
  bool agreedToTerms = false;
  bool _isLoading = false;
  bool isSignIn = true;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              bool isNarrow = constraints.maxWidth < 600;

              return Container(
                color: const Color(0xffFFFFFF),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Buy It",
                            style: TextStyle(
                              color: Color(0xff415141),
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
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
                                  nextScreen(context, const AuthPage());
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
                                  showDialog(
                                    barrierDismissible: true,
                                    context: context,
                                    builder: (context) {
                                      return const AlertDialog(
                                        title: Text("Sign In"),
                                        content: Text("Please sign in to add items to your cart"),
                                      );
                                    });
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
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: screenHeight * 0.05),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSignIn = false;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    "Join",
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700,
                                      color: isSignIn ? Colors.grey : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    height: 2,
                                    width: screenWidth * 0.3,
                                    color: isSignIn ? Colors.grey : Colors.green,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 50),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSignIn = true;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    "Sign in",
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700,
                                      color: isSignIn ? Colors.black : Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    height: 2,
                                    width: screenWidth * 0.3,
                                    color: isSignIn ? Colors.green : Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      isSignIn ? buildSignInForm(screenWidth) : buildSignUpForm(screenWidth),
                      const SizedBox(height: 10),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget buildSignInForm(double screenWidth) {
    return Column(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("E-mail", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff6A7769))),
            const SizedBox(height: 5),
            Container(
              width: screenWidth * 0.9,
              height: 48,
              color: const Color(0xffF8F8F8),
              child: Center(
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    hintText: "Enter e-mail",
                    hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffBEBEBE),),
                  ),
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                  validator: (val) {
                    return RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(val!)
                      ? null
                      : "Please Enter a valid email";
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Password", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff6A7769))),
            const SizedBox(height: 5),
            Container(
              width: screenWidth * 0.9,
              height: 48,
              color: const Color(0xffF8F8F8),
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          hintText: "Enter password",
                          hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffBEBEBE),),
                        ),
                        validator: (val) {
                          if (val!.length < 6) {
                            return "Password must be at least 6 characters";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        nextScreen(context, const PassRecovery());
                      },
                      child: const Text(
                        "Forgot",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff82A182),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 92,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffA2CAA2),
              elevation: 0,),
            child: const Text(
              "Log in",
              style: TextStyle(color: Color(0xff123113), fontSize: 16, fontWeight: FontWeight.w500,),
            ),
            onPressed: () {
              signIn();
            },
          ),
        ),
        const SizedBox(height: 20),
        const Text("or simply with...", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff6A7769)),),
        const SizedBox(height: 10,),
        SizedBox(
          width: 133.33,
          height: 48,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              side: const BorderSide(color: Colors.black),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            icon: const FaIcon(FontAwesomeIcons.google),
            label: const Text("Google"),
            onPressed: () {
              signInGoogle();
            },
          ),
        ),
        const SizedBox(height: 10,),
        SizedBox(
          width: 133.33,
          height: 48,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              side: const BorderSide(color: Colors.black),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            icon: const FaIcon(FontAwesomeIcons.facebook),
            label: const Text("Facebook"),
            onPressed: () {
              signInFacebook();
            },
          ),
        ),
      ],
    );
  }

  Widget buildSignUpForm(double screenWidth) {
    return Column(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Username", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff6A7769))),
            const SizedBox(height: 5),
            Container(
              width: screenWidth * 0.9,
              height: 48,
              color: const Color(0xffF8F8F8),
              child: Center(
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    hintText: "Enter username",
                    hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffBEBEBE),),
                  ),
                  onChanged: (val) {
                    setState(() {
                      userName = val;
                    });
                  },
                  validator: (val) {
                    if (val!.isNotEmpty) {
                      return null;
                    } else {
                      return "Username cannot be empty";
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("E-mail", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff6A7769))),
            const SizedBox(height: 5),
            Container(
              width: screenWidth * 0.9,
              height: 48,
              color: const Color(0xffF8F8F8),
              child: Center(
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    hintText: "Enter e-mail",
                    hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffBEBEBE),),
                  ),
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                  validator: (val) {
                    return RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(val!)
                      ? null
                      : "Please Enter a valid email";
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Password", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff6A7769))),
            const SizedBox(height: 5),
            Container(
              width: screenWidth * 0.9,
              height: 48,
              color: const Color(0xffF8F8F8),
              child: Center(
                child: TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    hintText: "Enter password",
                    hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffBEBEBE),),
                  ),
                  validator: (val) {
                    if (val!.length < 6) {
                      return "Password must be at least 6 characters";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Confirm Password", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff6A7769))),
            const SizedBox(height: 5),
            Container(
              width: screenWidth * 0.9,
              height: 48,
              color: const Color(0xffF8F8F8),
              child: Center(
                child: TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    hintText: "Re-enter password",
                    hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffBEBEBE),),
                  ),
                  validator: (val) {
                    if (val!.length < 6) {
                      return "Password must be at least 6 characters";
                    } else {
                      if (val != password) {
                        return "The two passwords must be the same";
                      } else {
                        return null;
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.02),
          child: CheckboxListTile(
            title: const Text(
              "I agree to the Terms of Service and Privacy Policy",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            value: agreedToTerms,
            onChanged: (newValue) {
              setState(() {
                agreedToTerms = newValue!;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 92,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffA2CAA2),
              elevation: 0,),
            child: const Text(
              "Sign up",
              style: TextStyle(color: Color(0xff1E3010), fontSize: 16, fontWeight: FontWeight.w500),
            ),
            onPressed: () {
              agreedToTerms
                  ? signUp()
                  : showSnackbar(context, Colors.red,
                      "Please agree to the Terms of Service and Privacy Policy");
            },
          ),
        ),
        const SizedBox(height: 20),
        const Text("or simply with...", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff6A7769)),),
        const SizedBox(height: 10,),
        SizedBox(
          width: 133.33,
          height: 48,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              side: const BorderSide(color: Colors.black),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,),
            icon: const FaIcon(FontAwesomeIcons.google),
            label: const Text("Google"),
            onPressed: () {
              signInGoogle();
            },
          ),
        ),
        const SizedBox(height: 10,),
        SizedBox(
          width: 133.33,
          height: 48,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              side: const BorderSide(color: Colors.black),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,),
            icon: const FaIcon(FontAwesomeIcons.facebook),
            label: const Text("Facebook"),
            onPressed: () {
              signInFacebook();
            },
          ),
        ),
      ],
    );
  }

  signIn() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .signInUserWithEmailandPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot = await DatabaseService(
                  uid: FirebaseAuth.instance.currentUser!.uid)
              .gettingUserData(email);
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['userName']);
          nextScreenReplace(context, const HomePage());
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  signUp() async {
    if (formKey.currentState!.validate() &&
        await checkUsernameExists(userName) == true) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .signUpUserWithEmailandPassword(userName, email, password)
          .then((value) async {
        if (value == true) {
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(userName);
          nextScreenReplace(context, const HomePage());
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
    if (await checkUsernameExists(userName) == false) {
      showSnackbar(context, Colors.red, "Username already exists");
    }
  }

  signInGoogle() async {
    setState(() {
      _isLoading = true;
    });
    await authService.googleSignin().then((value) async {
      if (value == true) {
        nextScreenReplace(context, const HomePage());
      } else {
        showSnackbar(context, Colors.red, value);
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  signInFacebook() async {
    setState(() {
      _isLoading = true;
    });
    await authService.facebookLogin().then((value) async {
      if (value == true) {
        nextScreenReplace(context, const HomePage());
      } else {
        showSnackbar(context, Colors.red, value);
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  Future<bool> checkUsernameExists(String val) async {
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection("users");
    QuerySnapshot snapshot =
        await userCollection.where("userName", isEqualTo: val).get();
    if (snapshot.docs.isEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
