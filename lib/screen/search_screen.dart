import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_search/firestore_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/screen/comment_screen.dart';
import 'package:instagram_clone/screen/profile_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

import '../model/data_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isShowSearch = false;

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFieldInput(
          textEditingController: _searchController,
          hint: 'Search for user...',
          textInputType: TextInputType.emailAddress,
          myFunc: () {
            setState(() {
              isShowSearch = true;
            });
          },
        ),
      ),
      body: isShowSearch
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('username', isGreaterThanOrEqualTo: _searchController.text)
                  .where('username', isLessThan: '${_searchController.text} z')
                  .get(),
              builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, i) {
                      var docs = snapshot.data!.docs[i];
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: ((context) => ProfileScreen(
                                    uid: docs['uid'],
                                  ))));
                        },
                        child: ListTile(
                          leading: CircleAvatar(backgroundImage: NetworkImage(docs['photoUrl'])),
                          title: Text(docs['username']),
                        ),
                      );
                    });
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').orderBy('datePublished').get(),
              builder: ((context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                var widthDevice = MediaQuery.of(context).size.width;
                var heightPhoto = (widthDevice - 16) / 3;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return MasonryGridView.count(
                  itemCount: snapshot.data!.docs.length,
                  crossAxisCount: 3,
                  itemBuilder: ((context, index) {
                    return InkWell(
                      child: Image.network(
                        snapshot.data!.docs[index]['postUrl'],
                        fit: BoxFit.cover,
                        height: heightPhoto,
                      ),
                    );
                  }),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                );
              })),
    );
  }
}
