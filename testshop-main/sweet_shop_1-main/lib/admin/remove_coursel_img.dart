import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class RemoveCourselImg extends StatefulWidget {
  const RemoveCourselImg({super.key});

  @override
  State<RemoveCourselImg> createState() => _RemoveCourselImgState();
}

class _RemoveCourselImgState extends State<RemoveCourselImg> {
  List<Map<String, dynamic>> imgList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  Future<void> loadImages() async {
    setState(() {
      isLoading = true;
    });

    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('carousel_images').get();
      List<Map<String, dynamic>> urls = snapshot.docs
          .map((doc) => {
                'id': doc.id,
                'url': doc['url'] as String,
              })
          .toList();
      setState(() {
        imgList = urls;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error loading images: $e');
    }
  }

  Future<void> removeImage(String id, String url) async {
    setState(() {
      isLoading = true;
    });

    try {
      // Remove from Firestore
      await FirebaseFirestore.instance
          .collection('carousel_images')
          .doc(id)
          .delete();

      // Remove from Firebase Storage
      Reference storageRef = FirebaseStorage.instance.refFromURL(url);
      await storageRef.delete();

      // Update local state
      setState(() {
        imgList.removeWhere((img) => img['id'] == id);
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image removed successfully'),
        ),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error removing image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2.0,
        shadowColor: Colors.black,
        surfaceTintColor: Colors.white,
        title: Text('Remove Carousel Images'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : imgList.isEmpty
              ? Center(
                  child: Text(
                    'No images available',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: imgList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Image.network(
                        imgList[index]['url'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text('Image ${index + 1}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => removeImage(
                            imgList[index]['id'], imgList[index]['url']),
                      ),
                    );
                  },
                ),
    );
  }
}
