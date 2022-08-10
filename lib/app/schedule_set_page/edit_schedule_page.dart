import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quran_khmer_online/common_widget/show_exception_alert_dialog.dart';
import 'package:quran_khmer_online/models/schedule.dart';
import 'package:quran_khmer_online/services/database.dart';

class EditSchedulePage extends StatefulWidget {

  final Schedule schedule;
  final String day_num;

  const EditSchedulePage({Key key, this.schedule, this.day_num}) : super(key: key);

  static Future<void> show(BuildContext context, {Schedule schedule, String day_num}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditSchedulePage(schedule: schedule, day_num: day_num),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditSchedulePageState createState() => _EditSchedulePageState();
}

class _EditSchedulePageState extends State<EditSchedulePage> {
  final _formKey = GlobalKey<FormState>();

  String _start_time;
  String _end_time;
  String _lecture;

  @override
  void initState() {
    super.initState();
    if (widget.schedule != null) {
      _start_time = widget.schedule.start_time;
      _end_time = widget.schedule.end_time;
      _lecture = widget.schedule.lecture;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
          print(widget.day_num);
          FirestoreDatabase database = FirestoreDatabase(uid: "1234");
          final id = widget.schedule?.id ?? documentIdFromCurrentDate();
          print(id);
          final schedule = Schedule(id, _start_time, _end_time, _lecture);
          await database.setSchedule(schedule,widget.day_num, id);
          Navigator.of(context).pop();
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(
          context,
          title: 'Operation failed',
          exception: e,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text(widget.schedule == null ? 'New Schedule' : 'Edit Schedule'),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: _submit,
          ),
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Lecture'),
        initialValue: _lecture,
        keyboardType: TextInputType.text,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _lecture = value,
      ),

      TextFormField(
        decoration: InputDecoration(labelText: 'Start Time'),
        initialValue: _start_time,
        keyboardType: TextInputType.datetime,
        validator: (value) => value.isNotEmpty ? null : 'Start can\'t be empty',
        onSaved: (value) => _start_time = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'End Time'),
        initialValue: _end_time,
        keyboardType: TextInputType.datetime,
        validator: (value) => value.isNotEmpty ? null : 'Start can\'t be empty',
        onSaved: (value) => _end_time = value,
      ),
    ];
  }
}
