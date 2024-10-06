import 'package:eatit_dev/pages/cart_page.dart';
import 'package:eatit_dev/pages/home_page.dart';
import 'package:eatit_dev/pages/profile_page.dart';
import 'package:eatit_dev/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:eatit_dev/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'search_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BuyPage extends StatefulWidget {
  final int totalItems;
  final num totalPrice;
  final Map<String, int> orderQuantities;
  const BuyPage({super.key, required this.totalItems, required this.totalPrice, required this.orderQuantities});

  @override
  State<BuyPage> createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {

  String address = "";
  String country = "";
  String city = "";
  String street = "";
  String postalCode = "";
  String addressOther= "";
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
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
                            Icons.tag_faces_outlined,
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

      body: _isLoading? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor),): LayoutBuilder(
        builder: (context, constraints) {
          bool isNarrowScreen = constraints.maxWidth < 600;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50,),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 30),
                        GestureDetector(
                          onTap: () {
                            nextScreen(context, const CartPage());
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
                        isNarrowScreen?
                        const Padding(
                          padding: EdgeInsets.only(left: 50,),
                          child: 
                          Text(
                            "Shipping address",
                            style: TextStyle(
                              color: Colors.black, // Adjust your color
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ):
                        const Padding(
                          padding: EdgeInsets.only(left: 50,),
                          child: 
                          Text(
                            "Shipping address",
                            style: TextStyle(
                              color: Colors.black, // Adjust your color
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30, left: isNarrowScreen ? 0 : 120,),
                    child: Column(
                      children: [
                        Form(
                          key: formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget> [
                              Row(
                                children: [
                                  Container(
                                    width: isNarrowScreen ? 160 : 200,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffF8F8F8),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Country of Delivery", 
                                          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffBEBEBE)),
                                      ),
                                      onChanged: (val){
                                        setState(() {
                                          country = val;
                                        });
                                      },
                                      validator: (val){
                                        if(val!.isEmpty){
                                          return "Please enter a valid country"; 
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 5,),
                                  Container(
                                    width: isNarrowScreen ? 160 : 200,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffF8F8F8),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "City", 
                                          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffBEBEBE)),
                                      ),
                                      onChanged: (val){
                                        setState(() {
                                          city = val;
                                        });
                                      },
                                      validator: (val){
                                        if(val!.isEmpty){
                                          return "Please enter a valid city"; 
                                        }
                                        return null;
                                      },
                                      maxLines: 3,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5,),
                              Row(
                                children: [
                                  Container(
                                    width: isNarrowScreen ? 160 : 200,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffF8F8F8),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Street", 
                                          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffBEBEBE)),
                                      ),
                                      onChanged: (val){
                                        setState(() {
                                          street = val;
                                        });
                                      },
                                      validator: (val){
                                        if(val!.isEmpty){
                                          return "Please enter a valid street"; 
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 5,),
                                  Container(
                                    width: isNarrowScreen ? 160 : 200,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffF8F8F8),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Postal Code", 
                                          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffBEBEBE)),
                                      ),
                                      onChanged: (val){
                                        setState(() {
                                          postalCode = val;
                                        });
                                      },
                                      validator: (val){
                                        if(val!.isEmpty){
                                          return "Please enter a postal code"; 
                                        }
                                        return null;
                                      },
                                      maxLines: 3,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5,),
                              Container(
                                width: isNarrowScreen ? constraints.maxWidth - 40 : 416,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(0xffF8F8F8),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Other (ex. floor, apartment, entrance nr.)", 
                                      labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffBEBEBE)),
                                  ),
                                  onChanged: (val){
                                    setState(() {
                                      addressOther = val;
                                    });
                                  },
                                  validator: (val){
                                    if(val!.isEmpty){
                                      return "Please enter a valid address"; 
                                    }
                                    return null;
                                  },
                                  maxLines: 3,
                                ),
                              ),
                              const SizedBox(height: 15,),
                              Text("Total Items: ${widget.totalItems}" , 
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.green.shade900),
                              ),
                              const SizedBox(height: 15,),
                              Text("Total Amount: ${widget.totalPrice}" , 
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.green.shade900),
                              ),
                              const SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: isNarrowScreen ? constraints.maxWidth - 40 : 384,
                                    height: 49,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffF8F8F8),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if(formKey.currentState!.validate())
                                        {
                                          showDialog(barrierDismissible: false, context: context, builder: (context){
                                            return AlertDialog(
                                              title: const Text("Confirm Purchase"),
                                              content: const Text("Are you sure you want to buy these products?"),
                                              actions: [
                                                IconButton(onPressed: (){
                                                  Navigator.of(context).pop();
                                                },
                                                icon: const Icon(Icons.cancel, color: Colors.red,),
                                                ),
                                                IconButton(onPressed: () async{
                                                  setState(() {
                                                    _isLoading = true;
                                                  });
                                                  DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).createAddress(FirebaseAuth.instance.currentUser!.uid, country, city, street, postalCode, addressOther);
                                                  QuerySnapshot<Map<String, dynamic>> snapshot =
                                                      await FirebaseFirestore.instance
                                                          .collection('products')
                                                          .where('cart', arrayContains: FirebaseAuth.instance.currentUser!.uid).where('isAvailable', isEqualTo: true)
                                                          .get();

                                                  List<DocumentSnapshot<Map<String, dynamic>>> docs = snapshot.docs;

                                                  address = "$addressOther, $street, $city, $country, $postalCode";

                                                  for (var doc in docs) {
                                                    int orderQuantity = widget.orderQuantities[doc.id] ?? 1;
                                                    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).buyProducts(doc['pid'], address, doc['price'], doc['sid'], doc['quantity'], orderQuantity);
                                                    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).addCart(doc['pid'], doc['cart']);
                                                  }
                                                  Navigator.of(context).pop();
                                                  nextScreenReplace(context, const HomePage());
                                                },
                                                icon: const Icon(Icons.done, color: Colors.green,),
                                                ),
                                              ],
                                            );
                                          });
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0XffA2CAA2),
                                      ),
                                      child: const Text('Pay with Stripe', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113)),),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10,),
                              const Padding(
                                padding: EdgeInsets.only(left: 670,),
                                child: Text("All the transactions are handled with Stripe system and are completely secure.", style: TextStyle(fontSize: 12,
                                fontWeight: FontWeight.w500, color: Color(0xff6A7769)),),
                              ),
                              const SizedBox(height: 10,),
                              const Padding(
                                padding: EdgeInsets.only(left: 670),
                                child: Text("It may take up to 5 minutes for orders to reflect in your accounts.", style: TextStyle(fontSize: 14,
                                  fontWeight: FontWeight.w500, color: Color(0xff6A7769)),),
                              ),
                            ],
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
}
