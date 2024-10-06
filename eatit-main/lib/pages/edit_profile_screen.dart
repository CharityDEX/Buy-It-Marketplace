import 'package:eatit/pages/faq.dart';
import 'package:flutter/material.dart';
import 'package:eatit/pages/cart_page.dart';
import 'package:eatit/pages/home_page.dart';
import 'package:eatit/widgets/widgets.dart';
import 'search_page.dart';
import 'profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eatit/services/database_service.dart';
import 'package:flutter/foundation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatit/services/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditProfileScreen extends StatefulWidget {
  final String userName;
  final String email;
  final List<dynamic> interests;
  final int day;
  final int month;
  final int year;
  final String gender;
  final String sid;

  const EditProfileScreen({
    super.key,
    required this.userName,
    required this.email,
    required this.interests,
    required this.day,
    required this.month,
    required this.year,
    required this.gender,
    required this.sid,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late String picURL = "";
  Uint8List webProfileImage = Uint8List(8);
  late final _usernameController = TextEditingController(text: widget.userName);
  late final _dayController = TextEditingController(text: widget.day.toString());
  late final _monthController = TextEditingController(text: widget.month.toString());
  late final _yearController = TextEditingController(text: widget.year.toString());
  final _interestController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late String? _selectedGender = widget.gender;
  late List _interests;

  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    _interests = List.from(widget.interests);
    getPicURL();
  }

  getPicURL() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getProfilePicUrl().then((url) {
      setState(() {
        picURL = url;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 600;

          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 30),
                          GestureDetector(
                            onTap: () {
                              nextScreen(context, const ProfilePage());
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: const Color(0XffECF4EC),
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_rounded,
                                color: Color(0xff123113),
                                size: 28,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: isWideScreen ? 20 : 8),
                            child: Text(
                              "Edit profile",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.only(left: isWideScreen ? 90 : 8),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ClipOval(
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: picURL,
                                height: 145,
                                width: 145,
                                placeholder: (context, url) => CircularProgressIndicator(color: Theme.of(context).primaryColor),
                                errorWidget: (context, url, error) => const Icon(Icons.account_circle, size: 100, color: Colors.grey),
                              ),
                            ),
                            Positioned(
                              bottom: -5,
                              left: 90,
                              child: IconButton(
                                onPressed: () {
                                  showDialog(context: context, builder: (context) {
                                    return Dialog(
                                      child: ListView(
                                        shrinkWrap: true,
                                        children: [
                                          kIsWeb ? Container() : TextButton(
                                            onPressed: () {
                                              DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).pickImageCamera().then((_) {
                                                getPicURL();
                                              });
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Click from Camera', style: TextStyle(color: Colors.black)),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              kIsWeb ? pickProfileImageWeb() : DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).pickImageGallery().then((_) {
                                                getPicURL();
                                              });
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Pick from Gallery', style: TextStyle(color: Colors.black)),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                                },
                                icon: const Icon(Icons.add_a_photo),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildFieldWithHeading('Username', _usernameController, isWideScreen),
                      const SizedBox(height: 16),
                      Padding(
                        padding: EdgeInsets.only(left:  isWideScreen ? 90 : 8),
                        child: Text('Date of birth', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff6A7769)),),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: isWideScreen ? 90 : 8),
                        child: Row(
                          children: [
                            _buildDateField(_dayController, 'DD', isWideScreen),
                            const SizedBox(width: 8),
                            _buildDateField(_monthController, 'MM', isWideScreen),
                            const SizedBox(width: 8),
                            _buildDateField(_yearController, 'YYYY', isWideScreen),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: EdgeInsets.only(left: isWideScreen ? 90 : 8),
                        child: Text('Gender', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff6A7769)),),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: isWideScreen ? 90 : 8),
                        child: Container(
                          width: isWideScreen ? 632 : screenWidth * 0.8,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xffF8F8F8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            hint: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text('Select your gender', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff6A7769)),),
                            ),
                            value: _selectedGender,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedGender = newValue;
                              });
                            },
                            items: <String>['Male', 'Female', 'Other']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                  child: Text(value),
                                ),
                              );
                            }).toList(),
                            underline: const SizedBox(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: EdgeInsets.only(left:  isWideScreen ? 90 : 8),
                        child: Text('Interests'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: isWideScreen ? 90 : 8, bottom: 8),
                        child: Container(
                          width: isWideScreen ? 632 : screenWidth * 0.8,
                          decoration: BoxDecoration(
                            color: const Color(0xffF8F8F8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: _interests.map((interest) {
                              return Chip(
                                label: Text(interest, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff415141)),),
                                backgroundColor: const Color(0xffECF4EC),
                                onDeleted: () {
                                  setState(() {
                                    _interests.remove(interest);
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: isWideScreen ? 90 : 8),
                        child: Container(
                          width: isWideScreen ? 632 : screenWidth * 0.8,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xffF8F8F8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: _interestController,
                            decoration: const InputDecoration(
                              labelText: 'Add up to 5 interests to your profile',
                            ),
                            onSubmitted: (value) {
                              if (_interests.length < 5 && value.isNotEmpty) {
                                setState(() {
                                  _interests.add(value);
                                  _interestController.clear();
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              updateUser();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0XffA2CAA2),
                            ),
                            child: const Text('Save changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113)),),
                          ),
                          const SizedBox(width: 5,),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade100,
                            ),
                            onPressed: () async{
                              showDialog(barrierDismissible: false, context: context, builder: (context) {
                                return AlertDialog(
                                  title: const Text("Delete Account?"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                          "Are you sure you want to delete your account? This action cannot be reversed."),
                                      TextField(
                                        controller: _passwordController,
                                        decoration: const InputDecoration(
                                          labelText: 'Enter your password',
                                        ),
                                        obscureText: true,
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: const Icon(Icons.cancel, color: Colors.red),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        if(widget.sid=="")
                                        {
                                          const AlertDialog(
                                            content: Text("Contact us to delete the account",),
                                          );
                                        }
                                        else{
                                          showSnackbar(context, Colors.red, "Please terminate your shop before deleting your account.");
                                        }
                                      },
                                      icon: const Icon(Icons.done, color: Colors.green),
                                    ),
                                  ],
                                );
                              });
                            },
                            child: const Text('Delete account',  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffE42D36)),),
                          ),
                        ],
                      ),
                      const SizedBox(height: 60,),
                    ],
                  ),
                ),
                Container(
                  color: const Color(0xFF123113),
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
                                const Text(
                                  'Legal',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  child: const Text(
                                    'Terms and Conditions',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  onTap: () {
                                    _launchURL('https://drive.google.com/file/d/1gDXeK8jjwCJC90zlF7fqJdeTLqV7rV79/view?usp=sharing');
                                  },
                                ),
                                GestureDetector(
                                  child: const Text(
                                    'Privacy Policy for Buyers',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  onTap: () {
                                    _launchURL('https://drive.google.com/file/d/1c0kYpZKRQUWeTPR-BIS2ohwDPprCR4rE/view?usp=sharing');
                                  },
                                ),
                                GestureDetector(
                                  child: const Text(
                                    'Privacy Policy for Sellers',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  onTap: () {
                                    _launchURL('https://drive.google.com/file/d/10KOMOR9AX4ZvaztgzkBNL9NubQrlTmuC/view?usp=sharing');
                                  },
                                ),
                                GestureDetector(
                                  child: const Text(
                                    'Refund Policy',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  onTap: () {
                                    _launchURL('https://drive.google.com/file/d/1-DSyh0laZCgeyTdti3-3Sgbclg4e3XHO/view?usp=sharing');
                                  },
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Contact us directly',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'info@eatit.com',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Help',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  child: const Text(
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
                                  child: const Text(
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
                              children: const [
                                //Icon(Icons.linkedin, color: Colors.white),
                                SizedBox(width: 16),
                                Icon(Icons.facebook, color: Colors.white),
                                SizedBox(width: 16),
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
                              children: const [
                                Text(
                                  'Buy It',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
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
                                const Text(
                                  'Legal',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  child: const Text(
                                    'Terms and Conditions',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  onTap: () {
                                    _launchURL('https://drive.google.com/file/d/1gDXeK8jjwCJC90zlF7fqJdeTLqV7rV79/view?usp=sharing');
                                  },
                                ),
                                GestureDetector(
                                  child: const Text(
                                    'Privacy Policy for Buyers',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  onTap: () {
                                    _launchURL('https://drive.google.com/file/d/1c0kYpZKRQUWeTPR-BIS2ohwDPprCR4rE/view?usp=sharing');
                                  },
                                ),
                                GestureDetector(
                                  child: const Text(
                                    'Privacy Policy for Sellers',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  onTap: () {
                                    _launchURL('https://drive.google.com/file/d/10KOMOR9AX4ZvaztgzkBNL9NubQrlTmuC/view?usp=sharing');
                                  },
                                ),
                                GestureDetector(
                                  child: const Text(
                                    'Refund Policy',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  onTap: () {
                                    _launchURL('https://drive.google.com/file/d/1-DSyh0laZCgeyTdti3-3Sgbclg4e3XHO/view?usp=sharing');
                                  },
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Contact us directly',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'support@buyit.market',
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
                                const Text(
                                  'Help',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  child: const Text(
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
                                  child: const Text(
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
                                GestureDetector(
                                  child: const FaIcon(FontAwesomeIcons.instagram, color: Colors.white,),
                                  onTap: () {
                                    _launchURL('https://www.instagram.com/buy_it_market_place?igsh=cHZ1dnFsOXF2OWJ4');
                                  },
                                ), 
                                const SizedBox(width: 16),
                                GestureDetector(
                                  child: const FaIcon(FontAwesomeIcons.youtube, color: Colors.white,),
                                  onTap: () {
                                    _launchURL('https://www.youtube.com/@BuyItMarketplace');
                                  },
                                ),
                                const SizedBox(width: 16),
                                GestureDetector(
                                  child: const FaIcon(FontAwesomeIcons.linkedin, color: Colors.white,),
                                  onTap: () {
                                    _launchURL('https://www.linkedin.com/company/buy-it-co');
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFieldWithHeading(String heading, TextEditingController controller, bool isWideScreen) {
    return Padding(
      padding: EdgeInsets.only(left: isWideScreen ? 90 : 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(heading, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff6A7769)),),
          const SizedBox(height: 8),
          Container(
            width: isWideScreen ? 632 : MediaQuery.of(context).size.width * 0.8,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xffF8F8F8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(TextEditingController controller, String hint, bool isWideScreen) {
    return Container(
      width: 64,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xffF8F8F8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Future<void> pickProfileImageWeb() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      showSnackbar(context, Colors.green, "Updating profile picture, this may take a few seconds.");
      final Uint8List fileBytes = await image.readAsBytes();
      setState(() {
        webProfileImage = fileBytes;
      });
      await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).uploadToStorageWeb(webProfileImage);
      getPicURL();
    }
  }

  updateUser() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final userName = _usernameController.text.trim();
      final day = _dayController.text.trim();
      final month = _monthController.text.trim();
      final year = _yearController.text.trim();
      final gender = _selectedGender;
      final interests = _interests;

      if (userName.isNotEmpty && gender != null && day.isNotEmpty && month.isNotEmpty && year.isNotEmpty) {
        if(validateDate())
        {
          if (await checkUsernameExists(userName)) {
            await DatabaseService(uid: uid).updateUserData(uid, userName, int.parse(day), int.parse(month), int.parse(year), gender, interests);
            showSnackbar(context, Colors.green, "Your Profile has been updated successfully");
            nextScreenReplace(context, const ProfilePage());
          } else {
            showSnackbar(context, Colors.red, "Username already exists");
          } 
        }
        else{
          showSnackbar(context, Colors.red, "Please enter a valid Date of Birth");
        }
      } else {
        showSnackbar(context, Colors.red, "Please fill all the fields properly");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<bool> checkUsernameExists(String val) async {
    final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
    QuerySnapshot snapshot = await userCollection.where("userName", isEqualTo: val).get();
    if (snapshot.docs.isEmpty || val == widget.userName) {
      return true;
    } else {
      return false;
    }
  }

  bool validateDate() {
    int day = int.tryParse(_dayController.text) ?? 0;
    int month = int.tryParse(_monthController.text) ?? 0;
    int year = int.tryParse(_yearController.text) ?? 0;
    if (year < 1900 || year > DateTime.now().year) return false;
    if (month < 1 || month > 12) return false;
    int daysInMonth = DateTime(year, month + 1, 0).day;
    if (day < 1 || day > daysInMonth) return false;
    return true;
  }

  void _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }
}
