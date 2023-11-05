import 'package:flutter/material.dart';
import '../screens/speeck_screen.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.jsonlocal,
  });

  final String imageUrl;
  final String title;
  final String jsonlocal;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Speek(jsonData: jsonlocal),
            ));
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 150,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                color: Colors.black.withOpacity(0.5),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
