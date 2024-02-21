import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/sql.dart';

class  Home_Screen extends StatefulWidget {
  const Home_Screen ({Key? key}) : super(key: key);

  @override
  State<Home_Screen> createState() => _State();
}

class _State extends State<Home_Screen> {

  MyDb db=MyDb();
  List mynotes=[];
  bool isLoading=true;
  TextEditingController _note=TextEditingController();
  TextEditingController _title=TextEditingController();
  TextEditingController _color=TextEditingController();



  Future readData()async{
    List<Map> response=await db.readData("SELECT * FROM 'mynotes'");
    mynotes.addAll(response);
    isLoading=false;
    if(this.mounted){
      setState(() {});
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SQL"),),
      body: isLoading==true? Center(child: CircularProgressIndicator()):
      Container(
        child: ListView(
          children: [

             ListView.builder(
                      itemCount: mynotes.length,
                      physics: NeverScrollableScrollPhysics(),

                        shrinkWrap: true,
                        itemBuilder: (context,i){ // return Text("${snapshot.data![i]}")
                            return Card(
                                child: ListTile(
                                  title: Text("${mynotes[i]['title']}",),
                                  subtitle: Text("${mynotes[i]['notes']}"),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(icon: Icon(Icons.delete),

                                        onPressed: ()async{
                                          int response=await db.deleteData("DELETE FROM mynotes WHERE id = ${mynotes[i]['id']}");
                                          if(response>0){
                                           mynotes.removeWhere((element) => element['id']==mynotes[i]['id']);
                                           setState(() {});
                                          }
                                      },),
                                      IconButton(
                                        onPressed: () async {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text("Edit Data"),
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    TextField(
                                                      controller: _note,
                                                    ),
                                                    TextField(
                                                      controller: _title,
                                                    ),
                                                    TextField(
                                                      controller: _color,
                                                    ),
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  MaterialButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text("Cancel"),
                                                  ),
                                                  MaterialButton(
                                                    onPressed: () async {
                                                      int response = await db.updateData('''
                                                         UPDATE mynotes SET 
                                                        notes = "${_note.text}",
                                                        title = "${_title.text}",
                                                        color = "${_color.text}"
                                                        WHERE id = ${mynotes[i]['id']}
                                                      ''');
                                                      print("updated done res = ${response}");


                                                      Navigator.of(context).pop();
                                                      if(response>0){
                                                        // mohsens
                                                      }// Close the dialog after updating
                                                    },
                                                    child: Text("Save"),

                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }, icon: Icon(Icons.edit),
                                      )

                                    ],
                                  )
                                ,

                            ),

                            );
                    })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.of(context).pushNamed("addnotes");
          },
        child: Icon(Icons.add),
      ),
    );
  }
}
