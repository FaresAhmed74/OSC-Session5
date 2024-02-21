import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/home_screen.dart';
import 'package:mynotes/main.dart';
import 'package:mynotes/sql.dart';

class addNotes extends StatefulWidget {

  const addNotes({Key? key}) : super(key: key);

  @override
  State<addNotes> createState() => _addNotesState();
}

class _addNotesState extends State<addNotes> {
  GlobalKey<FormState> formstate=GlobalKey();
  TextEditingController note =TextEditingController();
  TextEditingController title =TextEditingController();
  TextEditingController color =TextEditingController();
// look here 
   MyDb db=MyDb();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Notes"),),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            Form(
              key: formstate,
                child: Column(
              children: [
                TextFormField(
                  controller: note,
                  decoration: InputDecoration(
                    hintText: "write your note"
                  ),
                ),
                TextFormField(
                  controller:title,
                  decoration: InputDecoration(
                      hintText: "write the title"
                  ),
                ),
                TextFormField(
                  controller:color,
                  decoration: InputDecoration(
                      hintText: "write the color"
                  ),
                ),
                MaterialButton(
                    textColor: Colors.white,
                    color: Colors.teal,
                    onPressed:()async{
                    int response=await db.insertData(
                      ''' 
                      INSERT INTO mynotes ('notes','title','color')
                      VALUES ("${note.text}","${title.text}","${color.text}")
                      ''');
                    print("response==${response}");
                    if(response>0){

                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> Home_Screen()), (route) => false);
                    }
                },
                  child: Text("Add Note"),
                )

              ],
            ))
          ],
        ),
      ),
    );
  }
}
