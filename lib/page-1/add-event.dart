import 'package:flutter/material.dart';
import 'NavBar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EventPage(),
    );
  }
}


class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  TextEditingController _eventNameController = TextEditingController();
  TextEditingController _eventDescriptionController = TextEditingController();
  TextEditingController _notifyController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectDate(bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventDescriptionController.dispose();
    _notifyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event App'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ADD EVENTS',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Event Name',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: _eventNameController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Enter event name',
                  filled: true,
                  fillColor: Color(0xFFD7E9FF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Start Date',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () => _selectDate(true),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: Text(
                                _startDate != null
                                    ? _startDate.toString()
                                    : 'Select start date',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'End Date',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () => _selectDate(false),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: Text(
                                _endDate != null
                                    ? _endDate.toString()
                                    : 'Select end date',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'EVENTS DESCRIPTION',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFD7E9FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _eventDescriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Enter event description',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'NOTIFY',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _notifyController,
                        decoration: InputDecoration(
                          hintText: 'Search person',
                          prefixIcon: Icon(Icons.search),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                    Icon(Icons.filter_list),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
