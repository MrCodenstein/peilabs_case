import 'package:flutter/material.dart';
import 'package:peilabs_project/core/models/product.dart';

// ignore: must_be_immutable
class SearchPage extends StatefulWidget {
  List<Product> allItems;
  SearchPage({required this.allItems});
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Product> allItems = [];
  List<Product> tempList = [];
  TextEditingController txtCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    allItems = widget.allItems;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white60,
                    borderRadius: BorderRadius.circular(35)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: ListTile(
                    title: TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: "Ara",
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                      style: TextStyle(fontSize: 20),
                      onChanged: (value) {
                        tempList.clear();
                        setState(() {
                          allItems.forEach((element) {
                            if (element.name
                                .toLowerCase()
                                .contains(value.toLowerCase())) {
                              tempList.add(element);
                            }
                          });
                        });
                      },
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        tempList.clear();
                        setState(() {
                          allItems.forEach((element) {
                            if (element.name
                                .toLowerCase()
                                .contains(txtCtrl.text.toLowerCase())) {
                              tempList.add(element);
                            }
                          });
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              child: ListView.builder(
                  itemCount: tempList.length,
                  itemBuilder: (BuildContext contex, int index) {
                    return Card(
                      color: tempList[index].parentId == -1
                          ? Colors.blue[100]
                          : Colors.white,
                      margin: EdgeInsets.all(10),
                      elevation: 5,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content:
                                        Image.network(tempList[index].picture),
                                  );
                                },
                              );
                            },
                            child: Image.network(
                              tempList[index].picture,
                              height: tempList[index].parentId == -1
                                  ? size.width * 0.15
                                  : size.width * 0.28,
                              width: size.width * 0.28,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(tempList[index].name,
                              style: Theme.of(context).textTheme.headline6)
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
