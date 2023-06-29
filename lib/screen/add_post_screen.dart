import 'dart:typed_data';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/resources/firestores_methods.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';

import '../model/user.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool isLoading = false;

  clearImage() {
    setState(() {
      _file = null;
    });
  }

  postTo(String uid, String username, String profileImage) async {
    try {
      setState(() {
        isLoading = true;
      });
      var res = await FirestoreMethods()
          .uploadPost(_descriptionController.text, _file!, username, uid, profileImage);

      if (res == 'success') {
        setState(() {
          isLoading = false;
        });
        showSnackbar(context, 'Post!');
        clearImage();
      } else {
        setState(() {
          isLoading = false;
        });
        showSnackbar(context, res);
      }
    } catch (err) {
      showSnackbar(context, err.toString());
    }
  }

  _selectImage(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) => SimpleDialog(
              title: const Text('Create post'),
              children: [
                SimpleDialogOption(
                  padding: EdgeInsets.all(20),
                  child: Text('Take a photo'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Uint8List file = await pickImage(ImageSource.camera);
                    setState(() {
                      _file = file;
                    });
                  },
                ),
                SimpleDialogOption(
                  padding: EdgeInsets.all(20),
                  child: Text('Take from gallery'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Uint8List file = await pickImage(ImageSource.gallery);
                    setState(() {
                      _file = file;
                    });
                  },
                ),
                SimpleDialogOption(
                  padding: EdgeInsets.all(20),
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Center(
            child: IconButton(
            icon: Icon(
              Icons.upload_rounded,
            ),
            onPressed: () => _selectImage(context),
          ))
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  clearImage();
                },
              ),
              title: Text('Post to'),
              actions: [
                TextButton(
                    onPressed: () => postTo(user.uid, user.username, user.photoUrl),
                    child: Text(
                      'Post',
                      style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                    ))
              ],
            ),
            body: Column(children: [
              isLoading == true
                  ? LinearProgressIndicator()
                  : Padding(padding: EdgeInsets.only(top: 0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.photoUrl),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Write something...',
                        // contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                      maxLines: 8,
                    ),
                  ),
                  SizedBox(
                    height: 45,
                    width: 45,
                    child: InkWell(
                      onTap: () => _selectImage(context),
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: MemoryImage(_file!),
                                fit: BoxFit.fill,
                                alignment: FractionalOffset.topCenter),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ]),
          );
  }
}
