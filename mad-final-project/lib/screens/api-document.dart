// import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'dart:convert';
//import 'detail.dart';
import 'dart:io';
//import 'package:restaurantapp/screens/home-screen.dart';
import 'package:restaurantapp/screens/Home_Screen.dart';

class DataFromAPI extends StatefulWidget {
  const DataFromAPI({Key? key}) : super(key: key);

  @override
  _DataFromAPIState createState() => _DataFromAPIState();
}

class _DataFromAPIState extends State<DataFromAPI> {
  Future fetchDish() async {
    var url = await http.get(
      Uri.parse(
          "http://it-assignment-three---uleoncy123.azurewebsites.net/dishes/"),
      headers: {
        HttpHeaders.authorizationHeader:
            "Token 121f1a892992e8e62903049f838552571ea02237"
      },
    );

    // return json.decode(url.body);
    var jsonData = json.decode(url.body);
    List<dishes> Dishes = [];
    for (var data in jsonData) {
      dishes dish = dishes(data["name"]);
      Dishes.add(dish);
    }
    return Dishes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Restaurant",
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'times new roman',
          ),
        ),
        backgroundColor: Color(0xFF613838),
        centerTitle: true,
        elevation: 20.0,
        actions: [
          IconButton(
            iconSize: 35.0,
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Container(
        child: Card(
          child: FutureBuilder(
              future: fetchDish(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    child: Center(
                      child: Text(
                        "$snapshot.data.error",
                        style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  );
                } else {
                  return GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 400,
                        childAspectRatio: 2 / 2,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 1,
                      ),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, i) {
                        return Text(snapshot.data[i].name);
                      });
                }
              }),
        ),
      ),
    );
  }
}

class dishes {
  final String name;

  dishes(this.name);
}
