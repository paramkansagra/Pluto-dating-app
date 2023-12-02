import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  File? _image;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    // final picker = ImagePicker();
    // final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final url = Uri.parse(
          'https://v2.convertapi.com/convert/jpeg/to/webp?Secret=Azn3Aiu5CC1blHh7');
      final request = http.MultipartRequest('POST', url);
      request.files
          .add(await http.MultipartFile.fromPath('File', _image!.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final finalResponse =
            await response.stream.transform(utf8.decoder).join();
        var jsonBody = json.decode(finalResponse);
        log(jsonBody["Files"][0]);
        log('Image uploaded successfully');

        // Handle successful response
      } else {
        log('Image upload failed with status code: ${response.statusCode}');
        final responseString = response.stream.bytesToString.toString();
        log('Response body: $responseString');
        // Handle error response
      }
    } catch (e) {
      log('Error uploading image: $e');
      // Handle error
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Select Image'),
            ),
            const SizedBox(height: 16),
            if (_image != null)
              Image.file(
                _image!,
                height: 200,
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isUploading ? null : _uploadImage,
              child: _isUploading
                  ? const CircularProgressIndicator()
                  : const Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}

// class ImageUploadScreen extends StatefulWidget {
//   @override
//   _ImageUploadScreenState createState() => _ImageUploadScreenState();
// }

// class _ImageUploadScreenState extends State<ImageUploadScreen> {
//   File? selectedImage;

//   Future<void> pickImage() async {
//     final ImagePicker _picker = ImagePicker();
//     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

//     if (image != null) {
//       setState(() {
//         selectedImage = File(image.path);
//       });
//     }
//   }

//   Future<void> uploadImage() async {
//     final url = Uri.parse(
//         'https://v2.convertapi.com/convert/jpeg/to/webp?Secret=Azn3Aiu5CC1blHh7');

//     final request = http.MultipartRequest('POST', url);
//     request.files
//         .add(await http.MultipartFile.fromPath('File', selectedImage!.path));

//     final response = await request.send();

//     if (response.statusCode == 200) {
//       // Image uploaded successfully
//       log('Image uploaded');
//       final responseString = await response.stream.bytesToString();
//       log('Response body: $responseString');
//     } else {
//       // Error occurred during image upload
//       log('Image upload failed');
//       log(response.statusCode);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image Upload'),
//       ),
//       body: Column(
//         children: [
//           ElevatedButton(
//             onPressed: pickImage,
//             child: Text('Select Image'),
//           ),
//           ElevatedButton(
//             onPressed: (selectedImage != null) ? uploadImage : null,
//             child: Text('Upload Image'),
//           ),
//         ],
//       ),
//     );
//   }
// }
