import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';


class SecondScreen extends StatefulWidget {
  final Uint8List image;

  const SecondScreen({Key? key, required this.image}) : super(key: key);

  @override
  State<SecondScreen> createState() => _SecondScreenState();
} 

class _SecondScreenState extends State<SecondScreen> {
  Future<void> _saveImage() async {
    try {
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        final imageFileName =
            DateTime.now().millisecondsSinceEpoch.toString() + '.png';
        final imagePath = '${directory.path}/$imageFileName';
        File(imagePath).writeAsBytesSync(widget.image);
        final result = await ImageGallerySaver.saveFile(imagePath);
        if (result != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Image saved successfully'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to save image'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to access external storage'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error saving image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save image'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF27374D),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              width: 340,
              height: 500,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(25),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.memory(
                  widget.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RoundedContainerWithIcon(
                  icon: Icons.home,
                  onTap: () {
                    // Navigate to the home screen
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
                RoundedContainerWithIcon(
                  icon: Icons.save_alt_outlined,
                  onTap: _saveImage,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class RoundedContainerWithIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const RoundedContainerWithIcon({Key? key, required this.icon, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0XFF9DB2BF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Icon(
            icon,
            size: 30,
            color: Colors.black, // Change the icon color as needed
          ),
        ),
      ),
    );
  }
}
