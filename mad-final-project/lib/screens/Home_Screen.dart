//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:food_ordering_app/model/user_model.dart';
//import 'package:food_ordering_app/model/bottom_navigation_model/app_bottom_bar_item_model.dart';
//import 'package:food_ordering_app/model/item_model/MenuModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurantapp/model/bottom_navigation_model/app_bottom_bar_item_model.dart';
//import 'package:food_ordering_app/design.dart';
//import 'detail_page.dart';
//import 'LoginPage.dart';
import 'package:restaurantapp/model/user_model.dart';
import 'package:restaurantapp/screens/login-screen.dart';
import 'package:restaurantapp/screens/api-document.dart';

import "package:http/http.dart" as http;
import 'dart:convert';
import 'dart:io';
import 'package:restaurantapp/screens/design.dart';
const IconData restaurant = IconData(0xe532, fontFamily: 'MaterialIcons');

// Dash Board
class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.grey[200],
            title: const Center(
                child: Icon(Icons.fastfood_sharp, color: mainColor, size: 40)),
            actions: const [
              SizedBox(width: 40, height: 40),
            ],
            iconTheme: const IconThemeData(color: mainColor)),
        drawer: Drawer(
            child: Container(
          color: Color(0xFF613838),
          child: Container(
            color: Color(0xFF613838),
            child: SafeArea(
              child: Column(
                children: [
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/background.jpg'),
                    )),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: AssetImage('assets/logo.jpg'),
                    ),
                //      TextLogge("${dInUser.firstName} ${LoggedInUser.secondName}",
                // style: TextStyle(
                //   color: Colors.black54,
                //   fontWeight: FontWeight.w500,
                // ),),
                    accountName: null,
                    accountEmail: null,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Profile",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.article,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Review FAQs",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.favorite_border_sharp,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Favorites",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  ListTile(
                    leading: ActionChip(
                        label: Text("Logout"),
                        onPressed: () {
                          logout(context);
                        }),
                  )
                ],
              ),
            ),
          ),
        )),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            AppHeader(),
            AppSearch(),
            Expanded(child: AppDishesListView()),
            // AppCategoryList(),
            AppBottomBar()
          ],
        ));
  }
}

// dashboard widget section
class AppHeader extends StatefulWidget {
  const AppHeader({Key? key}) : super(key: key);

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 30, top: 30, right: 30),
        child: Row(
          children: [
            SizedBox(
              child: Image.asset(
                   "assets/logo.jpg",
                   width: 100,
                  height: 100,
                  fit: BoxFit.cover),
            ),
            SizedBox(width: 20),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("${loggedInUser.firstName} ${loggedInUser.secondName}",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              Text("${loggedInUser.email}",
                  style: TextStyle(color: mainColor, fontSize: 12))
            ])
          ],
        ));
  }
}

class AppSearch extends StatelessWidget {
  const AppSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Food Restaurant',
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 25,
                    color: Color(0xFF613838))),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Search Restaurants',
                        hintStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(Icons.search, color: Colors.black),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}

class AppDishesListView extends StatefulWidget {
  const AppDishesListView({Key? key}) : super(key: key);

  @override
  State<AppDishesListView> createState() => _AppDishesListViewState();
}

class _AppDishesListViewState extends State<AppDishesListView> {
  Future fetchDishes() async {
    var url = await http.get(
      Uri.parse("http://it-assignment-three---uleoncy123.azurewebsites.net/restaurants/"),
      headers: {
        HttpHeaders.authorizationHeader:
            "Token 121f1a892992e8e62903049f838552571ea02237"
      },
    );

    var jsonData = json.decode(url.body);

    List<dishes> restaurants = [];

    for (var data in jsonData) {
      dishes restaurant = dishes(
          data["name"],
          
          // data["stars"],
          // data["priceRange"],
          // data["owner"],
          // data["ownership"],
          //data["image"],
          // data["cuisines"],
          // data["description"]
          );

      //dish = Dish(data["name"], data["image"], data["price"], data["cooking_time"]);

      restaurants.add(restaurant);
    }

    return restaurants;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Card(
        child: FutureBuilder(
            future: fetchDishes(),
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
                return Container(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, i) {
                      dishes currentDishes = snapshot.data[i];

                      return GestureDetector(
                          onTap: () {
                            Navigator.push(   context,   MaterialPageRoute(builder: (context) =>DataFromAPI()));
                           // Navigator.of(context).push(MaterialPageRoute(
                              //  builder: (context) =>
                                   // DetailsPage(resto: currentDishes)));
                          },
                          child: Container(
                            alignment: Alignment.bottomLeft,
                            padding: EdgeInsets.all(15),
                            margin: EdgeInsets.all(5),
                            width: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 63,
                                    backgroundImage:AssetImage('assets/food.png'), 
                                  ),
                                  Text("Owned by: ${currentDishes.name}",
                                      style: TextStyle(
                                        color: Color(0xFF613838),
                                        fontSize: 10,
                                      )),
                                  Text("${currentDishes.name}",
                                      style: TextStyle(
                                        color: Color(0xFF613838),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ))
                                ]),
                          ));
                    },
                  ),
                );
              }
            }),
      ),
    );
  }
}

