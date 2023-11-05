import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;

class CameraVoiceControlPage extends StatefulWidget {
  const CameraVoiceControlPage({super.key});

  @override
  _CameraVoiceControlPageState createState() => _CameraVoiceControlPageState();
}

class _CameraVoiceControlPageState extends State<CameraVoiceControlPage> {
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeTTS();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.high);
    await _cameraController.initialize();
    setState(() {});
  }

  void _initializeTTS() {
    flutterTts.speak(
        "Please position the document in the frame and press button to take the photo.");
  }

  Future<void> _takePicture() async {
    if (!_cameraController.value.isInitialized ||
        _cameraController.value.isTakingPicture) {
      return;
    }

    try {
      final XFile image = await _cameraController.takePicture();
      final String filePath = await _saveImageAndGetPath(image);

      var response = await _sendImage(filePath);

      if (response.statusCode == 200) {
        print('Image uploaded successfully');
        print(response.body);
        Navigator.of(context).pop(); // Go back to the previous screen
      } else {
        print('Failed to upload image: ${response.body}');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> _saveImageAndGetPath(XFile image) async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_voice_camera';
    await Directory(dirPath).create(recursive: true);
    final String filePath =
        '$dirPath/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';
    await image.saveTo(filePath);
    print('Picture saved to $filePath');
    return filePath;
  }

  Future<http.Response> _sendImage(String filePath) async {
    var uri =
        Uri.parse('https://eabe-100-4-219-223.ngrok-free.app/detect-text');
    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', filePath));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      print('Upload successful');
    } else {
      print('Upload failed with status: ${response.statusCode}');
    }

    // Print and return the body of the response from the server
    print('Response from server: ${response.body}');
    return response;
  }

  @override
  void dispose() {
    _cameraController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraController.value.isInitialized) {
      return Container(
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Voice Control'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CameraPreview(_cameraController),
          Positioned(
            bottom: 20,
            child: FloatingActionButton(
              child: const Icon(Icons.camera),
              onPressed: () {
                print('Manual capture initiated');
                _takePicture();
              },
            ),
          ),
        ],
      ),
    );
  }
}
