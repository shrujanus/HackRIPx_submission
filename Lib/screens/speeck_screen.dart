import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Speek extends StatefulWidget {
  const Speek({super.key, required this.jsonData});

  @override
  _SpeekState createState() => _SpeekState();
  final String jsonData;
}

class _SpeekState extends State<Speek> {
  final FlutterTts flutterTts = FlutterTts();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    initializeTts();
  }

  void initializeTts() {
    flutterTts.setStartHandler(() {
      setState(() {
        isPlaying = true;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
      });
    });

    flutterTts.setPauseHandler(() {
      setState(() {
        isPlaying = false;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        isPlaying = true;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        isPlaying = false;
      });
    });
  }

  Future<void> _readJson() async {
    if (!isPlaying) {
      await flutterTts.setLanguage("en-US");
      await flutterTts.speak(widget.jsonData);
    }
  }

  Future<void> _stopReading() async {
    await flutterTts.stop();
  }

  Future<void> _pauseReading() async {
    await flutterTts.pause();
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: isPlaying ? null : _readJson,
              child: Container(
                color: Colors.yellow,
                child: const Center(
                  child: Text(
                    'START',
                    style: TextStyle(
                        fontSize: 54,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: isPlaying ? _pauseReading : null,
              child: Container(
                color: Colors.green,
                child: const Center(
                  child: Text(
                    'PAUSE',
                    style: TextStyle(
                        fontSize: 54,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
