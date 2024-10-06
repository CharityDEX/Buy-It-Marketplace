import 'package:eatit_dev/pages/auth/signin_page.dart';
import 'package:eatit_dev/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eatit_dev/pages/search_page.dart';
import 'package:eatit_dev/pages/profile_page.dart';
import 'package:eatit_dev/pages/cart_page.dart';
import 'package:eatit_dev/helper/helper_function.dart';
import 'package:eatit_dev/pages/faq.dart';
import 'package:url_launcher/url_launcher.dart';

class PassRecovery extends StatefulWidget {
  const PassRecovery({super.key});

  @override
  State<PassRecovery> createState() => _PassRecoveryState();
}

bool _isSignedIn = false;


class _PassRecoveryState extends State<PassRecovery> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  bool _isLoading = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: Container(
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
                      GestureDetector(
                        onTap: () {
                          // Navigate to SearchPage
                        },
                        child: Container(
                          width: 210,
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
                              // Navigate to AuthPage
                            },
                          ),
                          const Text(
                            "Log in",
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
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  const Padding(
                    padding: EdgeInsets.only(left: 550),
                    child: Text(
                      "Password Recovery",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 570),
                    child: Container(
                      height: 2,
                      width: 500,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Padding(
                    padding: EdgeInsets.only(left: 200),
                    child: Text(
                      "We got your back 😎",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.only(left: 370),
                    child: Text(
                      "Enter your e-mail so we can send you the recovery code.",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 600),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            "Email",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff6A7769)),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            width: 632,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xffF8F8F8),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                labelText: "Enter your e-mail",
                                labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffBEBEBE)),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  email = val;
                                });
                              },
                              validator: (val) {
                                return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val!)
                                    ? null
                                    : "Please Enter a valid email";
                              },
                            ),
                          ),
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.only(left: 250),
                            child: ElevatedButton(
                              onPressed: () {
                                verifyEmail();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0XffA2CAA2),
                              ),
                              child: const Text(
                                'Send Code',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PasswordRecoveryConfirmation(email: email),
          ),
        );
      } on FirebaseAuthException catch (e) {
        showSnackbar(context, Colors.red, e.message);
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

class PasswordRecoveryConfirmation extends StatelessWidget {
  final String email;

  const PasswordRecoveryConfirmation({super.key, required this.email});
  

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
  preferredSize: const Size.fromHeight(kToolbarHeight),
  child: SafeArea(
    child: LayoutBuilder(
      builder: (context, constraints) {
        // Determine if the screen is narrow or wide
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
                        fontFamily: 'Satoshi',
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
                            _isSignedIn
                                ? nextScreen(context, const ProfilePage())
                                : nextScreen(context, const AuthPage());
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
                        icon: ImageIcon(
                          AssetImage('cart_icon.png'),
                          color: Color(0xff171717),
                          size: 27,
                        ),
                        onPressed: () {
                          _isSignedIn
                              ? nextScreen(context, const CartPage())
                              : showDialog(
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (context) {
                                    return const AlertDialog(
                                      title: Text("Sign In"),
                                      content: Text("Please sign in to add items to your cart"),
                                    );
                                  },
                                );
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Password recovery",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
              ),
               const SizedBox(height: 5),
                                  Container(
                                    height: 2,
                                    width: screenWidth * 0.3,
                                    color: Colors.green,
                                  ),
              const SizedBox(height: 16),
              const Text(
                "Check your inbox 📧",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                "We've sent you a link for password recovery to $email. Please follow the link to update your password.",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500,),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AuthPage(),
                    ),
                  );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0XffA2CAA2),
                              ),
                              child: const Text(
                                'Back to login',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113)),
                              ),
                            ),

                            const SizedBox(height: 20,),
              Container(
                color: Color(0xFF123113),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: screenWidth < 600
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Buy It',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Make your everyday shopping more ethical, cheaper, and simple.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Legal',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                child: Text(
                                'Terms and Conditions',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              onTap: (){
                                _launchURL('https://drive.google.com/file/d/1gDXeK8jjwCJC90zlF7fqJdeTLqV7rV79/view?usp=sharing');
                              },
                              ),
                              GestureDetector(
                                child: Text(
                                'Privacy Policy for Buyers',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              onTap: (){
                                _launchURL('https://drive.google.com/file/d/1c0kYpZKRQUWeTPR-BIS2ohwDPprCR4rE/view?usp=sharing');
                              },
                              ),
                              GestureDetector(
                                child: Text(
                                'Privacy Policy for Sellers',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              onTap: (){
                                _launchURL('https://drive.google.com/file/d/1pnOGXzkAgEKUQylFAH879vqoIf89R3kc/view?usp=sharing');
                              },
                              ),
                              GestureDetector(
                                child: Text(
                                'Refund Policy',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              onTap: (){
                                _launchURL('https://drive.google.com/file/d/1-DSyh0laZCgeyTdti3-3Sgbclg4e3XHO/view?usp=sharing');
                              },
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Contact us directly',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'info@eatit.com',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Help',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                child: Text(
                                'F.A.Q.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              onTap: () {
                                nextScreen(context, const faqPage());
                              },
                              ),
                              GestureDetector(
                                child: Text(
                                'More about Ethy.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              onTap: () {
                                _launchURL('https://ethy.co.uk/');
                              },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              //Icon(Icons.linkedin, color: Colors.white),
                              const SizedBox(width: 16),
                              Icon(Icons.facebook, color: Colors.white),
                              const SizedBox(width: 16),
                              Icon(Icons.tiktok, color: Colors.white),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Buy It',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Make your everyday shopping more ethical, cheaper, and simple.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Legal',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                child: Text(
                                'Terms and Conditions',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              onTap: (){
                                _launchURL('https://drive.google.com/file/d/1gDXeK8jjwCJC90zlF7fqJdeTLqV7rV79/view?usp=sharing');
                              },
                              ),
                              GestureDetector(
                                child: Text(
                                'Privacy Policy for Buyers',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              onTap: (){
                                _launchURL('https://drive.google.com/file/d/1c0kYpZKRQUWeTPR-BIS2ohwDPprCR4rE/view?usp=sharing');
                              },
                              ),
                              GestureDetector(
                                child: Text(
                                'Privacy Policy for Sellers',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              onTap: (){
                                _launchURL('https://drive.google.com/file/d/1pnOGXzkAgEKUQylFAH879vqoIf89R3kc/view?usp=sharing');
                              },
                              ),
                              GestureDetector(
                                child: Text(
                                'Refund Policy',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              onTap: (){
                                _launchURL('https://drive.google.com/file/d/1-DSyh0laZCgeyTdti3-3Sgbclg4e3XHO/view?usp=sharing');
                              },
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Contact us directly',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'info@eatit.com',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Help',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                child: Text(
                                'F.A.Q.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              onTap: () {
                                nextScreen(context, const faqPage());
                              },
                              ),
                              GestureDetector(
                                child: Text(
                                'More about Ethy.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              onTap: () {
                                _launchURL('https://ethy.co.uk/');
                              },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              //Icon(Icons.linkedin, color: Colors.white),
                              const SizedBox(width: 16),
                              Icon(Icons.facebook, color: Colors.white),
                              const SizedBox(width: 16),
                              Icon(Icons.tiktok, color: Colors.white),
                            ],
                          ),
                        ],
                      ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

}
