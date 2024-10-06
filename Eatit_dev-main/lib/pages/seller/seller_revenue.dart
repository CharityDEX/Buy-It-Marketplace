import 'package:eatit_dev/pages/faq.dart';
import 'package:eatit_dev/pages/home_page.dart';
import 'package:eatit_dev/pages/search_page.dart';
import 'package:eatit_dev/pages/seller/payout_page.dart';
import 'package:eatit_dev/pages/seller/seller_invetory.dart';
import 'package:flutter/material.dart';
import 'package:eatit_dev/pages/cart_page.dart';
import 'package:eatit_dev/pages/profile_page.dart';
import 'package:eatit_dev/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatit_dev/services/database_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SellerRevenuePage extends StatefulWidget {
  const SellerRevenuePage({super.key});

  @override
  State<SellerRevenuePage> createState() => _SellerRevenuePageState();
}

class _SellerRevenuePageState extends State<SellerRevenuePage> {

  double totalRevenue = 0;
  double lifetimeRevenue = 0;
  int totalItemsSold = 0;
  double averageSalePrice = 0;
  double amountWithdrawn = 0.0;
  String bio = "";
  String userName = "";
  List<dynamic> interests = [];
  late String picURL = "";
  Uint8List webBadgeImage = Uint8List(8);
  List<String> ethyBadgeUrls = [];

  @override
  void initState() {
    getPicURL();
    getSellerData();
    getEthyBadges();
    super.initState();
  }

  getSellerData() async {
    final userdocumentSnapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    final sellerdocumentSnapshot = await FirebaseFirestore.instance.collection('sellers').doc(userdocumentSnapshot['sid']).get();
    setState(() {
      lifetimeRevenue = sellerdocumentSnapshot['lifetimeRevenue'];
      totalRevenue = sellerdocumentSnapshot['sellerRevenue'];
      totalItemsSold = sellerdocumentSnapshot['sellerItemsSold'];
      averageSalePrice = lifetimeRevenue / totalItemsSold;
      amountWithdrawn = lifetimeRevenue - totalRevenue;
      bio = sellerdocumentSnapshot['bio'];
      userName = userdocumentSnapshot['userName'];
      interests = userdocumentSnapshot['interests'];
    });
  }

