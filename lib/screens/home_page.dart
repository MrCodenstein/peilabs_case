import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peilabs_project/core/models/product.dart';
import 'package:peilabs_project/screens/search_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List data = [];
  List<Product> titles = [];
  List<Product> allItems = [];
  Map<Product, List<Product>> items = {};
  ScrollController scrollCtrl = ScrollController();

  Future<String> loadJsonData() async {
    var jsonText = await rootBundle.loadString('assets/jsonArray.json');
    setState(() => this.data = json.decode(jsonText));
    await setItems;
    return 'success';
  }

  Future get setTitles async {
    for (var temp in data) {
      allItems.add(Product.fromJson(temp));
      if (temp["parentId"] == null) {
        titles.add(Product.fromJson(temp));
        Map<Product, List<Product>> newItem = {Product.fromJson(temp): []};
        items.addEntries(newItem.entries);
      }
    }
  }

  Future get setItems async {
    await setTitles;
    for (var temp in data) {
      if (temp["parentId"] != null) {
        for (Product item in items.keys) {
          if (item.id == temp["parentId"]) {
            items.update(
              item,
              (value) {
                value.add(Product.fromJson(temp));
                return value;
              },
            );
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    this.loadJsonData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue[300],
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height,
                width: size.width,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        color: Colors.white,
                        height: size.height * 0.75,
                        width: size.width,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: size.height * 0.50),
                      child: ListView.builder(
                        itemCount: titles.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          int itemPixels = 0;
                          int categoriesPixels = 0;
                          double jumpPixels = 0;
                          for (var item in items.keys) {
                            if (titles[index].id == item.id) {
                              jumpPixels = (itemPixels * (size.width * 0.325)) +
                                  (categoriesPixels * 35);
                              break;
                            }
                            itemPixels += items[item]!.length;
                            categoriesPixels++;
                          }
                          return Row(
                            children: [
                              SizedBox(
                                width: 25,
                              ),
                              GestureDetector(
                                onTap: () {
                                  scrollCtrl.animateTo(jumpPixels,
                                      curve: Curves.easeInQuart,
                                      duration: Duration(milliseconds: 600));
                                },
                                child: Container(
                                  height: size.width * 0.28,
                                  width: size.width * 0.28,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    image: DecorationImage(
                                        image:
                                            NetworkImage(titles[index].picture),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: size.height * 0.34,
                          left: size.width * 0.04,
                          right: size.width * 0.04),
                      child: ListView.builder(
                        controller: scrollCtrl,
                        padding: EdgeInsets.only(top: 0),
                        itemCount: items.keys.length,
                        itemBuilder: (BuildContext context, int index) {
                          List<Product>? subItems;
                          for (var item in items.keys) {
                            if (item.id == titles[index].id) {
                              subItems = items[item];
                            }
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(titles[index].name,
                                  style: Theme.of(context).textTheme.headline5),
                              ListView.builder(
                                padding: EdgeInsets.only(top: 0),
                                physics: ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: subItems?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    margin: EdgeInsets.all(10),
                                    elevation: 5,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: Image.network(
                                                      subItems![index].picture),
                                                );
                                              },
                                            );
                                          },
                                          child: Image.network(
                                            subItems![index].picture,
                                            height: size.width * 0.28,
                                            width: size.width * 0.28,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(subItems[index].name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6)
                                      ],
                                    ),
                                  );
                                },
                              )
                            ],
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white60,
                            borderRadius: BorderRadius.circular(35)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => SearchPage(
                                    allItems: allItems,
                                  ),
                                ),
                              );
                            },
                            child: ListTile(
                              title: TextField(
                                enabled: false,
                                autofocus: false,
                                decoration: InputDecoration(
                                  hintText: "Ara",
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                ),
                                style: TextStyle(fontSize: 20),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          SearchPage(
                                        allItems: allItems,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
