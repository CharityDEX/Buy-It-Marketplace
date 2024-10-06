import 'package:eatit/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:eatit/review_card.dart';
import 'package:eatit/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewsScreen extends StatefulWidget {
  final snap;
  const ReviewsScreen({super.key, required this.snap});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {

  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _reviewController.dispose();
  }

  String userName = "";
  String userPicURL = "";

  @override
  void initState() {
    getUserData();
    super.initState();
  }

   getUserData()async{
    final userDocumentSnapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    setState(() {
      userName = userDocumentSnapshot['userName'];
      userPicURL = userDocumentSnapshot['profilePic'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.grey.shade200,
        title: Text("Reviews", style: TextStyle(color: Colors.green.shade900, fontSize: 27,),),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('products').doc(widget.snap['pid']).collection('reviews').orderBy('datePublished', descending: true).snapshots(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context, index) => ReviewCard(
              snap: (snapshot.data! as dynamic).docs[index].data()
            ));
        },
      ),
      bottomNavigationBar: SafeArea(child: 
      Container(
        height: kToolbarHeight,
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(userPicURL,
              ),
              radius: 18,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8,),
                child: TextField(
                  controller: _reviewController,
                  decoration: InputDecoration(
                    hintText: "Review as $userName",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () async{
                if(_reviewController.text.isEmpty)
                {
                  showSnackbar(context, Colors.red, "Please enter your review");
                }
                else{
                  await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).postReview(widget.snap['pid'], _reviewController.text, FirebaseAuth.instance.currentUser!.uid, userName, userPicURL);
                setState(() {
                  _reviewController.text = "";
                });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: const Text("Post", style: TextStyle(color: Colors.blueAccent),),
              ),
            )
          ],
        ),
      )
      ),
    );
  }
}