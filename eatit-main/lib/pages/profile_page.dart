import 'package:cloud_firestore/cloud_firestore.dart';
import 'contactus_page.dart';
import 'package:eatit/pages/auth/forgot_pass.dart';
import 'package:eatit/pages/cart_page.dart';
import 'package:eatit/pages/edit_profile_screen.dart';
import 'package:eatit/pages/order_history.dart';
import 'package:eatit/pages/seller/completed_orders.dart';
import 'package:eatit/pages/seller/seller_invetory.dart';
import 'package:eatit/pages/seller/seller_revenue.dart';
import 'package:eatit/pages/seller/seller_settings.dart';
import 'package:eatit/pages/seller_registration.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:eatit/pages/home_page.dart';
import 'package:eatit/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eatit/services/database_service.dart';
import 'package:eatit/helper/helper_function.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eatit/services/auth_service.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'search_page.dart';
import 'order_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:eatit/pages/faq.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String picURL = "";
  String userName = "";
  String email = "";
  int day = 0;
  int month = 0;
  int year = 0;
  String gender = "";
  List<dynamic> interests = [];
  String userDateCreated = "";
  String sid = "";
  String bio = "";
  double totalRevenue = 0;
  double lifetimeRevenue = 0;
  Uint8List webProfileImage = Uint8List(8);
  Uint8List webBadgeImage = Uint8List(8);
  List<String> ethyBadgeUrls = [];

  @override
  void initState() {
    getPicURL();
    gettingUserData();
    getUserDateCreated();
    getEthyBadges();
    super.initState();
  }

  getPicURL() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getProfilePicUrl().then((url) {
      setState(() {
        picURL = url;
      });
    });
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
  }

  getUserDateCreated() async {
    final documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    final dateCreated = documentSnapshot['dateCreated'] as Timestamp;
    setState(() {
      userName = documentSnapshot['userName'];
      day = documentSnapshot['day'];
      month = documentSnapshot['month'];
      year = documentSnapshot['year'];
      gender = documentSnapshot['gender'];
      interests = documentSnapshot['interests'];
      userDateCreated = DateFormat.yMMMd().format(dateCreated.toDate());
      sid = documentSnapshot['sid'];
    });
    if (sid != "") {
      getSellerInfo();
    }
  }

  getSellerInfo() async {
    final sellerDocumentSnapshot = await FirebaseFirestore.instance.collection('sellers').doc(sid).get();
    setState(() {
      bio = sellerDocumentSnapshot['bio'];
      lifetimeRevenue = sellerDocumentSnapshot['lifetimeRevenue'];
      totalRevenue = sellerDocumentSnapshot['sellerRevenue'];
    });
  }

  getEthyBadges() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('ethy')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      ethyBadgeUrls = snapshot.docs.map((doc) => doc['badgeURL'] as String).toList();
    });
  }

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 600) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Your profile",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipOval(
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: picURL,
                                    height: 56,
                                    width: 56,
                                    placeholder: (context, url) => CircularProgressIndicator(color: Theme.of(context).primaryColor),
                                    errorWidget: (context, url, error) => const Icon(Icons.account_circle, size: 100, color: Colors.grey),
                                  ),
                                ),
                                Positioned(
                                  bottom: -10,
                                  left: 50,
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
                                                    kIsWeb
                                                        ? pickProfileImageWeb()
                                                        : DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).pickImageGallery().then((_) {
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
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.add_a_photo),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(userName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                year != 0
                                    ? Text(gender + ", " + (2024 - year).toString() + " years old", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff6A7769)))
                                    : Container(),
                                const SizedBox(width: 10),
                                Text(email, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff6A7769))),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 4.0,
                              children: interests.map((interest) {
                                return Chip(
                                  label: Text(
                                    interest,
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff415141)),
                                  ),
                                  backgroundColor: const Color(0xffECF4EC),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 50),
                            ListView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                ListTile(
                                  title: const Text('Order history', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113))),
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                  onTap: () {
                                    nextScreen(context, const OrderHistory());
                                  },
                                ),
                                const Divider(height: 1),
                                ListTile(
                                  title: const Text('Ethy Verification', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113))),
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                  onTap: () {
                                     _launchURL('https://ethy.co.uk/');
                                  },
                                ),
                                const Divider(height: 1),
                                ListTile(
                                  title: const Text('Edit profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113))),
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                  onTap: () {
                                    nextScreen(
                                      context,
                                      EditProfileScreen(
                                        userName: userName,
                                        email: email,
                                        interests: interests,
                                        day: day,
                                        month: month,
                                        year: year,
                                        gender: gender,
                                        sid: sid,
                                      ),
                                    );
                                  },
                                ),
                                const Divider(height: 1),
                                sid == ""
                                    ? ListTile(
                                        title: const Text('Become a seller', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113))),
                                        trailing: const Icon(Icons.arrow_forward_ios),
                                        onTap: () {
                                          nextScreen(context, const SellerRegistration());
                                        },
                                      )
                                    : Container(),
                                const Divider(height: 1),
                                ListTile(
                                  title: const Text('Contact Us', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113))),
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                  onTap: () {
                                    nextScreen(context, ContactUsPage(userName: userName, email: email, uid: FirebaseAuth.instance.currentUser!.uid));
                                  },
                                ),
                                const Divider(height: 1),
                                ListTile(
                                  title: const Text('Change Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113))),
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                  onTap: () {
                                    nextScreen(context, const ForgotPass());
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Text(
                          "Active order",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('orders').where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid).where('isCompleted', isEqualTo: false).snapshots(),
                          builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.data!.docs.isEmpty) {
                              return Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset("assets/empty_cart.png", height: 175),
                                        const SizedBox(height: 20),
                                        Text(
                                          "No orders.",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green.shade900,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        const Text(
                                          "You haven't received an order yet.",
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(height: 50),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              reverse: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) => OrderCard(snap: snapshot.data!.docs[index].data()),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        sid == ""
                            ? Container()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Your shop",
                                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xffF8F8F8),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipOval(
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl: picURL,
                                            height: 56,
                                            width: 56,
                                            placeholder: (context, url) => CircularProgressIndicator(color: Theme.of(context).primaryColor),
                                            errorWidget: (context, url, error) => const Icon(Icons.account_circle, size: 100, color: Colors.grey),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 10),
                                            Text(userName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                                            const SizedBox(height: 10),
                                            Text(bio, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                            const SizedBox(height: 30),
                                            Row(
                                              children: [
                                                Column(
                                                  children: [
                                                    Text("£ ${totalRevenue.toString()}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                                                    const SizedBox(height: 5),
                                                    const Text("Can withdraw", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff6A7769))),
                                                  ],
                                                ),
                                                const SizedBox(width: 50),
                                                Column(
                                                  children: [
                                                    Text("£ ${lifetimeRevenue.toString()}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                                                    const SizedBox(height: 5),
                                                    const Text("Total revenue", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff6A7769))),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 20),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                left: 20,
                                              ),
                                              width: 242,
                                              height: 48,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  nextScreen(context, const SellerRevenuePage());
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  side: const BorderSide(color: Colors.grey),
                                                  backgroundColor: Colors.white,
                                                ),
                                                child: const Text(
                                                  'To business dashboard',
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113)),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 30),
                                            const Text("Ethy badges", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff6A7769))),
                                            const SizedBox(height: 10),
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: ethyBadgeUrls.map((url) {
                                                  return Padding(
                                                    padding: const EdgeInsets.only(right: 8.0),
                                                    child: ClipOval(
                                                      child: CachedNetworkImage(
                                                        fit: BoxFit.cover,
                                                        imageUrl: url,
                                                        height: 44.44,
                                                        width: 44.44,
                                                        placeholder: (context, url) => CircularProgressIndicator(color: Theme.of(context).primaryColor),
                                                        errorWidget: (context, url, error) => const Icon(Icons.badge_outlined, size: 30, color: Colors.grey),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                left: 20,
                                              ),
                                              width: 148,
                                              height: 46,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                   _launchURL('https://ethy.co.uk/');
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  side: const BorderSide(color: Colors.grey),
                                                  backgroundColor: Colors.white,
                                                ),
                                                child: const Text(
                                                  'Get more',
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113)),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        ListView(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          children: [
                                            ListTile(
                                              title: const Text('Orders', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113))),
                                              trailing: const Icon(Icons.arrow_forward_ios),
                                              onTap: () {
                                                nextScreen(context, CompletedOrders(sid: sid));
                                              },
                                            ),
                                            const Divider(height: 1),
                                            ListTile(
                                              title: const Text('Store Settings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113))),
                                              trailing: const Icon(Icons.arrow_forward_ios),
                                              onTap: () {
                                                nextScreen(context, const SellerSettings());
                                              },
                                            ),
                                            const Divider(height: 1),
                                            ListTile(
                                              title: const Text('Inventory', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113))),
                                              trailing: const Icon(Icons.arrow_forward_ios),
                                              onTap: () {
                                                nextScreen(context, const SellerInventoryPage());
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                        const SizedBox(height: 20),
                        Center(
                          child: TextButton(
                            child: const Text(
                              "Log out",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffE42D36)),
                            ),
                            onPressed: () async {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Log Out?"),
                                    content: const Text("Are you sure you want to Sign Out?"),
                                    actions: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        icon: const Icon(Icons.cancel, color: Colors.red),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          await authService.signOut();
                                          showSnackbar(context, Colors.green, "You have signed out successfully");
                                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomePage()), (route) => false);
                                        },
                                        icon: const Icon(Icons.done, color: Colors.green),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Your profile",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      ClipOval(
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: picURL,
                                          height: 56,
                                          width: 56,
                                          placeholder: (context, url) => CircularProgressIndicator(color: Theme.of(context).primaryColor),
                                          errorWidget: (context, url, error) => const Icon(Icons.account_circle, size: 100, color: Colors.grey),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: -10,
                                        left: 50,
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
                                                          kIsWeb
                                                              ? pickProfileImageWeb()
                                                              : DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).pickImageGallery().then((_) {
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
                                              },
                                            );
                                          },
                                          icon: const Icon(Icons.add_a_photo),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Text(userName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      year != 0
                                          ? Text(gender + ", " + (2024 - year).toString() + " years old", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff6A7769)))
                                          : Container(),
                                      const SizedBox(width: 10),
                                      Text(email, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff6A7769))),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 8.0,
                                    runSpacing: 4.0,
                                    children: interests.map((interest) {
                                      return Chip(
                                        label: Text(
                                          interest,
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff415141)),
                                        ),
                                        backgroundColor: const Color(0xffECF4EC),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                const SizedBox(height: 50),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 396,
                                      height: 288,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            ListTile(
                                              title: const Text('Order history', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113))),
                                              trailing: const Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons.arrow_forward_ios),
                                                ],
                                              ),
                                              onTap: () {
                                                nextScreen(context, const OrderHistory());
                                              },
                                            ),
                                            const Divider(height: 1),
                                            ListTile(
                                              title: const Text('Ethy Verification', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113))),
                                              trailing: const Icon(Icons.arrow_forward_ios),
                                              onTap: () {
                                                 _launchURL('https://ethy.co.uk/');
                                              },
                                            ),
                                            const Divider(height: 1),
                                            ListTile(
                                              title: const Text('Edit profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113))),
                                              trailing: const Icon(Icons.arrow_forward_ios),
                                              onTap: () {
                                                nextScreen(
                                                  context,
                                                  EditProfileScreen(
                                                    userName: userName,
                                                    email: email,
                                                    interests: interests,
                                                    day: day,
                                                    month: month,
                                                    year: year,
                                                    gender: gender,
                                                    sid: sid,
                                                  ),
                                                );
                                              },
                                            ),
                                            const Divider(height: 1),
                                            sid == ""
                                                ? ListTile(
                                                    title: const Text('Become a seller', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113))),
                                                    trailing: const Icon(Icons.arrow_forward_ios),
                                                    onTap: () {
                                                      nextScreen(context, const SellerRegistration());
                                                    },
                                                  )
                                                : Container(),
                                            const Divider(height: 1),
                                            ListTile(
                                              title: const Text('Contact Us', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113))),
                                              trailing: const Icon(Icons.arrow_forward_ios),
                                              onTap: () {
                                                nextScreen(context, ContactUsPage(userName: userName, email: email, uid: FirebaseAuth.instance.currentUser!.uid));
                                              },
                                            ),
                                            const Divider(height: 1),
                                            ListTile(
                                              title: const Text('Change Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113))),
                                              trailing: const Icon(Icons.arrow_forward_ios),
                                              onTap: () {
                                                nextScreen(context, const ForgotPass());
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 50),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "          Active orders",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 10),
                            StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('orders').where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid).where('isCompleted', isEqualTo: false).snapshots(),
                              builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                if (snapshot.data!.docs.isEmpty) {
                                  return Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Image.asset("assets/empty_cart.png", height: 175),
                                            const SizedBox(height: 20),
                                            Text(
                                              "No orders.",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green.shade900,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            const Text(
                                              "You haven't received an order yet.",
                                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                                            ),
                                            const SizedBox(height: 50),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  reverse: true,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) => OrderCard(snap: snapshot.data!.docs[index].data()),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            sid == ""
                                ? Container()
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Your shop",
                                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                                      ),
                                      const SizedBox(height: 20),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xffF8F8F8),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ClipOval(
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: picURL,
                                                height: 56,
                                                width: 56,
                                                placeholder: (context, url) => CircularProgressIndicator(color: Theme.of(context).primaryColor),
                                                errorWidget: (context, url, error) => const Icon(Icons.account_circle, size: 100, color: Colors.grey),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(height: 10),
                                                    Text(userName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                                                    const SizedBox(height: 10),
                                                    Text(bio, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                                    const SizedBox(height: 30),
                                                    Row(
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Text("£ ${totalRevenue.toString()}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                                                            const SizedBox(height: 5),
                                                            const Text("Can withdraw", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff6A7769))),
                                                          ],
                                                        ),
                                                        const SizedBox(width: 50),
                                                        Column(
                                                          children: [
                                                            Text("£ ${lifetimeRevenue.toString()}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                                                            const SizedBox(height: 5),
                                                            const Text("Total revenue", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff6A7769))),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 20),
                                                    Container(
                                                      padding: const EdgeInsets.only(
                                                        left: 20,
                                                      ),
                                                      width: 242,
                                                      height: 48,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          nextScreen(context, const SellerRevenuePage());
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          side: const BorderSide(color: Colors.grey),
                                                          backgroundColor: Colors.white,
                                                        ),
                                                        child: const Text(
                                                          'To business dashboard',
                                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113)),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 30),
                                                    const Text("Ethy badges", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff6A7769))),
                                                    const SizedBox(height: 10),
                                                    SingleChildScrollView(
                                                      scrollDirection: Axis.horizontal,
                                                      child: Row(
                                                        children: ethyBadgeUrls.map((url) {
                                                          return Padding(
                                                            padding: const EdgeInsets.only(right: 8.0),
                                                            child: ClipOval(
                                                              child: CachedNetworkImage(
                                                                fit: BoxFit.cover,
                                                                imageUrl: url,
                                                                height: 44.44,
                                                                width: 44.44,
                                                                placeholder: (context, url) => CircularProgressIndicator(color: Theme.of(context).primaryColor),
                                                                errorWidget: (context, url, error) => const Icon(Icons.badge_outlined, size: 30, color: Colors.grey),
                                                              ),
                                                            ),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Container(
                                                      padding: const EdgeInsets.only(
                                                        left: 20,
                                                      ),
                                                      width: 148,
                                                      height: 46,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                           _launchURL('https://ethy.co.uk/');
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          side: const BorderSide(color: Colors.grey),
                                                          backgroundColor: Colors.white,
                                                        ),
                                                        child: const Text(
                                                          'Get more',
                                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113)),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    const SizedBox(height: 50),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 396,
                                                          height: 288,
                                                          child: SingleChildScrollView(
                                                            child: Column(
                                                              children: [
                                                                ListTile(
                                                                  title: const Text('Orders', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113))),
                                                                  trailing: const Row(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    children: [
                                                                      Icon(Icons.arrow_forward_ios),
                                                                    ],
                                                                  ),
                                                                  onTap: () {
                                                                    nextScreen(context, CompletedOrders(sid: sid));
                                                                  },
                                                                ),
                                                                const Divider(height: 1),
                                                                ListTile(
                                                                  title: const Text('Store Settings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113))),
                                                                  trailing: const Icon(Icons.arrow_forward_ios),
                                                                  onTap: () {
                                                                    nextScreen(context, const SellerSettings());
                                                                  },
                                                                ),
                                                                const Divider(height: 1),
                                                                ListTile(
                                                                  title: const Text('Inventory', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113))),
                                                                  trailing: const Icon(Icons.arrow_forward_ios),
                                                                  onTap: () {
                                                                    nextScreen(context, const SellerInventoryPage());
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 50),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                            child: const Text(
                              "Log out",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffE42D36)),
                            ),
                            onPressed: () async {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Log Out?"),
                                    content: const Text("Are you sure you want to Sign Out?"),
                                    actions: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        icon: const Icon(Icons.cancel, color: Colors.red),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          await authService.signOut();
                                          showSnackbar(context, Colors.green, "You have signed out successfully");
                                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomePage()), (route) => false);
                                        },
                                        icon: const Icon(Icons.done, color: Colors.green),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                         
                      ],
                    );
                  }
                },
              ),
            ),
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
                                 _launchURL('https://drive.google.com/file/d/10KOMOR9AX4ZvaztgzkBNL9NubQrlTmuC/view?usp=sharing');
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
                                'support@buyit.market',
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
                              GestureDetector(child: FaIcon(FontAwesomeIcons.instagram, color: Colors.white,),
                              onTap: () {
                               _launchURL('https://www.instagram.com/buy_it_market_place?igsh=cHZ1dnFsOXF2OWJ4');
                              },
                              ), 
                              const SizedBox(width: 16),
                              GestureDetector(child: FaIcon(FontAwesomeIcons.youtube, color: Colors.white,),
                              onTap: () {
                               _launchURL('https://www.youtube.com/@BuyItMarketplace');
                              },
                              ),
                              const SizedBox(width: 16),
                              GestureDetector(child: FaIcon(FontAwesomeIcons.linkedin, color: Colors.white,),
                              onTap: () {
                               _launchURL('https://www.linkedin.com/company/buy-it-co');
                              },
                              ),
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
                                 _launchURL('https://drive.google.com/file/d/10KOMOR9AX4ZvaztgzkBNL9NubQrlTmuC/view?usp=sharing');
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
                              GestureDetector(child: FaIcon(FontAwesomeIcons.instagram, color: Colors.white,),
                              onTap: () {
                               _launchURL('https://www.instagram.com/buy_it_market_place?igsh=cHZ1dnFsOXF2OWJ4');
                              },
                              ), 
                              const SizedBox(width: 16),
                              GestureDetector(child: FaIcon(FontAwesomeIcons.youtube, color: Colors.white,),
                              onTap: () {
                               _launchURL('https://www.youtube.com/@BuyItMarketplace');
                              },
                              ),
                              const SizedBox(width: 16),
                              GestureDetector(child: FaIcon(FontAwesomeIcons.linkedin, color: Colors.white,),
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
      ),
    );
  }

  void noSeller() {
    nextScreen(context, const SellerRegistration());
  }

  void registeredSeller() {
    nextScreen(context, const SellerInventoryPage());
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

  Future<void> pickEtsyImageWeb() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      showSnackbar(context, Colors.green, "Uploading Badge, it will display after verification");
      final Uint8List fileBytes = await image.readAsBytes();
      setState(() {
        webBadgeImage = fileBytes;
      });
      await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).uploadEtsyBadgeToStorageWeb(webBadgeImage);
      getPicURL();
    }
  }

  void _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }
}
