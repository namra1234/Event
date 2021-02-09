import '../common/constants.dart';
import 'package:flutter/cupertino.dart';
import '../models/eventModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';


class DbRepository {

static Database _db; 

DbRepository() 
{
  WidgetsFlutterBinding.ensureInitialized();

}

 Future<Database> get db async {    
   if (_db != null) {    
     return _db;    
   }    
   _db = await initDatabase();    
   return _db;    
 } 

initDatabase() async {
  String databasesPath = await getDatabasesPath();
  String dbPath = join(databasesPath, 'event_db.db');

  var database = await openDatabase(dbPath, version: 1, onCreate: _onCreate);
  return database;
}

 _onCreate(Database db, int version) async {    
   await db    
       .execute('CREATE TABLE event (eventID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, eventName TEXT, eventDescription TEXT, eventDateTime TEXT, eventAddress TEXT,eventImage TEXT)');     

 } 


  Future<EventModel> add(EventModel event) async {    
   var dbClient = await db;    
   event.eventID = await dbClient.insert('event', event.toMap());  
 
   return event;    
 } 

      
 Future<List<EventModel>> getevents() async {    
   var dbClient = await db;    
   List<Map> maps = await dbClient.query('event', columns: ['eventID', 'eventName','eventDescription','eventDateTime','eventAddress','eventImage']);    
   List<EventModel> events = [];    
   if (maps.length > 0) {    
     for (int i = 0; i < maps.length; i++) {    
       events.add(EventModel.fromMap(maps[i]));    
     }    
   }    
   return events;    
 }    


 Future<int> delete(int id) async {    
   var dbClient = await db;    
    
   return await dbClient.delete(    
     'event',    
     where: 'eventID = ?',    
     whereArgs: [id],    
   );    
 } 


  Future<int> update(EventModel event) async {    
   var dbClient = await db;    

   
      return await dbClient.update(    
     'event',    
     event.toMap(),    
     where: 'eventID = ?',    
     whereArgs: [event.eventID],    
   );    
 } 

   Future close() async {    
   var dbClient = await db;    
   dbClient.close();    
 } 

}
