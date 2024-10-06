import 'package:eatit_dev/pages/auth/signin_page.dart';
import 'package:eatit_dev/pages/cart_page.dart';
import 'package:eatit_dev/pages/home_page.dart';
import 'package:eatit_dev/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:eatit_dev/services/auth_service.dart';
import 'package:eatit_dev/pages/profile_page.dart';
import 'package:eatit_dev/widgets/widgets.dart';
import 'package:eatit_dev/helper/helper_function.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class faqPage extends StatefulWidget {
  const faqPage({super.key});

  @override
  State<faqPage> createState() => _faqPageState();
}

class _faqPageState extends State<faqPage> {
  bool _isSignedIn = false;
  AuthService authService = AuthService();
  List<Item> _data = generateItems();

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
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
                           icon: const Icon(
                            Icons.shopping_cart_outlined,
                            color: Color(0xff171717),
                            size: 27,
                          ),
                        // icon: ImageIcon(
                        //   AssetImage('cart_icon.png'),
                        //   color: Color(0xff171717),
                        //   size: 27,
                        // ),
                        onPressed: () {
                          _isSignedIn
                              ? nextScreen(context, const CartPage())
                              : nextScreen(context,const AuthPage());
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
                    GestureDetector(
                      onTap: () {
                        nextScreen(context, const HomePage());
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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          "Frequently asked questions (F.A.Q.)",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth < 600 ? 18 : 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ExpansionPanelList(
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        _data[index].isExpanded = !isExpanded;
                      });
                    },
                    children: _data.map<ExpansionPanel>((Item item) {
                      return ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            title: Text(
                              item.headerValue,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          );
                        },
                        body: ListTile(
                          title: Text(item.expandedValue),
                        ),
                        isExpanded: item.isExpanded,
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Didn't find answer to your question?",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "For more complex or rare problems please contact our client support service.",
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.support_agent, color: Color(0xff123113)),
                        label: const Text(
                          "Contact support",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff123113)),
                        ),
                        onPressed: () {
                          _isSignedIn
                              ? nextScreen(context, const ProfilePage())
                              : showSnackbar(context, Colors.red, "Please sign in to Contact Us");
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
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
      },
    );
  }

  void _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }
}

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems() {
  return [
    Item(
      headerValue: 'How is Buy It different from other marketplaces?',
      expandedValue: 'We have very low commissions - 5% compared to some of our competitors who take up to 50%\n\n'
          'We offer you help at every step along the way - from listing your product to payout questions.\n\n'
          'By partnering with Ethy, we have ensured that the most sustainable businesses appear at the top, which distinguishes our marketplace from others.\n\n'
          'Buy It is designed to connect consumers directly with the source of sustainable and artisanal goods, promoting community engagement and environmental responsibility.',
    ),
    Item(
      headerValue: 'Are there any hidden fees when selling on Buy It?',
      expandedValue: 'There are no hidden fees. We maintain transparency with our low commission rate, ensuring sellers understand their earnings and expenses.',
    ),
    Item(
      headerValue: 'Is Buy It free?',
      expandedValue: 'Yes, Buy It is completely free to join and use.',
    ),
    Item(
      headerValue: 'What types of products can I find on Buy It?',
      expandedValue: 'You can find a variety of products: thrift clothes, art, jewelry, handmade produce, candles, soaps, toys, and many other local and sustainable items.',
    ),
    Item(
      headerValue: 'Which countries do you support?',
      expandedValue: 'Currently, we are based in the UK. But we are expanding rapidly.',
    ),
    Item(
      headerValue: 'How to register?',
      expandedValue: '1.1 Info We Need From You (Data Policy)\nAt Buy It Marketplace, your privacy and data security are our top priorities. During registration, we ask for the following information:\n'
          'Email Address: To contact you about your transactions, send you updates, and for account recovery purposes.\n'
          'Username: Your unique identifier on our platform.\n'
          'Password: To secure your account (if you\'re not using social login options).\n'
          'Location: To provide you with localized services and relevant product listings.\n'
          'Payment Information: For transaction purposes. Note: Payment details are encrypted and stored securely by Stripe.\n'
          'Data Policy: We are committed to protecting your personal information. Your data is encrypted and stored securely on our servers. We do not sell your data to third parties. For a detailed explanation of how we use and safeguard your information, please refer to our Privacy Policy.\n'
          '1.2 How It Works - Google, Apple, Facebook, and Native\n'
          'To simplify the registration process, Buy It Marketplace offers several sign-up options:\n'
          'Google, Apple, Facebook Sign-In: By choosing one of these options, you can register using your existing Google, Apple, or Facebook account. This method is secure and does not grant us access to your social media profiles. We receive only your name, email address, and profile picture from these services to create your Buy It Marketplace account.\n'
          'Native Registration: Prefer not to use social logins? You can sign up by providing your email address and creating a new password specifically for Buy It Marketplace. This option also requires verification of your email address to ensure the security of your account.\n'
          'Security Note: Regardless of the method you choose, we implement rigorous security measures to protect your account and personal information. For more details on our security practices, please visit our Security Center.',
    ),
    Item(
      headerValue: 'How to create a profile?',
      expandedValue: '2.1 Meta Data\nWhen setting up your profile on Buy It Marketplace, you\'ll be asked to provide some information about yourself. This includes:\n'
          'Profile Picture: Helps others recognize you on the marketplace.\n'
          'Biography: A short description to introduce yourself to the community.\n'
          'Location: To show local products and offers.\n'
          'Preferences: Your interests to personalize your product feed.\n'
          '2.2 How We Use This Data\nYour profile data helps us to personalize your experience on Buy It Marketplace. By understanding your preferences and location, we can recommend products that are most relevant to you. Your bio and profile picture make your interactions within the marketplace more personal and engaging. Rest assured, your privacy is paramount, and you have control over what information is visible to others.\n'
          '2.3 Settings\nIn your profile settings, you can manage:\n'
          'Privacy Controls: Decide what information is visible to other users and what is kept private.\n'
          'Notification Preferences: Customize how you receive alerts for new products, messages, and updates.\n'
          'Account Security: Change your password, set up two-factor authentication, and review your account\'s activity.\n'
          'Account info\nContacts\nPreferences',
    ),
    Item(
      headerValue: 'What is a Product Feed?',
      expandedValue: '3.1 Filters\nUse filters to narrow down the vast selection of products to find exactly what you\'re looking for. Filter by category, price, location, and more. We also show the products which have been verified by Ethy (see point 3.3) and most recent items first.\n'
          '3.2 Ratings\nProducts and sellers are rated by the community, helping you to make informed purchasing decisions. Higher-rated products are more likely to meet your expectations.\n'
          '3.3 Ethy\nWe\'ve partnered with Ethy to highlight businesses that are committed to sustainability. Products from businesses with high Ethy ratings are prioritized in your feed, making it easier for you to shop ethically. Here is how it works:\n'
          'You complete the Ethy verification on the official Ethy website\n'
          'If successful, Ethy will send you your badges via email\n'
          'You can then upload these badges to your Buy It account\n'
          '3.4 Search\nOur powerful search tool helps you find specific products or categories quickly. Use keywords, phrases, or even product codes to start your search.\n'
          '3.5 Explanation of Categories\nCategories organize products to streamline your browsing experience. Categories range from Electronics, Home Goods, Fashion, to Sustainable Goods, among others. Each category is tailored to help you find specific types of products efficiently.',
    ),
    Item(
      headerValue: 'What is the platform’s Pricing Policy?',
      expandedValue: '4.1 We Are Not Responsible for the Prices\nAt Buy It Marketplace, we provide a platform for sellers to list their products. Please note that the prices of products listed on our marketplace are determined by the individual sellers, not by Buy It Marketplace. We strive to ensure a fair and competitive marketplace but cannot dictate or modify the prices set by sellers.\n'
          '4.2 Discounts - Understanding\nSellers on Buy It Marketplace may offer discounts on their products for promotions or sales events. These discounts are at the discretion of the sellers. We encourage our sellers to provide genuine discounts to benefit the community. Users can see the original and discounted prices to understand the savings on their purchases.',
    ),
    Item(
      headerValue: 'How to pay?',
      expandedValue: '5.1 Basket\nBrowse or Search: Find the products you wish to purchase.\nAdd to Basket: Select the desired product and add it to your basket.\nReview Your Basket: Before proceeding to payment, you can review the items in your basket, adjust quantities, or remove items as needed.\n'
          '5.2 Payment\nCheckout: When you\'re ready to purchase, proceed to checkout.\nEnter Shipping Information: Provide a shipping address where your order will be delivered.\nChoose Payment Method: Select your preferred payment method. We support various methods to accommodate your needs.\n'
          '5.3 Stripe\nSecure Payment Processing: We use Stripe, a leading online payment processor, to handle all transactions securely.\nWhere is the Data Kept: Your payment information is encrypted and securely processed by Stripe. It is not stored on our servers. Stripe maintains the highest levels of security compliance, ensuring that your payment data is safe and protected.',
    ),
    Item(
      headerValue: 'How to receive a delivery?',
      expandedValue: '6.1 How to Track Delivery\nAfter making a purchase, you will receive a confirmation email with a tracking number for your order. You can track the delivery status by:\n'
          'Logging into your Buy It Marketplace account.\n'
          'Going to "My Orders" section.\n'
          'Clicking on the order you wish to track to view the current delivery status.\n'
          '6.2 How to Contact Seller\nIf you have questions about your order or delivery, you can contact the seller directly through Buy It Marketplace:\n'
          'Go to the product page of the item you purchased.\n'
          'Click on the seller\'s name to go to their profile.\n'
          'Use the "Contact Seller" button to send a message.\n'
          '6.3 How to Contact Support\nFor assistance beyond seller communication, our Support Team is here to help:\n'
          'Through the App: Access the "Help" or "Support" section in the app to submit a query.\n'
          'Via Email: Contact us at support@buyitmarketplace.com with any concerns or questions.\n'
          '6.4 Liability for Delivery\nSellers on Buy It Marketplace are responsible for ensuring that items are delivered to the buyer as described. However, should there be issues with delivery (e.g., items not arriving, arriving damaged), please contact the seller first to attempt resolution. If resolution cannot be reached, our Support Team can assist in mediating the situation.\n'
          '6.5 How to Receive the Delivery\nWhen your order arrives, please:\nVerify the package is intact.\nConfirm the item matches your order.\nIf there are any issues, contact the seller or our Support Team immediately.',
    ),
    Item(
      headerValue: 'How does rating work?',
      expandedValue: '7.1 Rating and Review\nAfter receiving your order, you are encouraged to leave a rating and review for the product and the seller. This helps other buyers make informed decisions and supports sellers in improving their service. Here’s how:\n'
          'Go to "My Orders" and select the item you wish to rate.\n'
          'Choose the number of stars you wish to award (usually 1 to 5 stars, with 5 being the highest).\n'
          'Leave a detailed review describing your experience with the product and seller.\n'
          'Please provide honest and respectful feedback to maintain a helpful and trustworthy community on Buy It Marketplace.',
    ),
    Item(
      headerValue: 'How to register for businesses?',
      expandedValue: '1.1 Info We Need from You (Data Policy)\nBusiness Information: Legal name, business type, and address.\nTax Information: For billing and compliance.\nContact Information: Email and phone number for communication.\nBank Account or Stripe Account: For payment processing.\nHow to Get This Information: This information is typically found in your business documents, tax filings, and banking information.\n'
          '1.2 Where This Data Is Sent\nYour data is securely transmitted to our servers and to Stripe (for payment processing). It is stored with high security and compliance standards to protect your business information.',
    ),
    Item(
      headerValue: 'How to create a profile for businesses?',
      expandedValue: '2.1 Meta Data\nCompany Profile: Including your logo, a brief description, and a link to your website.\nProduct Categories: The categories that best represent your products.\n'
          '2.2 How We Use This Data\nTo showcase your business to potential buyers, personalize your product feed, and improve product recommendations.\n'
          '2.3 Settings\nManage privacy, notifications, and account security from your dashboard.\n'
          '2.4 Ethy\nIf your business qualifies, you can get an Ethy rating to showcase your commitment to sustainability. This can increase your visibility on the marketplace.\n'
          '2.5 How to List Your Products?\nProduct Details: Provide product name, description, images, and price.\nInventory: Specify the quantity available.\nShipping: Include shipping options and costs.\nSubmit for Review: Listings are reviewed to ensure they meet our quality standards.',
    ),
    Item(
      headerValue: 'What is the product feed for businesses?',
      expandedValue: 'Filters, Ratings, Ethy!, Search, Explanation of Categories\nThese features help buyers to find your products more easily. Ensure your products are accurately categorized and described.',
    ),
    Item(
      headerValue: 'What is the platform’s Pricing Policy for businesses?',
      expandedValue: '4.1 Setting Discounts\nYou can offer discounts through the dashboard. Specify the discount percentage and duration.\n'
          '4.2 Pricing Your Items\nPricing is entirely under your control. We provide market data to help you set competitive prices.',
    ),
    Item(
      headerValue: 'How to receive a payment for businesses?',
      expandedValue: '5.1 Commission\nWe charge a commission on sales. Details are provided in your contract.\n'
          '5.2 Stripe\nPayments are processed through Stripe. Ensure your Stripe account is set up and linked to your profile.',
    ),
    Item(
      headerValue: 'How to deliver for businesses?',
      expandedValue: '6.1 Tracking Delivery\nUse your postal service provider\'s tracking tools and share tracking numbers with buyers.\n'
          '6.2 Contacting Buyer\nCommunicate through the marketplace\'s messaging system for privacy and security.\n'
          '6.3 Contacting Support\nOur support team is available for any issues or questions you may have.\n'
          '6.4 Liability for Delivery\nYou are responsible for ensuring the product reaches the buyer. Consider insurance for high-value items.\n'
          '6.5 Confirming Delivery\nUpdate the order status in your dashboard once delivery is confirmed.',
    ),
    Item(
      headerValue: 'What is the rating for businesses?',
      expandedValue: 'Your rating is determined by buyer feedback. High ratings improve your visibility and trustworthiness on the marketplace.',
    ),
  ];
}
