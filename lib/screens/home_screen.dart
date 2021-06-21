import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  final User currentUser;
  HomeScreen({Key key, this.currentUser}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _taskTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTaskDialog();
        },
        child: Icon(Icons.playlist_add),
        elevation: 5,
      ),
      bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  _auth.signOut();
                },
              ),
            ],
          )),
      body: Container(
        child: StreamBuilder(
          stream: _firestore
              .collection("users")
              .doc(widget.currentUser.uid)
              .collection("tasks")
              .orderBy("date_time", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.docs.isNotEmpty) {
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                    itemBuilder: (context, i) {
                      return ListTile(
                        title: Text("${snapshot.data.docs[i].data()['task']}"),
                        onTap: () {},
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete_forever_outlined,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            print(snapshot.data.docs[i].id);
                            _firestore
                                .collection("users")
                                .doc(widget.currentUser.uid)
                                .collection("tasks")
                                .doc(snapshot.data.docs[i].id)
                                .delete();
                          },
                        ),
                      );
                    });
              } else {
                return Container(
                    child: Center(
                  child: Text(
                    "No Tasks Added Yet...",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ));
              }
            } else {
              return Container(
                margin: EdgeInsets.fromLTRB(50, 250, 50, 100),
                child: CircularProgressIndicator(
                  // backgroundColor: Colors.redAccent,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 5,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void _addTaskDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Add Task"),
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10),
                child: TextField(
                  controller: _taskTextController,
                  maxLines: 2,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Task",
                      hintText: "Write task here..."),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    TextButton(
                        onPressed: () {
                          _taskTextController.text = "";
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        )),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey[700],
                        onPrimary: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      onPressed: () {
                        String _task = _taskTextController.text.trim();
                        String _uid = widget.currentUser.uid;
                        _firestore
                            .collection("users")
                            .doc(_uid)
                            .collection("tasks")
                            .add({
                          "task": _task,
                          "date_time": DateTime.now(),
                        });
                        _taskTextController.text = "";
                        Navigator.of(context).pop();
                      },
                      child: Center(
                        child: Text(
                          "Add",
                          style: TextStyle(
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          );
        });
  }
}
