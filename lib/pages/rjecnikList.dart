import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import '../database/database.dart';
import '../models/rjecnik.dart';
import 'rjecnikDetail.dart';

class RjecnikList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RjecnikListState();
  }
}

class RjecnikListState extends State<RjecnikList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Rjecnik> rjecnikList;

  int count = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (rjecnikList == null) {
      rjecnikList = List<Rjecnik>();
      updateListView();
    }
    setState(() {
      updateListView();
    });
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xfff015dad),
          title: Text('Lista izraza'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Dodaj izraz',
              onPressed: () {
                Navigator.of(context).pushNamed('/rjecnikdetail');
              },
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(child: count == 0 ? Container() : getRjecnikListView()),
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
            ),
          ],
        ));
  }

  ListView getRjecnikListView() {
    //  TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return SafeArea(
            child: SingleChildScrollView(
          child: ListTile(
            leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right:
                          new BorderSide(width: 1.0, color: Colors.white24))),
              child: Text(
                this.rjecnikList[position].grp.substring(0, 1).toUpperCase(),
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            title: Text(
              this.rjecnikList[position].title,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            trailing: GestureDetector(
              child: Container(
                  padding: EdgeInsets.only(left: 12.0),
                  decoration: new BoxDecoration(
                      border: new Border(
                          left: new BorderSide(
                              width: 1.0, color: Colors.white24))),
                  child: IconButton(
                    icon: new Icon(
                      Icons.mode_edit,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      navigateToDetail(
                          this.rjecnikList[position], 'Edit Links');
                    },
                  )),
            ),
          ),
        ));
      },
    );
  }

  void navigateToDetail(Rjecnik rjecnik, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RjecnikDetail(rjecnik, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Rjecnik>> rjecnikListFuture =
          databaseHelper.getRjecnikList('word');
      rjecnikListFuture.then((rjecnikList) {
        setState(() {
          this.rjecnikList = rjecnikList;
          this.count = rjecnikList.length;
        });
      });
    });
  }
}
