import 'package:eatit_dev/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:eatit_dev/widgets/widgets.dart';
import 'package:eatit_dev/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eatit_dev/pages/cart_page.dart';
import 'package:eatit_dev/pages/home_page.dart';
import 'package:eatit_dev/pages/search_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;  // Import to detect platform
import 'package:firebase_storage/firebase_storage.dart';

class ContactUsPage extends StatefulWidget {
  final String userName;
  final String email;
  final String uid;
  const ContactUsPage({super.key, required this.userName, required this.email, required this.uid});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  String subject = "";
  String description = "";
  XFile? _image;
  String? _imageUrl;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      showSnackbar(context, Colors.green, "Uploading image, this may take a few seconds");
      setState(() {
        _image = pickedFile;
      });
      if (kIsWeb) {  // Check if the platform is web
        // Upload the image to Firebase Storage and get the URL for web display
        final ref = FirebaseStorage.instance.ref().child('images/${DateTime.now().toIso8601String()}');
        await ref.putData(await pickedFile.readAsBytes());
        _imageUrl = await ref.getDownloadURL();
        setState(() {});
      }
    }
  }

  void _removeImage() {
    setState(() {
      _image = null;
      _imageUrl = null;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 5,),),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 5,),),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Contact Support",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10,),
                        const Text("Fill in the form about your issue and we will get back to you via e-mail.", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),),
                        const SizedBox(height: 50,),
                        Container(
                          width: 416,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xffF8F8F8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            onChanged: (val) {
                              setState(() {
                                subject = val;
                              });
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelText: "Issue subject",
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          width: 416,
                          height: 112,
                          decoration: BoxDecoration(
                            color: const Color(0xffF8F8F8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            children: [
                              TextField(
                                onChanged: (val) {
                                  setState(() {
                                    description = val;
                                  });
                                },
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  labelText: "Other",
                                ),
                                maxLines: 3,
                              ),
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: TextButton.icon(
                                  onPressed: _pickImage,
                                  icon: const Icon(Icons.attach_file, color: Colors.black,),
                                  label: const Text(""),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildImageSection(),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    ElevatedButton(
                      onPressed: () {
                        if(subject != "" && description != "")
                        {
                          DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).createSupportTicket(
                          widget.uid, widget.userName, widget.email, subject, description, _image);
                        showSnackbar(context, Colors.green, "Your support ticket has been created successfully");
                        nextScreenReplace(context, const ProfilePage());
                        }
                        else
                        {
                          showSnackbar(context, Colors.red, "Please fill all the fields properly");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0XffA2CAA2),
                      ),
                      child: const Text('Send', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff123113)),),
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

  Widget _buildImageSection() {
    if (kIsWeb) {
      return _imageUrl == null
          ? SizedBox.shrink()
          : Stack(
              children: [
                Image.network(_imageUrl!, height: 100),
                Positioned(
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Color(0xffBEBEBE)),
                    onPressed: _removeImage,
                  ),
                ),
              ],
            );
    } else {
      return _image == null
          ? SizedBox.shrink()
          : Stack(
              children: [
                Image.file(File(_image!.path), height: 100),
                Positioned(
                  right: 0,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.red),
                    onPressed: _removeImage,
                  ),
                ),
              ],
            );
    }
  }
}
