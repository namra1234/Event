import 'dart:convert';

class EventModel {
  String eventName, eventDescription,  eventDateTime, eventAddress,eventImage;
  int eventID;
  

  EventModel(
      {this.eventID,
      this.eventName,
      this.eventDescription,
      this.eventDateTime,
      this.eventAddress,
      this.eventImage});

  Map<String, dynamic> toMap() {
    return {
      'eventID': eventID,
      'eventName': eventName,
      'eventDescription': eventDescription,
      'eventDateTime': eventDateTime,
      'eventAddress': eventAddress,
      'eventImage': eventImage,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    return EventModel(
        eventID: map['eventID'],
        eventName: map['eventName'],
        eventDescription: map['eventDescription'],
        eventDateTime: map['eventDateTime'],
        eventAddress: map['eventAddress'],
        eventImage: map['eventImage']);
  }

  factory EventModel.fromJson(String source) => EventModel.fromMap(
        json.decode(source),
      );
}
