import 'package:meta/meta.dart';
class Schedule{

  Schedule(@required this.id,
      @required this.start_time,
      @required this.end_time,
      @required this.lecture,
      );

  final String id;
  final String start_time;
  final String end_time;
  final String lecture;


  factory Schedule.fromMap(Map<String, dynamic> data, String documentId) {
    // if (data == null) {
    //   return null;
    // }

    final String start_time = data['start_time'];
    final String end_time = data['end_time'];
    final String lecture= data['lecture'];


    return Schedule(documentId,start_time,end_time, lecture);
  }

  Map<String, dynamic> toMap(){
    return {
      'start_time': start_time,
      'end_time': end_time,
      'lecture': lecture,
    };
  }
}