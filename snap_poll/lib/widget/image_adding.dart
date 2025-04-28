import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../global/colors.dart';

class ImageAdding extends StatefulWidget {
  const ImageAdding({super.key});

  @override
  State<ImageAdding> createState() => _ImageAddingState();
}

class _ImageAddingState extends State<ImageAdding> {
  File? file;
  ImagePicker image = ImagePicker();
  UploadTask? uploadTask;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsX.appBarColor,
        title: Text("Adding Image"),
      ),
      body: Center(
        child: Column(children: [
          Container(
            height: 480,
            width: 280,
            color: Colors.black12,
            child: file == null
                ? const Icon(
                    Icons.image,
                    size: 50,
                  )
                : Image.file(file!, fit: BoxFit.fill),
          ),
          MaterialButton(
            onPressed: () {
              getgallery();
            },
            color: ColorsX.appBarColor,
            child: const Text(
              "Take from Gallery",
              style: TextStyle(color: Colors.white),
            ),
          ),
          MaterialButton(
            onPressed: () {
              getcam();
            },
            color: ColorsX.appBarColor,
            child: const Text(
              "Take from Camera",
              style: TextStyle(color: Colors.white),
            ),
          ),
          MaterialButton(
            onPressed: () {
              uploadFile();
            },
            color: ColorsX.appBarColor,
            child: const Text(
              "Upload Image",
              style: TextStyle(color: Colors.white),
            ),
          )
        ]),
      ),
    );
  }

  getcam() async {
    var img = await image.pickImage(source: ImageSource.camera);
    setState(() {
      file = File(img!.path);
    });
  }

  getgallery() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });
  }

  Future uploadFile() async {
    String filename = basename(file!.path);
    final path = 'files/$filename';
    final file2 = File(file!.path);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file2);

    final snapshot = await uploadTask!.whenComplete(() => {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download Link : $urlDownload');
  }

  Future DeleteFile(String URL) async {
    // Create a reference to the file to delete
    final storageRef = FirebaseStorage.instance.refFromURL(URL);
    //final desertRef = storageRef.child("images/desert.jpg");

// Delete the file
    await storageRef.delete();
  }
}