class AppBottomBar extends StatefulWidget {
  const AppBottomBar({Key? key}) : super(key: key);

  @override
  AppBottomBarState createState() => AppBottomBarState();
}

class AppBottomBarState extends State<AppBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset.zero)
        ]),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(barItems.length, (index) {
              AppBottomBarItem currentBarItem = barItems[index];

              Widget barItemWidget;

              if (currentBarItem.isSelected) {
                barItemWidget = Container(
                    padding:
                        EdgeInsets.only(left: 15, top: 5, bottom: 5, right: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: mainColor),
                    child: Row(children: [
                      Icon(currentBarItem.icon, color: Colors.white),
                      SizedBox(width: 5),
                      Text(currentBarItem.label,
                          style: TextStyle(color: Colors.white))
                    ]));
              } else {
                barItemWidget = IconButton(
                    icon: Icon(currentBarItem.icon, color: Color(0xFF613838)),
                    onPressed: () {
                      setState(() {
                        barItems.forEach((AppBottomBarItem item) {
                          item.isSelected = item == currentBarItem;
                        });
                      });
                    });
              }

              return barItemWidget;
            })));
  }
}

// the logout function
Future<void> logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
}































// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// //import 'dishessInfo.dart';
// //import 'Login_Screen.dart';
// import 'welcome.dart';
// //import 'contactus.dart';
// import 'team.dart';
// import 'login-screen.dart';
// import 'api-document.dart';
// import 'registration-screen.dart';
// class NavDrawer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: <Widget>[
//           DrawerHeader(
//             child: Text(
//               'Restaurant menus',
//               style: TextStyle(color: Colors.white, fontSize: 25),
//             ),
//             decoration: BoxDecoration(
//             color: Colors.brown,
//                 image: DecorationImage(
//                     fit: BoxFit.contain,
//                     image: AssetImage('assets/images/burger.png'))),
//           ),
//           ListTile(
//             hoverColor: Colors.lightBlue,
//             leading: Icon(Icons.input),
//             title: Text('welcome'),
//             onTap: () => { 
//               Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) =>welcome()),
//   )

//             },
//           ),
//           ListTile(
//                hoverColor: Colors.lightBlue,
//             leading: Icon(Icons.restaurant_outlined),
//             title: Text('Restaurants'),
//             onTap: () => {
              
//               Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) =>DataFromAPI()),
//   )},
//           ),
//           ListTile(
//                hoverColor: Colors.lightBlue,
//             leading: Icon(Icons.verified_user_sharp),
//             title: Text('teams'),
//             onTap: () => {
//               Navigator.push(
//          context,
//        MaterialPageRoute<void>(builder: (context) => team())
//       )},
//           ),
          
//           ListTile(
//                hoverColor: Colors.lightBlue,
//             leading: Icon(Icons.border_color),
//             title: Text('Feedback'),
//             onTap: () => {

//              // Navigator.push(
//         // context,
//        //MaterialPageRoute<void>(builder: (context) => ReachUs())
//       //)
//             },
//           ),
//           ListTile(
//                hoverColor: Colors.lightBlue,
//             leading: Icon(Icons.exit_to_app),
//             title: Text('Logout'),
//             onTap: () => {
//               Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) =>LoginScreen()),
//   )
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }




















// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title:
// //        const Text(
// //           "Restaurant",
// //         style: TextStyle(
// //             fontSize: 28.0,
// //             fontWeight: FontWeight.bold,
// //             fontFamily: 'times new roman',
// //          ),
// //         ),
// //         centerTitle: true,
// //         elevation: 20.0,
// //         actions: [
// //           IconButton(
// //             iconSize: 35.0,
// //             onPressed: () {},
// //             icon: const Icon(Icons.search),
// //           ),
// //         ],
// //       ),
// //        body: Container(
// //         child: Card(
// //           child: FutureBuilder(
// //               future: fetchDishes(),
// //               builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
// //                 if(snapshot.data == null){
// //                   return Container(
// //                     child: Center(
// //                       child: Text(
// //                           "$snapshot.data.error",
// //                           style: TextStyle(
// //                           fontSize: 22.0,
// //                           fontWeight: FontWeight.bold,
// //                           color: Colors.black),
// //                       ),
// //                     ),
// //                   );
// //                 }
// //                 else {
// //                   return GridView.builder(
// //                     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
// //                         maxCrossAxisExtent: 400,
// //                         childAspectRatio: 2 / 2,
// //                         crossAxisSpacing: 1,
// //                         mainAxisSpacing: 1,
// //                     ),

