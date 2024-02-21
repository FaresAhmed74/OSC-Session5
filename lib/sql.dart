import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MyDb{

  static Database? _db;

    Future<Database?>get db async{
          if(_db==null){
            _db = await intialDb();
            return _db;
          }
          else{
            return _db;
          }
    }
  intialDb()async{
    String databasePath=await getDatabasesPath();
    String path = join(databasePath,"mydb.db");
    Database mydb= await openDatabase(path,onCreate: _onCreate,version: 5,onUpgrade: _onUpgrade);
    return mydb;
  }
  _onUpgrade(Database mydb,int oldVersion,int newVersion)async{
      print("onupgrade");
      await mydb.execute("ALTER TABLE 'mynotes' ADD COLUMN color TEXT");
      /*
                 ---- Will it Work ? ---
         await mydb.execute("ALTER TABLE 'mynotes' DROP title")

         */
  }
  _onCreate(Database mydb,int version )async{
    print("onCreate");
      await mydb.execute('''
        CREATE TABLE  "mynotes" (
        "id" INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT ,
        "title" TEXT NOT NULL,
        "notes" TEXT NOT NULL
        )
      ''');
  }


  readData(String sql) async{
      Database? mydb=await db;
      List<Map> response=await mydb!.rawQuery(sql);
      return response;
  }
  insertData(String sql) async{
      Database? mydb= await db;
      int response=await mydb!.rawInsert(sql);
      return response;
  }
  updateData(String sql) async{
      Database? mydb=await db;
      int response=await mydb!.rawUpdate(sql);
      return response;
  }
  deleteData(String sql) async{
      Database? mydb=await db;
      int response= await mydb!.rawDelete(sql);
      return response;
  }
  deleteDb()async{
      String dbPath=await getDatabasesPath();
      String path=join(dbPath,'mydb.db');
      await deleteDatabase(path);
      print("deleted succ");
  }

  /*
  *
  * read(String table) async{
      Database? mydb=await db;
      List<Map> response=await mydb!.query(table);
      return response;
      *
      *
      *
      * insert(String table,Map<String,Object?> values) async{
      Database? mydb= await db;
      int response=await mydb!.insert(table,values);
      return response;
  }
  }
  * */
}