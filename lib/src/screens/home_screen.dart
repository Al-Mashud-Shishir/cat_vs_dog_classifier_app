import 'dart:io';

import 'package:cat_dog_classifier/src/widgets/home_btn_widget.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = true;
  File _image;
  List _output;
  final picker = ImagePicker();

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _output = output;
    });
  }

  loadModel() async {
    String res;
    try {
      res = await Tflite.loadModel(
          model: "assets/models/model_unquant.tflite",
          labels: "assets/models/labels.txt",
          numThreads: 1);
      print(res);
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Tflite.close();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadModel().then((val) {
      setState(() {
        loading = false;
      });
    });
  }

  pickImage(bool camera) async {
    var image;
    setState(() {
      _image = null;
      _output = null;
    });

    if (camera == true) {
      try {
        image = await picker.getImage(source: ImageSource.camera);
      } catch (e) {
        print(e);
      }
    } else {
      image = await picker.getImage(source: ImageSource.gallery);
    }
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        elevation: 0,
        title: Text(
          'Detect Dogs vs Cats',
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
      ),
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: _image == null
                      ? Image.asset("assets/images/cat.jpg")
                      : Image.file(_image),
                ),
                SizedBox(
                  height: 35.0,
                ),
                _output != null
                    ? Text(
                        'Predicted: ${_output[0]["label"].split(" ")[1].toUpperCase()}',
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      )
                    : Text(
                        'Predicted: CAT',
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                SizedBox(
                  height: 35.0,
                ),
                HomeBtnWidget(
                  icon: Icon(Icons.camera_alt),
                  text: "Take a photo",
                  fn: () => pickImage(true),
                ),
                SizedBox(
                  height: 35.0,
                ),
                HomeBtnWidget(
                    icon: Icon(Icons.image_rounded),
                    text: "Select image from gallery",
                    fn: () => pickImage(false)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