// //                     itemCount: snapshot.data.length,
// //                     itemBuilder: (context, i) {
// //                       return Text(snapshot.data[i].name);
// //                     }
// //                   );
// //                 }
// //               }
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class Dish{
// //   final String name;

// //   Dish(this.name);
// // }
















// // // import 'dart:io';

// // // import 'package:flutter/material.dart';
// // // import "package:http/http.dart" as http;
// // // import 'dart:convert';
// // // import 'dart:io';

// // // void main() {
// // //   runApp(const MyApp());
// // // }

// // // class MyApp extends StatelessWidget {
// // //   const MyApp({Key? key}) : super(key: key);

// // //   // This widget is the root of your application.
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return MaterialApp(
// // //       title: 'Fetching Api',
// // //       theme: ThemeData(
// // //         primarySwatch: Colors.blue,
// // //       ),
// // //       home:  DataFromAPI(),
// // //     );
// // //   }
// // // }

// // // class DataFromAPI extends StatefulWidget {
// // //   const DataFromAPI({Key? key}) : super(key: key);

// // //   @override
// // //   _DataFromAPIState createState() => _DataFromAPIState();
// // // }

// // // class _DataFromAPIState extends State<DataFromAPI> {
// // //   Future fetchDishes() async{
// // //     var url = await http.get(Uri.parse("https://assignment-three.azurewebsites.net/dishes/"),

// // //       // var url = await http.get(Uri.parse("https://assignment-three.azurewebsites.net/dishes/"),
// // //       headers: {
// // //         HttpHeaders.authorizationHeader:"Token 647853a00e1680ba5aae66aa8bf193943f328e38"
// // //       },);
// // //     // return json.decode(url.body);
// // //     var jsonData = json.decode(url.body);
// // //     List<Dish> dishes=[];


// // //     for(var data in jsonData){
// // //       Dish dish = Dish(data["name"], data["image"], data["price"]);
// // //       dishes.add(dish);
// // //     }
// // //     // print(dishes.length);

// // //     return dishes;
// // //   }


// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(title:
// // //         Text("Main"),
// // //       ),
// // //       body: Container(
// // //         child: Card(
// // //           child: FutureBuilder(
// // //             future: fetchDishes(),
// // //             builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
// // //               if(snapshot.data == null){
// // //                 return Container(
// // //                 child: Center(
// // //                 child: Text("Loading..."),
// // //                 ),
// // //                 );
// // //                 }
// // //               else {
// // //                 return ListView.builder(
// // //               itemCount: snapshot.data.length,
// // //               itemBuilder: (context, i){
// // //                 return ListTile(
// // //                   leading: CircleAvatar(
// // //                     child: Image.network("https://assignment-three.azurewebsites.net/dishes/"+snapshot.data[i].image),
// // //                   ),
// // //                   title: Text(snapshot.data[i].name),
// // //                   subtitle: Text(snapshot.data[i].price),
// // //                   trailing: Text(snapshot.data[i].image),
// // //                  );
// // //               });
// // //               }
// // //             }



// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }


// // // class Dish{
// // //   final String name, image, price;

// // //   Dish(this.name, this.image, this.price);
// // // }

















































// // // // import 'package:flutter/cupertino.dart';
// // // // import 'package:flutter/cupertino.dart';
// // // // import 'package:flutter/material.dart';
// // // // import "package:http/http.dart" as http;
// // // // import 'dart:convert';
// // // // import 'detail.dart';
// // // // import 'dart:io';


// // // // class DataFromAPI extends StatefulWidget {
// // // //   const DataFromAPI({Key? key}) : super(key: key);

// // // //   @override
// // // //   _DataFromAPIState createState() => _DataFromAPIState();
// // // // }

// // // // class _DataFromAPIState extends State<DataFromAPI> {
// // // //   Future fetchDishes() async{
// // // //     var url = await http.get(Uri.parse("http://stevo-api.azurewebsites.net/dishes/"));
// // // //         // return json.decode(url.body);
// // // //         var jsonData = json.decode(url.body);
// // // //         List<dishes> dishess=[];
// // // //         for(var data in jsonData){
// // // //           dishes dish = dishes(data["name"]);
// // // //           dishess.add(dish);
// // // //         }

// // // //         return dishess;
// // // //   }


// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(title:
// // // //        const Text(
// // // //           "Restaurant",
// // // //         style: TextStyle(
// // // //             fontSize: 28.0,
// // // //             fontWeight: FontWeight.bold,
// // // //             fontFamily: 'times new roman',
// // // //          ),
// // // //         ),
// // // //         centerTitle: true,
// // // //         elevation: 20.0,
// // // //         actions: [
// // // //           IconButton(
// // // //             iconSize: 35.0,
// // // //             onPressed: () {},
// // // //             icon: const Icon(Icons.search),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //        body: Container(
// // // //         child: Card(
// // // //           child: FutureBuilder(
// // // //               future: fetchDishes(),
// // // //               builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
// // // //                 if(snapshot.data == null){
// // // //                   return Container(
// // // //                     child: Center(
// // // //                       child: Text(
// // // //                           "$snapshot.data.error",
// // // //                           style: TextStyle(
// // // //                           fontSize: 22.0,
// // // //                           fontWeight: FontWeight.bold,
// // // //                           color: Colors.black),
// // // //                       ),
// // // //                     ),
// // // //                   );
// // // //                 }
// // // //                 else {
// // // //                   return GridView.builder(
// // // //                       gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
// // // //                           maxCrossAxisExtent: 400,
// // // //                           childAspectRatio: 2 / 2,
// // // //                           crossAxisSpacing: 1,
// // // //                           mainAxisSpacing: 1,
// // // //                       ),

// // // //                       itemCount: snapshot.data.length,
// // // //                       itemBuilder: (context, i) {
// // // //                         return GestureDetector(
// // // //                           onTap:(){
// // // //                             Navigator.push(
// // // //                               context,
// // // //                               MaterialPageRoute(builder: (context) => Detail(dh: snapshot.data[i])),
// // // //                             );
// // // //                           },
// // // //                           child: Card(
// // // //                               elevation: 5.0,
// // // //                               shape: RoundedRectangleBorder(
// // // //                                 borderRadius: BorderRadius.circular(10.0),
// // // //                               ),
// // // //                               child: Column(
// // // //                                 children:[
// // // //                                     Expanded(
// // // //                                       child: Text(snapshot.data[i].name,
// // // //                                         style: TextStyle(
// // // //                                             fontSize: 18.0,
// // // //                                             fontWeight: FontWeight.bold,
// // // //                                             color: Colors.black
// // // //                                         ),
// // // //                                       ),
// // // //                                     ),
// // // //                                   ]
// // // //                               )
// // // //                           ),
// // // //                         );
// // // //                       }
// // // //                   );
// // // //                 }
// // // //               }
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // // class dishes{
// // // //   final String name;

// // // //  dishes(this.name);
// // // // }





















// // // // // import 'dart:async';
// // // // // import 'dart:convert';
// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:http/http.dart' as http;

// // // // // Future<dishes> fetchdishes() async {
// // // // //   final response = await http
// // // // //       .get(Uri.parse('http://stevo-api.azurewebsites.net/dishes/'));

// // // // //   if (response.statusCode == 200) {
// // // // //     // If the server did return a 200 OK response,
// // // // //     // then parse the JSON.
// // // // //     return dishes.fromJson(jsonDecode(response.body));
// // // // //   } else {
// // // // //     // If the server did not return a 200 OK response,
// // // // //     // then throw an exception.
// // // // //     throw Exception('Failed to load dishes');
// // // // //   }
// // // // // }

// // // // // // ignore: camel_case_types
// // // // // class dishes  {
// // // // //   final int id;
// // // // //   final String name;
// // // // //   final String ingredients;
// // // // //   final Image  image;     
// // // // //   final int  price;
// // // // //   final int user;
// // // // //   final Characters cookTime;

// // // // //   dishes({
// // // // //     required this.id,
// // // // //     required this.name,
// // // // //     required this.ingredients,
// // // // //     required this.image,
// // // // //     required this.price,
// // // // //     required this.user,
// // // // //     required this.cookTime,
    

// // // // //   });

// // // // //   factory dishes.fromJson(Map<String, dynamic> json) {
// // // // //     return dishes(
// // // // //       id: json['id'],
// // // // //       name: json['name'],
// // // // //       ingredients: json['ingredients'],
// // // // //        image: json['image'],
// // // // //        price: json['price'],
// // // // //           user: json['user'],
// // // // //         cookTime: json['cooktime'],
      
// // // // //     );
// // // // //   }
  
// // // // // }

// // // // // void main() => runApp(const MyApp());

// // // // // class MyApp extends StatefulWidget {
// // // // //   const MyApp({Key? key}) : super(key: key);

// // // // //   @override
// // // // //   _MyAppState createState() => _MyAppState();
// // // // // }

// // // // // class _MyAppState extends State<MyApp> {
// // // // //   late Future<dishes> futuredishes;

// // // // //   @override
// // // // //   void initState() {
// // // // //     super.initState();
// // // // //     futuredishes = fetchdishes();
// // // // //   }

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return MaterialApp(
// // // // //       title: 'Information About Dishes',
// // // // //       theme: ThemeData(
// // // // //         primarySwatch: Colors.blue,
// // // // //       ),
// // // // //       home: Scaffold(
// // // // //         appBar: AppBar(
// // // // //           title: const Text('Information About Dishes'),
// // // // //         ),
// // // // //         body: Center(
// // // // //           child: FutureBuilder<dishes>(
// // // // //             future: futuredishes,
// // // // //             builder: (context, snapshot) {
// // // // //               if (snapshot.hasData) {
// // // // //                 return Text(snapshot.data!.name);
// // // // //               } else if (snapshot.hasError) {
// // // // //                 return Text('${snapshot.error}');
// // // // //               }






// // // // //               // By default, show a loading spinner.
// // // // //               return const CircularProgressIndicator();
// // // // //             },
// // // // //           ),
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }












// // import 'dart:io';

// // import 'package:flutter/material.dart';
// // import "package:http/http.dart" as http;
// // import 'dart:convert';
// // import 'dart:io';

// // class Philippe extends StatelessWidget {
// //   const Philippe({Key? key}) : super(key: key);

// //   // This widget is the root of your application.
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Fetching Api',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //       ),
// //       home:  DataFromAPI(),
// //     );
// //   }
// // }

// // class DataFromAPI extends StatefulWidget {
// //   const DataFromAPI({Key? key}) : super(key: key);

// //   @override
// //   _DataFromAPIState createState() => _DataFromAPIState();
// // }

// // class _DataFromAPIState extends State<DataFromAPI> {
// //   Future fetchDishes() async{
// //     var url = await http.get(Uri.parse("http://philly-restaurant-api.azurewebsites.net/dishes/"),

// //       headers: {
// //         HttpHeaders.authorizationHeader:"Token fcd8e8558754e92d3f0bb8ffc409f5fab618d0a5"
// //       },);
// //     // return json.decode(url.body);
// //     var jsonData = json.decode(url.body);
// //     List<Dish> dishes=[];


// //     for(var data in jsonData){
// //       Dish dish = Dish(data["name"]);
// //       dishes.add(dish);
// //     }
// //     // print(dishes.length);

// //     return dishes;
// //   }


// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title:
// //         Text("Main"),
// //       ),
// //       body: Container(
// //         child: Card(
// //           child: FutureBuilder(
// //             future: fetchDishes(),
// //             builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
// //               if(snapshot.data == null){
// //                 return Container(
// //                 child: Center(
// //                 child: Text("$snapshot.data.error"),
// //                 ),
// //                 );
// //                 }
// //               else {
// //                 return ListView.builder(
// //               itemCount: snapshot.data.length,
// //               itemBuilder: (context, i){
// //                 return ListTile(
// //                   leading: CircleAvatar(
// //                      child: Image.network("https://assignment-three.azurewebsites.net/dishes/"+snapshot.data[i].image),
// //                   ),
// //                   title: Text(snapshot.data[i].name),
// //                   // subtitle: Text(snapshot.data[i].price),
// //                   // trailing: Text(snapshot.data[i].image),
// //                  );
// //               });
// //               }
// //             }



// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }


// // class Dish{
// //   final String name;

// //   Dish(this.name);
// // }
