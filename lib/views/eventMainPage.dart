import 'package:event_app/common/route_generator.dart';
import 'package:event_app/models/eventModel.dart';
import 'package:event_app/repository/dbRep.dart';
import '../common/route_generator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:event_app/common/color_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'addeditEvent.dart';

class EventMainPage extends StatefulWidget {
  @override
  _EventMainPageState createState() => _EventMainPageState();
}

class _EventMainPageState extends State<EventMainPage>
    with WidgetsBindingObserver 
    {
  Future<List<EventModel>> events;
  DbRepository dbHelper;

  Widget EventMainPageList() {
    return FutureBuilder(
      future: events,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? snapshot.data == null || snapshot.data.length == 0
                ? Center(child: Container(
                  // color: ColorConstants.kPrimaryColor,
                  child: Text("Create new Event",
                  style: TextStyle(
                        color: ColorConstants.kPrimaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600))))
                : 
                ListView.builder(
                    itemCount: snapshot.data.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return eventMainPageTile(
                        snapshot.data[index].eventName,
                        snapshot.data[index].eventDescription,
                        snapshot.data[index].eventImage,
                        snapshot.data[index].eventDateTime,
                        snapshot.data[index].eventAddress,
                        snapshot.data[index].eventID,
                        index
                      );
                    })
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  void initState() {
    dbHelper = DbRepository();
    refreshEventList();
    super.initState();
  }

  refreshEventList() {
    setState(() {
      events = dbHelper.getevents();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.kPrimaryColor,
        title: Row(
          children: [
            Image.asset(
              "assets/images/logoSmall.png",
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text("Event Manager"),
            )
          ],
        ),
        elevation: 0.0,
        centerTitle: false,
      ),
      body: Container(
          child: EventMainPageList(),
          ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorConstants.kPrimaryColor,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditEvent(false,null)),
          );
        },
      ),
    );
  }
  eventMainPageTile(String eventName,
      eventDescription,
      eventImage,
      eventDateTime,
      eventAddress,int eventID,index)
  {
    return
GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditEvent(true,
                                                    EventModel(
                                                      eventName: eventName,
                                                      eventID: eventID,
                                                      eventAddress: eventAddress,
                                                      eventDescription: eventDescription,
                                                      eventDateTime: eventDateTime,
                                                      eventImage: eventImage
                                                      ))),
          );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: index%2==0 ? ColorConstants.kGreyColor.withOpacity(0.5) : ColorConstants.kWhiteColor,
          shape: BoxShape.rectangle,         
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              color: ColorConstants.kGreyColor,
                              borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(eventName.substring(0, 1),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: ColorConstants.kPrimaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300)),
                          ),
                        ),
                Container(
                  width: MediaQuery.of(context).size.width/2,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    
                    children: [
                           
                      Container(
                        
                        child: Row(
                          children: [
                            
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Text(eventName,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: ColorConstants.kPrimaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300)),
                            ),
                            Divider(color: Colors.black)
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          
                           SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Text(eventDateTime,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: ColorConstants.kPrimaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300)),
                          ),
                          Divider(color: Colors.black)
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            Container(
              width: 40.0,
  height: 40.0,
              child: FloatingActionButton(
                heroTag: "btn"+index.toString(),
        backgroundColor: ColorConstants.kPrimaryColor,
        child: Icon(Icons.delete),
        onPressed: () async{
          
          var temp= await DbRepository().delete(eventID);
          refreshEventList();
        },
      ),
            )
          ],
        ),
      ),
    );
  }

}

// class EventMainPageTile extends StatelessWidget {
//   final String eventName,
//       eventDescription,
//       eventImage,
//       eventDateTime,
//       eventAddress;
//   final int eventID,index;

//   EventMainPageTile(
//       {this.eventID,
//       this.eventName,
//       this.eventDescription,
//       this.eventImage,
//       this.eventDateTime,
//       this.eventAddress,
//       this.index});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => AddEditEvent(true,
//                                                     EventModel(
//                                                       eventName: this.eventName,
//                                                       eventID: this.eventID,
//                                                       eventAddress: this.eventAddress,
//                                                       eventDescription: this.eventDescription,
//                                                       eventDateTime: this.eventDateTime,
//                                                       eventImage: null
//                                                       ))),
//           );
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//         decoration: BoxDecoration(
//           color: index%2==0 ? ColorConstants.kGreyColor.withOpacity(0.5) : ColorConstants.kWhiteColor,
//           shape: BoxShape.rectangle,         
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 Container(
//                           height: 30,
//                           width: 30,
//                           decoration: BoxDecoration(
//                               color: ColorConstants.kGreyColor,
//                               borderRadius: BorderRadius.circular(30)),
//                           child: Padding(
//                             padding: const EdgeInsets.all(5.0),
//                             child: Text(eventName.substring(0, 1),
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                     color: ColorConstants.kPrimaryColor,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w300)),
//                           ),
//                         ),
//                 Container(
//                   width: MediaQuery.of(context).size.width/2,
//                   child: Column(
//                     // mainAxisAlignment: MainAxisAlignment.start,
                    
//                     children: [
                           
//                       Container(
                        
//                         child: Row(
//                           children: [
                            
//                             SizedBox(
//                               width: 20,
//                             ),
//                             Expanded(
//                               child: Text(eventName,
//                                   textAlign: TextAlign.start,
//                                   style: TextStyle(
//                                       color: ColorConstants.kPrimaryColor,
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w300)),
//                             ),
//                             Divider(color: Colors.black)
//                           ],
//                         ),
//                       ),
//                       Row(
//                         children: [
                          
//                            SizedBox(
//                             width: 20,
//                           ),
//                           Expanded(
//                             child: Text(eventDateTime,
//                                 textAlign: TextAlign.start,
//                                 style: TextStyle(
//                                     color: ColorConstants.kPrimaryColor,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w300)),
//                           ),
//                           Divider(color: Colors.black)
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
            
//             Container(
//               width: 40.0,
//   height: 40.0,
//               child: FloatingActionButton(
//                 heroTag: "btn"+index.toString(),
//         backgroundColor: ColorConstants.kPrimaryColor,
//         child: Icon(Icons.delete),
//         onPressed: () async{
          
//           var temp= await DbRepository().delete(eventID);
//           Navigator.of(context).pushNamedAndRemoveUntil(
//         EventMain,
//         (route) => false,
//       );
//         },
//       ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
