// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:image_picker_web/image_picker_web.dart';
// import 'package:http/http.dart' as http;

// class BannerScreen extends StatefulWidget {
//   const BannerScreen({Key? key}) : super(key: key);

//   @override
//   _BannerScreenState createState() => _BannerScreenState();
// }

// class _BannerScreenState extends State<BannerScreen> {
//   Uint8List? _fileBytes;
//   Image? _imageWidget;
//   bool _isLoading = false;
//   String _message = '';

//   void _pickImage() async {
//     try {
//       final mediaData = await ImagePickerWeb.getImageInfo;
//       if (mediaData != null) {
//         setState(() {
//           _fileBytes = mediaData.data;
//           _imageWidget = Image.memory(mediaData.data!);
//           _message = 'Selected: ${mediaData.fileName}';
//         });
//       } else {
//         setState(() {
//           _message = 'No image selected';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _message = 'Error picking image: $e';
//       });
//     }
//   }

//   void _uploadImage() async {
//     if (_fileBytes == null) {
//       setState(() {
//         _message = 'No image selected';
//       });
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _message = 'Uploading...';
//     });

//     try {
//       final url = Uri.parse('http://localhost:5000/v1/banner/addBanner');
//       final request = http.MultipartRequest('POST', url);

//       // Determine file extension and set content type
//       String contentType = 'image/jpeg'; // Default to JPEG
//       if (_imageWidget != null && _imageWidget!.image!.bytesFormat != null) {
//         switch (_imageWidget!.image!.bytesFormat!) {
//           case ImageByteFormat.png:
//             contentType = 'image/png';
//             break;
//           case ImageByteFormat.gif:
//             contentType = 'image/gif';
//             break;
//           // Add more cases as needed
//         }
//       }

//       request.files.add(http.MultipartFile.fromBytes(
//         'image',
//         _fileBytes!,
//         filename: 'image.jpg', // Adjust filename as needed
//         contentType: MediaType('image', contentType),
//       ));

//       final response = await request.send();
//       if (response.statusCode == 200) {
//         final responseString = await response.stream.bytesToString();
//         setState(() {
//           _isLoading = false;
//           _message = 'Upload successful: $responseString';
//         });
//       } else {
//         setState(() {
//           _isLoading = false;
//           _message = 'Upload failed with status: ${response.statusCode}';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _message = 'Upload failed: $e';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Banner Screen'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (_imageWidget != null) _imageWidget!,
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _pickImage,
//               child: const Text('Pick Image'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _uploadImage,
//               child: _isLoading
//                   ? CircularProgressIndicator()
//                   : const Text('Upload Image'),
//             ),
//             const SizedBox(height: 20),
//             Text(_message),
//           ],
//         ),
//       ),
//     );
//   }
// }
