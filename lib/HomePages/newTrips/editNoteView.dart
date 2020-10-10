
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travelapp/models/trip.dart';
import 'package:travelapp/services/provider.dart';
class EditNoteView extends StatefulWidget {
  EditNoteView({this.trip});

  final Trip trip;

  @override
  _EditNoteViewState createState() => _EditNoteViewState();
}

class _EditNoteViewState extends State<EditNoteView> {
  
 TextEditingController _notesController = new TextEditingController();

  final db = Firestore.instance;

  @override
  void initState() {
    super.initState();
    _notesController.text = widget.trip.notes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.deepPurpleAccent,
        child: Hero(
          tag: "TripNotes-${widget.trip.title}",
          transitionOnUserGestures: true,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  buildHeading(context),
                  buildNotesText(),
                  buildSubmitButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeading(context) {
    return Material(
      color: Colors.deepPurpleAccent,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 10.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                "Trip Notes",
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            FlatButton(
              child: Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget buildNotesText() {
    return Material(
      color: Colors.deepPurpleAccent,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextField(
          maxLines: null,
          controller: _notesController,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          cursorColor: Colors.white,
          autofocus: true,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget buildSubmitButton(context) {
    return Material(
      color: Colors.deepPurpleAccent,
      child: RaisedButton(
        child: Text("Save"),
        color: Colors.greenAccent,
        onPressed: () async {
          widget.trip.notes = _notesController.text;

          final uid = await Provider.of(context).getUserId();

          await db.collection("userData")
                  .document(uid)
                  .collection("trips")
                  .document(widget.trip.documentId)
                  .updateData({'notes': _notesController.text});

          Navigator.of(context).pop();

        },
      ),
    );
  }
}

