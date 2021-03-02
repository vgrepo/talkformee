import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/rjecnik.dart';
import '../database/database.dart';

class RjecnikDetail extends StatefulWidget {
  final String appBarTitle;
  final Rjecnik rjecnik;

  RjecnikDetail(this.rjecnik, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return RjecnikDetailState(this.rjecnik, this.appBarTitle);
  }
}

class RjecnikDetailState extends State<RjecnikDetail> {
  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Rjecnik rjecnik;
  bool _validateTitle = true;
  bool _validateGrp = true;
  bool _validateLng = true;

  TextEditingController grpController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController lngController = TextEditingController();

  RjecnikDetailState(this.rjecnik, this.appBarTitle);

  @override
  initState() {
    super.initState();
    // Add listeners to this class
  }

  @override
  Widget build(BuildContext context) {
    titleController.text = rjecnik.title;
    grpController.text = rjecnik.grp;
    lngController.text = rjecnik.lng;
    return Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          backgroundColor: Color(0xfff015dad),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                // Write some code to control things, when user press back button in AppBar
                moveToLastScreen();
              }),
        ),
        body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(children: <Widget>[
              // Second Element
              Padding(
                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: TextField(
                  controller: lngController,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  onChanged: (value) {
                    updateLng();
                  },
                  decoration: InputDecoration(
                    labelText: 'Jezik',
                    errorText: _validateLng ? null : 'Value Can\'t Be Empty',
                    labelStyle: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 1.0),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: TextField(
                  controller: grpController,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  onChanged: (value) {
                    updateGrp();
                  },
                  decoration: InputDecoration(
                    labelText: 'Grupa',
                    errorText: _validateGrp ? null : 'Value Can\'t Be Empty',
                    labelStyle: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 1.0),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: TextField(
                  controller: titleController,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  onChanged: (value) {
                    updateTitle();
                  },
                  decoration: InputDecoration(
                    labelText: 'Izraz',
                    errorText: _validateTitle ? null : 'Value Can\'t Be Empty',
                    labelStyle: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 1.0),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        //color: Color(0xff015dad),
                        textColor: Colors.white,
                        child: Text(
                          'Save',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            titleController.text.isEmpty
                                ? _validateTitle = false
                                : _validateTitle = true;
                            grpController.text.isEmpty
                                ? _validateGrp = false
                                : _validateGrp = true;
                          });
                          if (_validateTitle == true && _validateGrp == true) {
                            showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Confirmation"),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                              "Are you sure you want to save link?")
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      new FlatButton(
                                        child: new Text('Yes'),
                                        onPressed: () {
                                          Navigator.pop(context, true);
                                          _save();
                                        },
                                      ),
                                      new FlatButton(
                                        child: new Text('No'),
                                        onPressed: () {
                                          Navigator.pop(
                                              context); //Quit to previous screen
                                        },
                                      ),
                                    ],
                                  );
                                });
                          }
                        },
                      ),
                    ),
                    Container(
                      width: 5.0,
                    ),
                    Expanded(
                      child: RaisedButton(
                        //color: Color(0xff015dad),
                        textColor: Colors.white,
                        child: Text(
                          'Delete',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Confirmation"),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text(
                                            "Are you sure you want to delete link?")
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    new FlatButton(
                                      child: new Text('Yes'),
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                        _delete();
                                      },
                                    ),
                                    new FlatButton(
                                      child: new Text('No'),
                                      onPressed: () {
                                        Navigator.pop(
                                            context); //Quit to previous screen
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ])));
  }

  void updateTitle() {
    rjecnik.title = titleController.text;
  }

  void updateLng() {
    rjecnik.lng = lngController.text;
  }

  void updateGrp() {
    rjecnik.grp = grpController.text;
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void _save() async {
    moveToLastScreen();
    int result;

    if (rjecnik.id != null) {
      // Case 1: Update operation
      result = await helper.updateRjecnik(rjecnik);
    } else {
      // Case 2: Insert Operation
      result = await helper.insertRjecnik(rjecnik);
    }

    if (result != 0) {
      // Success
      //   _showAlertDialog('Status', 'Record Saved Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Record');
    }
  }

  void _delete() async {
    moveToLastScreen();

    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (rjecnik.id == null) {
      _showAlertDialog('Status', 'No Links was deleted');
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await helper.deleteRjecnik(rjecnik.id);
    if (result != 0) {
      // _showAlertDialog('Status', 'Links Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Links');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
