import 'dart:typed_data';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:event_app/common/galleryGrid.dart';
import 'package:event_app/common/route_generator.dart';
import 'package:event_app/common/utility.dart';
import 'package:event_app/models/eventModel.dart';
import 'package:event_app/repository/dbRep.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geocoder/services/base.dart';
import 'package:event_app/common/color_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';

class AddEditEvent extends StatefulWidget {
  EventModel eventmodel;
  final bool edit;

  AddEditEvent(this.edit, this.eventmodel);

  @override
  _AddEditEventState createState() => _AddEditEventState();
}

class _AddEditEventState extends State<AddEditEvent>
    with WidgetsBindingObserver {
  Future<List<EventModel>> events;
  DbRepository dbHelper;
  GlobalKey<FormState> _formKey;
  final _nameOfEventController = TextEditingController();
  final _eventDescriptionController = TextEditingController();
  final _eventAddressController = TextEditingController();
  final _dateTimeController = TextEditingController();
  DateTime eventDateTime;
  List<dynamic> tripPictures = [];

  @override
  void initState() {
    dbHelper = DbRepository();
    eventDateTime = DateTime.now();
    _formKey = GlobalKey<FormState>();

    if (widget.edit) {
      _nameOfEventController.text = widget.eventmodel.eventName;
      _eventDescriptionController.text = widget.eventmodel.eventDescription;
      _eventAddressController.text = widget.eventmodel.eventAddress;
      _dateTimeController.text = widget.eventmodel.eventDateTime;
      if(widget.eventmodel.eventImage!=null)
      {
      tripPictures
          .add(Utility.dataFromBase64String(widget.eventmodel.eventImage));
      }      eventDateTime = new DateFormat('yyyy-MM-dd  HH:mm')
          .parse(widget.eventmodel.eventDateTime);
    }

    super.initState();
  }

  refreshEventList() {
    setState(() {});
  }

  @override
  void dispose() {
    _nameOfEventController.dispose();
    _eventDescriptionController.dispose();
    _eventAddressController.dispose();
    _dateTimeController.dispose();
    _formKey = null;
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
              child: Text(widget.edit? "Edit Event":"Add Event"),
            )
          ],
        ),
        elevation: 0.0,
        centerTitle: false,
      ),
      body: Container(
        child: AddEditEventList(1),
      ),
    );
  }

  AddEditEventList(int i) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
        ),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width / 1.2,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Name",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: ColorConstants.kWhiteColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: TextFormField(
                      onTap: () {},
                      controller: _nameOfEventController,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Name of Event is empty';
                        }
                        return null;
                      },
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Name of Event",
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.only(
                          left: 10,
                          top: 5,
                          bottom: 5,
                          right: 10,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Date and Time",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: ColorConstants.kWhiteColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        FocusScopeNode currentFocus = FocusScope.of(context);

                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        _selectStartdateTime(context);
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          readOnly: true,
                          controller: _dateTimeController,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Date and Time is empty';
                            }

                            if (eventDateTime.isBefore(DateTime.now()
                                .subtract(new Duration(minutes: 10)))) {
                              return 'You Can\'t select Past date';
                            }
                            return null;
                          },
                          onChanged: (value) {},
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            // contentPadding: EdgeInsets.all(1.0),
                            icon: (ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return RadialGradient(
                                  center: Alignment.topCenter,
                                  radius: 0.5,
                                  colors: <Color>[
                                    ColorConstants.kPrimaryColor,
                                    ColorConstants.kThirdSecondaryColor,
                                  ],
                                  tileMode: TileMode.repeated,
                                ).createShader(bounds);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Icon(
                                  Icons.watch_later_outlined,
                                  color: ColorConstants.kPrimaryColor,
                                ),
                              ),
                            )),
                            hintText: "Choose date and time of event",
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Description",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: ColorConstants.kWhiteColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: _eventDescriptionController,
                      maxLines: 3,
                      autofocus: false,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please write description';
                        }
                        return null;
                      },
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        hintText: "Description of Event",
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.only(
                          left: 10,
                          top: 5,
                          bottom: 5,
                          right: 10,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Address",
                      ),
                      InkWell(
                  onTap: () async {
                    LocationResult result = await showLocationPicker(
                      context,
                      // 'AIzaSyAT07iMlfZ9bJt1gmGj9KhJDLFY8srI6dA',
                      'AIzaSyD0iCCqlzf0GSJiNMfFYAPomyPnnUuu9Bk',
                      initialCenter:
                          LatLng(23.0690, 72.5393),
                      //automaticallyAnimateToCurrentLocation: true,
                      //mapStylePath: 'assets/mapStyle.json',
                      myLocationButtonEnabled: true,
                      //resultCardAlignment: Alignment.bottomCenter,
                    );
                    if(result.address!=null)
                    {
                      _eventAddressController.text=result.address;
                    }else
                    {
                      Geocoding geocoding = Geocoder.local;

                      final Map<String, Geocoding> modes = {
                        "Local" : Geocoder.local,
                        "Google (distant)" : Geocoder.google('AIzaSyD0iCCqlzf0GSJiNMfFYAPomyPnnUuu9Bk'),
                      };
                      
                      var f = new NumberFormat("###.0#", "en_US");

                      final coordinates = new Coordinates(
                      double.parse(f.format(result.latLng.latitude)), double.parse(f.format(result.latLng.longitude))
                      );
                      var addresses = await modes['Local'].findAddressesFromCoordinates(
                    coordinates);
                    _eventAddressController.text=addresses[0].addressLine;
                    }

                    print("result = $result");
                  },
                        child: Icon(
                                    Icons.my_location,
                                    color: ColorConstants.kPrimaryColor,
                                  ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: ColorConstants.kWhiteColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: _eventAddressController,
                      maxLines: 3,
                      autofocus: false,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please write address';
                        }
                        return null;
                      },
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        hintText: "Address of Event",
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.only(
                          left: 10,
                          top: 5,
                          bottom: 5,
                          right: 10,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    color: ColorConstants.kGreyColor,
                  ),
                  Text(
                    "Pictures",
                    // style: txtapp,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GalleryGrid(
                    isEditable: true,
                    pictures: tripPictures,
                    preview: false,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    color: ColorConstants.kGreyColor,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(12.0),
                            side: BorderSide(
                                color: ColorConstants.kPrimaryColor, width: 2)
                            // : BorderSide.none,
                            ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 10,
                        ),
                        onPressed: () {},
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: ColorConstants.kPrimaryColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      !widget.edit
                          ? FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(12.0),
                                  side: BorderSide(
                                      color: ColorConstants.kPrimaryColor,
                                      width: 2)
                                  // : BorderSide.none,
                                  ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 10,
                              ),
                              onPressed: () {
                                check();
                              },
                              child: Text(
                                "Save",
                                style: TextStyle(
                                  color: ColorConstants.kPrimaryColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                ),
                              ),
                            )
                          : FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(12.0),
                                  side: BorderSide(
                                      color: ColorConstants.kPrimaryColor,
                                      width: 2)
                                  // : BorderSide.none,
                                  ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 10,
                              ),
                              onPressed: () {
                                check();
                              },
                              child: Text(
                                "Edit",
                                style: TextStyle(
                                  color: ColorConstants.kPrimaryColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    ;
  }

  Future<Null> _selectStartdateTime(BuildContext context) async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    DateTime tempPickedDate;
    DateTime picked = await showModalBottomSheet<DateTime>(
        context: context,
        builder: (context) {
          return Container(
            height: 250,
            child: Column(
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CupertinoButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      CupertinoButton(
                        child: Text('Done'),
                        onPressed: () {
                          Navigator.of(context).pop(tempPickedDate);
                        },
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 0,
                  thickness: 1,
                ),
                Expanded(
                  child: Container(
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.dateAndTime,
                      // minimumDate: DateTime.now().subtract(new Duration(days: 1)),
                      // maximumDate: widget.maxdate,
                      initialDateTime: eventDateTime,
                      onDateTimeChanged: (DateTime dateTime) {
                        eventDateTime = dateTime;
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });

    if (eventDateTime != null)
      setState(() {
        _dateTimeController.text =
            DateFormat('yyyy-MM-dd  HH:mm').format(eventDateTime);
      });
  }

  check() async {
    if (_formKey.currentState.validate()) {
      // sendTripDetails();
      List<dynamic> imglist = [];
      for (var entry in tripPictures.asMap().entries) {
        var pic = entry.value;
        var i = entry.key;

        if (pic is Uint8List) {
          imglist.add(Utility.base64String(pic));
        }
      }

      if (widget.edit) {
        var temp = await DbRepository().update(EventModel(
            eventID: widget.eventmodel.eventID,
            eventName: _nameOfEventController.text,
            eventDescription: _eventDescriptionController.text,
            eventDateTime: _dateTimeController.text.toString(),
            eventAddress: _eventAddressController.text,
            eventImage: imglist?.length != 0 ? imglist.first : null));
      } else {
        var temp = await DbRepository().add(EventModel(
            eventName: _nameOfEventController.text,
            eventDescription: _eventDescriptionController.text,
            eventDateTime: _dateTimeController.text.toString(),
            eventAddress: _eventAddressController.text,
            eventImage: imglist?.length != 0 ? imglist.first : null));
      }

      Navigator.of(context).pushNamedAndRemoveUntil(
        EventMain,
        (route) => false,
      );
    }

    print("Trip");
  }
}