  getPicURL() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getProfilePicUrl().then((url) {
      setState(() {
        picURL = url;
      });
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(

      appBar: PreferredSize(
  preferredSize: const Size.fromHeight(kToolbarHeight),
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.person,
                            color: Color(0xff171717),
                            size: 27,
                          ),
                          onPressed: () {
                            nextScreen(context, const ProfilePage());
                          },
                        ),
                        if (!isNarrow)
                          const Text(
                            "Profile",
                            style: TextStyle(
                              color: Color(0xff171717),
                              fontSize: 11,
                            ),
                          ),
                      ],
                    ),
                    isNarrow? const SizedBox(width: 8): const SizedBox(width:16),
                    Column(
                      mainAxisSize: MainAxisSize.min,
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
                        if (!isNarrow)
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
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 600) {
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
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
                                const SizedBox(width: 15,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(userName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 5,),
                                    Text(bio, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20,),
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 4.0,
                              children: interests.map((interest) => Chip(
                                label: Text(interest, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff415141)),),
                                backgroundColor: const Color(0xffECF4EC),
                              )).toList(),
                            ),
                            const SizedBox(height: 20,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("£ ${lifetimeRevenue.toStringAsFixed(2)}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                                const SizedBox(height: 5),
                                const Text("Total revenue", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff6A7769))),
                                const SizedBox(height: 20),
                                Text("${totalItemsSold.toString()}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                                const SizedBox(height: 5),
                                const Text("Total items sold", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff6A7769))),
                                const SizedBox(height: 20),
                                Text("£ ${averageSalePrice.toStringAsFixed(2)}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                                const SizedBox(height: 5),
                                const Text("Average sale price", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff6A7769))),
                              ],
                            ),
                            const SizedBox(height: 20,),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xffF8F8F8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Ethy badges", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black)),
                                  const SizedBox(height: 20,),
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
                                              height: 80,
                                              width: 80,
                                              placeholder: (context, url) => CircularProgressIndicator(color: Theme.of(context).primaryColor),
                                              errorWidget: (context, url, error) => const Icon(Icons.badge_outlined, size: 30, color: Colors.grey),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  const SizedBox(height: 20,),
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      // Check if the screen is narrow (e.g., mobile)
                                      if (constraints.maxWidth < 600) {
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(left: 20,),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  _launchURL('https://ethy.co.uk/');
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  side: const BorderSide(color: Colors.grey),
                                                  backgroundColor: Colors.white,
                                                ),
                                                child: const Text(
                                                  'Get more badges on ethy',
                                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff123113)),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8), // Space between the buttons
                                            Container(
                                              padding: const EdgeInsets.only(left: 20,),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  showDialog(
                                                    barrierDismissible: true,
                                                    context: context,
                                                    builder: (context) {
                                                      return const AlertDialog(
                                                        title: Text("Ethy Badge Upload"),
                                                        content: Text("This feature is coming soon!"),
                                                      );
                                                    },
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  side: const BorderSide(color: Colors.grey),
                                                  backgroundColor: Colors.white,
                                                ),
                                                child: const Text(
                                                  'Upload badge',
                                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff123113)),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(left: 20,),
                                              width: 150,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  _launchURL('https://ethy.co.uk/');
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  side: const BorderSide(color: Colors.grey),
                                                  backgroundColor: Colors.white,
                                                ),
                                                child: const Text(
                                                  'Get more badges on ethy',
                                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff123113)),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: const EdgeInsets.only(left: 20,),
                                              width: 150,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  showDialog(
                                                    barrierDismissible: true,
                                                    context: context,
                                                    builder: (context) {
                                                      return const AlertDialog(
                                                        title: Text("Ethy Badge Upload"),
                                                        content: Text("This feature is coming soon!"),
                                                      );
                                                    },
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  side: const BorderSide(color: Colors.grey),
                                                  backgroundColor: Colors.white,
                                                ),
                                                child: const Text(
                                                  'Upload badge',
                                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff123113)),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20,),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xffF8F8F8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("£ ${totalRevenue.toStringAsFixed(2)}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 5),
                                  const Text("Available for withdrawl", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff6A7769))),
                                  const SizedBox(height: 10,),
                                  totalRevenue != 0 ?
                                  ElevatedButton(
                                    onPressed: (){
                                      nextScreen(context, PayoutPage(amount: totalRevenue));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      side: const BorderSide(color: Colors.grey),
                                      backgroundColor: Colors.white,
                                    ),
                                    child: const Text('Withdraw amount', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113)),),
                                  ) :
                                  const Text("You need to have positive funds to withdraw.", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xffBEBEBE))),
                                  const SizedBox(height: 20),
                                  ListTile(
                                    title: const Text('Inventory', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113)),),
                                    trailing: const Icon(Icons.arrow_forward_ios),
                                    onTap: () {
                                      nextScreen(context, const SellerInventoryPage());
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 100, top: 50,),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
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
                                const SizedBox(width: 15,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(userName, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 5,),
                                    Text(bio, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                const SizedBox(width: 10,),
                                Wrap(
                                  spacing: 8.0,
                                  runSpacing: 4.0,
                                  children: interests.map((interest) => Chip(
                                    label: Text(interest, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff415141)),),
                                    backgroundColor: const Color(0xffECF4EC),
                                  )).toList(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 50,),
                            Padding(
                              padding: const EdgeInsets.only(left: 50, right: 100),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text("£ ${lifetimeRevenue.toStringAsFixed(2)}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                                      const SizedBox(height: 5),
                                      const Text("Total revenue", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff6A7769))),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 50,
                                    child: VerticalDivider(
                                      color: Color(0xff6A7769),
                                      thickness: 1
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text("${totalItemsSold.toString()}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                                      const SizedBox(height: 5),
                                      const Text("Total items sold", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff6A7769))),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 50,
                                    child: VerticalDivider(
                                      color: Color(0xff6A7769),
                                      thickness: 1
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text("£ ${averageSalePrice.toStringAsFixed(2)}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                                      const SizedBox(height: 5),
                                      const Text("Average sale price", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff6A7769))),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 100,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color:const Color(0xffF8F8F8),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Ethy badges", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black)),
                                      const SizedBox(height: 50,),
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
                                                  height: 80,
                                                  width: 80,
                                                  placeholder: (context, url) => CircularProgressIndicator(color: Theme.of(context).primaryColor),
                                                  errorWidget: (context, url, error) => const Icon(Icons.badge_outlined, size: 30, color: Colors.grey),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      const SizedBox(height: 20,),
                                      Row(
                                        children: [
                                          Container(
                                            height: 46,
                                            width: 200,
                                            child: ElevatedButton(onPressed: (){
                                              _launchURL('https://ethy.co.uk/');
                                            },
                                            style: ElevatedButton.styleFrom(
                                              side: const BorderSide(color: Colors.grey),
                                              backgroundColor: Colors.white,
                                            ),
                                            child: const Text('Get more badges on ethy', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff123113)),),),
                                          ),
                                         // const SizedBox(width: 5,),
                                          Container(
                                            padding: const EdgeInsets.only(left: 20,),
                                            height: 46,
                                            width: 150,
                                            child: ElevatedButton(onPressed: (){
                                              //pickEtsyImageWeb();
                                              showDialog(
                                                barrierDismissible: true,
                                                context: context,
                                                builder: (context) {
                                                  return const AlertDialog(
                                                    title: Text("Ethy Badge Upload"),
                                                    content: Text("This feature is coming soon!"),
                                                  );
                                                },
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              side: const BorderSide(color: Colors.grey),
                                              backgroundColor: Colors.white,
                                            ),
                                            child: const Text('Upload badge', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff123113)),),),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(right: 150,),
                                  decoration: BoxDecoration(
                                    color:const Color(0xffF8F8F8),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          Text("£ ${totalRevenue.toStringAsFixed(2)}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                                          const SizedBox(height: 5),
                                          const Text("Available for withdrawl", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff6A7769))),
                                          const SizedBox(height: 10,),
                                          totalRevenue != 0 ?
                                          Container(
                                            padding: const EdgeInsets.only(left: 20,),
                                            height: 46,
                                            child: ElevatedButton(onPressed: (){
                                              nextScreen(context, PayoutPage(amount: totalRevenue));
                                            },
                                            style: ElevatedButton.styleFrom(
                                              side: const BorderSide(color: Colors.grey),
                                              backgroundColor: Colors.white,
                                            ),
                                            child: const Text('Withdraw amount', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113)),),),
                                          ) :
                                          const Text("You need to have positive funds to withdraw.", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xffBEBEBE))),
                                        ],
                                      ),
                                      const SizedBox(height: 10,),
                                      SizedBox(
                                        width: 396,
                                        height: 288,
                                        child: Column(
                                          children: [
                                            ListTile(
                                              title: Text('Inventory', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113)),),
                                              trailing: Icon(Icons.arrow_forward_ios),
                                              onTap: () {
                                                nextScreen(context, const SellerInventoryPage());
                                              },
                                            ),
                                            const Divider(height: 1,),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20,),
                          ],
                        ),
                      ),
                      
                    ],
                  );
                }
              },
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
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
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

  void _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
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

}
