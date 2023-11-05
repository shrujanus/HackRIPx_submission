import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import './record_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widget/card_widgets.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  FlutterTts flutterTts = FlutterTts();
  final CollectionReference _collectionRef = FirebaseFirestore.instance
      .collection('/users/2rmZvZAxlt1xqLsCGwL9/Pages');

  final CollectionReference _userProfileRef =
      FirebaseFirestore.instance.collection('/users');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: ElevatedButton(
        onPressed: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CameraVoiceControlPage()));
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: const Color.fromARGB(255, 245, 243, 243),
          backgroundColor: const Color.fromRGBO(
              255, 107, 107, 1), // The color of the text and icon
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          elevation: 10,
        ),
        child: const Text('Start Recording'),
      ),
      appBar: AppBar(
        title: const Text('Augma',
            style: TextStyle(fontSize: 30, color: Colors.white)),
        backgroundColor: const Color.fromRGBO(158, 197, 171, 1),
        centerTitle: true,
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: StreamBuilder<QuerySnapshot>(
                  stream: _userProfileRef.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    var documents = snapshot.data?.docs ?? [];
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        var data =
                            documents[index].data() as Map<String, dynamic>;
                        String name = data['Name'] ?? 'User';
                        print(data['ImageURL']);
                        return profile(
                          img: data['ImageURL'] ??
                              'https://i0.wp.com/chemmatcars.uchicago.edu/wp-content/uploads/2021/03/default-placeholder-image-1024x1024-1.png?resize=768%2C768&ssl=1',
                          name: name.substring(0, 6),
                        );
                      },
                    );
                  }),
            ),
            const Text(
              'Recent Scanned Data',
              style: TextStyle(fontSize: 30),
            ),
            const Divider(
              thickness: 5,
              color: Colors.white60,
            ),
            Flexible(
              fit: FlexFit.loose,
              child: StreamBuilder<QuerySnapshot>(
                // Replace 'your_collection' with the name of your Firestore collection
                stream: _collectionRef.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  var documents = snapshot.data?.docs ?? [];
                  return ListView.builder(
                    shrinkWrap: false,
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      var data =
                          documents[index].data() as Map<String, dynamic>;

                      return CardWidget(
                        jsonlocal: data['json'] ?? 'No Data Found',
                        imageUrl: data['ImageUrl'] ??
                            'https://i0.wp.com/chemmatcars.uchicago.edu/wp-content/uploads/2021/03/default-placeholder-image-1024x1024-1.png?resize=768%2C768&ssl=1',
                        title: data['date'] ?? 'Untitled',
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      )),
    );
  }
}

class profile extends StatelessWidget {
  const profile({
    super.key,
    required this.img,
    required this.name,
  });

  final String img;
  final String name;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Hello\n$name!!',
              style: TextStyle(
                fontSize: width * 0.13,
                fontWeight: FontWeight.w200,
                color: Theme.of(context).colorScheme.onPrimary,
              )),
          CircleAvatar(
            backgroundImage: NetworkImage(img),
            radius: width * 0.16666666666,
          )
        ],
      ),
    );
  }
}
