import 'package:flutter/material.dart';

class team extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('our team'),
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Image.asset(
              'images/team2.jpg',
                height: 340,
                width:400 ,
                fit: BoxFit.cover,
              ),
            ),
            Container(
                alignment: Alignment.center,
                child: Text(
                  'together we can',
                  style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold, fontSize: 27.0),
                )),
          ],
        ),
      ),
    );
  }
}
