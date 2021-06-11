import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Database database;
  String tableName = "emp";
  Future init() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo1.db');
    database = await openDatabase(path, version: 1, onCreate: (db, version) {
      print("on Create called");
      createTable(db);
    });
    print("db opened");
  }

  Future createTable(Database db) async {
    await db.transaction((Transaction transaction) async {
      transaction
          .execute("create table emp(id int primary key,name text,salary int)");
    });
    print("Table created");
  }

  Future insertData() async {
    await database.transaction((txn) async {
      // txn.rawInsert("insert into emp values(100,'Dinesh',12000)");
      await txn
          .rawInsert("insert into emp values(?,?,?)", [100, "Dinesh", 12000]);
      await txn
          .rawInsert("insert into emp values(?,?,?)", [101, "Manish", 32000]);
      await txn
          .rawInsert("insert into emp values(?,?,?)", [102, "Naresh", 42000]);
    });
  }

  Future showRecords() async {
    await database.transaction((txn) async {
      List<Map> list = await txn.rawQuery("Select * from emp");

      list.forEach((map) {
        int id = map["id"];
        String name = map["name"];
        int salary = map["salary"];
        print("id : $id");
        print("Name : $name");
        print("salary : $salary");
      });
    });
  }

  void closeDb() {
    database.close();
  }
}
