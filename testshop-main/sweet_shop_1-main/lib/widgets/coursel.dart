import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ComplicatedImageDemo extends StatefulWidget {
  @override
  State<ComplicatedImageDemo> createState() => _ComplicatedImageDemoState();
}

class _ComplicatedImageDemoState extends State<ComplicatedImageDemo> {
  List<String> imgLt = [];
  bool isLoading = false;

  List<Widget> imageSliders = [];

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  List<Widget> generateImageSliders() {
    return imgLt
        .map(
          (item) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              child: Stack(
                children: <Widget>[
                  Image.network(
                    item,
                    fit: BoxFit.cover,
                    width: 1000.0,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey,
                        child: Center(
                          child: Text(
                            'Image not available',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(200, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  Future<void> loadImages() async {
    setState(() {
      isLoading = true;
    });

    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('carousel_images').get();
      List<String> urls =
          snapshot.docs.map((doc) => doc['url'] as String).toList();
      setState(() {
        imgLt = urls;
        imageSliders = generateImageSliders();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error loading images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : imgLt.isEmpty
              ? Center(
                  child: Text(
                    'No images available',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : CarouselSlider(
                  options: CarouselOptions(
                    viewportFraction: 0.95,
                    autoPlay: true,
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                  ),
                  items: imageSliders,
                ),
    );
  }
}
