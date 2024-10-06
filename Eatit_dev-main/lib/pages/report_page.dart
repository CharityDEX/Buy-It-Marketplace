import 'package:eatit_dev/pages/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:eatit_dev/pages/home_page.dart';
import 'package:eatit_dev/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'search_page.dart';
import 'profile_page.dart';
import 'package:eatit_dev/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportPage extends StatefulWidget {
  final String title;
  final String description;
  final String sellerPicURL;
  final String etsyBadgeURL;
  final String pid;
  final String sid;
  final int price;
  final String userName;
  final String productUrl;
  const ReportPage({
    super.key,
    required this.title,
    required this.description,
    required this.sellerPicURL,
    required this.etsyBadgeURL,
    required this.pid,
    required this.sid,
    required this.price,
    required this.userName,
    required this.productUrl,
  });

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String? selectedReason;
  TextEditingController otherController = TextEditingController();

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
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isNarrow = constraints.maxWidth < 600;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment:
                    isNarrow ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: isNarrow ? 10 : 100,
                      top: 50,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(width: 30),
                            GestureDetector(
                              onTap: () {
                                nextScreen(context, const HomePage());
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
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20, right: isNarrow ? 10 : 70),
                              child: Text(
                                "Report Item",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: isNarrow ? 18 : 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              const Text(
                                'If you believe that the product is violating our Safety Policy,',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Color(0xff171717),
                                ),
                              ),
                              const Text(
                                'please describe the matter of the problem and our team',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Color(0xff171717),
                                ),
                              ),
                              const Text(
                                'will review your report as quickly as possible.',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Color(0xff171717),
                                ),
                              ),
                              const SizedBox(height: 50),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                widget.productUrl,
                                width: isNarrow ? 120 : 176,
                                height: isNarrow ? 120 : 176,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      ClipOval(
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: widget.sellerPicURL,
                                          height: 20,
                                          width: 20,
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(
                                            Icons.badge_outlined,
                                            size: 30,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        widget.userName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Color(0xff123113),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    widget.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: isNarrow ? 14 : 16,
                                      color: Color(0xff123113),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    widget.description,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: isNarrow ? 14 : 16,
                                      color: Color(0xff123113),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    widget.price.toString(),
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Reason',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                            color: Color(0xff171717),
                          ),
                        ),
                        buildCheckButton('Abuse or harassment'),
                        const SizedBox(height: 5),
                        buildCheckButton('Call for violence'),
                        const SizedBox(height: 5),
                        buildCheckButton('Drugs sell attempt'),
                        const SizedBox(height: 5),
                        buildCheckButton(
                            'Seller sells other products under this product card'),
                        const SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selectedReason =
                                      'Other: ${otherController.text}';
                                });
                              },
                              child: Icon(
                                selectedReason != null &&
                                        selectedReason!.startsWith('Other')
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                height: 76,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: TextField(
                                  controller: otherController,
                                  decoration: const InputDecoration(
                                    hintText: 'Other',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(8.0),
                                  ),
                                  maxLines: null,
                                  expands: true,
                                  onChanged: (text) {
                                    setState(() {
                                      selectedReason = 'Other: $text';
                                    });
                                  },
                                  onTap: () {
                                    setState(() {
                                      selectedReason =
                                          'Other: ${otherController.text}';
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedReason != null &&
                                      selectedReason!.isNotEmpty
                                  ? const Color(0xffE42D36)
                                  : const Color(0xffBEBEBE),
                            ),
                            onPressed: () async {
                              if (selectedReason != null &&
                                  selectedReason!.isNotEmpty) {
                                await DatabaseService(
                                        uid: FirebaseAuth
                                            .instance.currentUser!.uid)
                                    .createReport(
                                  widget.userName,
                                  widget.title,
                                  widget.description,
                                  widget.price.toString(),
                                  widget.pid,
                                  widget.productUrl,
                                  widget.sid,
                                  selectedReason.toString(),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'You have reported the product successfully'),
                                  ),
                                );
                                nextScreenReplace(context, HomePage());
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please select a reason'),
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              'Send report',
                              style: TextStyle(color: Color(0xff171717)),
                            ),
                          ),
                        ),
                      ],
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

  Widget buildCheckButton(String title) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              selectedReason = title;
              otherController.clear();
            });
          },
          child: Icon(
            selectedReason == title
                ? Icons.check_box
                : Icons.check_box_outline_blank,
            color: Colors.grey,
          ),
        ),
        const SizedBox(width: 10),
        Text(title),
      ],
    );
  }
}
