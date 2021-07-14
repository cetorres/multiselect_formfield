import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String>? _myActivities;
  List<int>? _myInts;
  late String _myActivitiesResult;
  late String _myIntsResult;
  final formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _myActivities = [];
    _myInts = [];
    _myActivitiesResult = '';
    _myIntsResult = '';
  }

  _saveForm() {
    final form = formKey.currentState!;
    if (form.validate()) {
      form.save();
      setState(() {
        _myActivitiesResult = _myActivities.toString();
        _myIntsResult = _myInts.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MultiSelect Formfield Example'),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16),
                child: MultiSelectFormField<String>(
                  autovalidate: AutovalidateMode.disabled,
                  chipBackgroundColor: Colors.blue,
                  chipLabelStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                  dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
                  checkBoxActiveColor: Colors.blue,
                  checkBoxCheckColor: Colors.white,
                  dialogShapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  title: Text(
                    "My workouts",
                    style: TextStyle(fontSize: 16),
                  ),
                  validator: (value) {
                    if (value == null || value.length == 0) {
                      return 'Please select one or more options';
                    }
                    return null;
                  },
                  dataSource: [
                    Pair.from("Running"),
                    Pair.from("Climbing"),
                    Pair.from("Walking"),
                    Pair.from("Swimming"),
                    Pair.from("Soccer Practice"),
                    Pair.from("Baseball Practice"),
                    Pair.from("Football Practice"),
                  ],
                  okButtonLabel: 'OK',
                  cancelButtonLabel: 'CANCEL',
                  hintWidget: Text('Please choose one or more'),
                  initialValue: _myActivities,
                  onSaved: (value) {
                    if (value == null) return;
                    setState(() {
                      _myActivities = value.toList();
                    });
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: Text(_myActivitiesResult),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: MultiSelectFormField<int>(
                  autovalidate: AutovalidateMode.disabled,
                  chipBackgroundColor: Colors.blue,
                  chipLabelStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                  dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
                  checkBoxActiveColor: Colors.blue,
                  checkBoxCheckColor: Colors.white,
                  dialogShapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  title: Text(
                    "My Numbers",
                    style: TextStyle(fontSize: 16),
                  ),
                  validator: (value) {
                    if (value == null || value.length == 0) {
                      return 'Please select one or more options';
                    }
                    return null;
                  },
                  dataSource: [
                    Pair(label: "Zero", value: 0),
                    Pair(label: "One", value: 1),
                    Pair(label: "Two", value: 2),
                    Pair(label: "Three", value: 3),
                  ],
                  okButtonLabel: 'OK',
                  cancelButtonLabel: 'CANCEL',
                  hintWidget: Text('Please choose one or more'),
                  initialValue: _myInts,
                  onSaved: (value) {
                    if (value == null) return;
                    setState(() {
                      _myInts = value.toList();
                    });
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                child: ElevatedButton(
                  child: Text('Save'),
                  onPressed: _saveForm,
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: Text(_myIntsResult),
              )
            ],
          ),
        ),
      ),
    );
  }
}
