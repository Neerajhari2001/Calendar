import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import './create-group.dart';
import './add-event.dart';
import './NavBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime today = DateTime.now();
  Map<DateTime, List<String>> events = {};

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  void _showEditEventDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditEventDialog(
          onEventAdded: (newEvent) {
            setState(() {
              if (events.containsKey(today)) {
                events[today]!.add(newEvent);
              } else {
                events[today] = [newEvent];
              }
            });
          },
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this event?'),
          actions: [
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
              ),
              child: Text('Delete', style: TextStyle(color: Colors.white)),
              onPressed: () {
                _deleteEvent(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteEvent(int index) {
    setState(() {
      events[today]!.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar"),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: NavBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text("Selected Day = " + today.toString().split(" ")[0]),
            Container(
              child: TableCalendar(
                locale: "en_US",
                rowHeight: 43,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                availableGestures: AvailableGestures.all,
                selectedDayPredicate: (day) => isSameDay(day, today),
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: today,
                onDaySelected: _onDaySelected,
              ),
            ),
            SizedBox(height: 20),
            Text("Scheduled Events"),
            Expanded(
              child: ListView.builder(
                itemCount: events.containsKey(today) ? events[today]!.length : 0,
                itemBuilder: (context, index) {
                  final event = events[today]![index];
                  return Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          event,
                          style: TextStyle(color: Colors.white),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.white),
                              onPressed: () {
                                // Edit event functionality
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.white),
                              onPressed: () {
                                _showDeleteConfirmationDialog(index);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
              ),
              onPressed: _showEditEventDialog,
              child: Text(
                'Add Event',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditEventDialog extends StatefulWidget {
  final Function(String) onEventAdded;

  const EditEventDialog({Key? key, required this.onEventAdded}) : super(key: key);

  @override
  _EditEventDialogState createState() => _EditEventDialogState();
}

class _EditEventDialogState extends State<EditEventDialog> {
  late TextEditingController _eventController;

  @override
  void initState() {
    super.initState();
    _eventController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Event'),
      content: TextField(
        controller: _eventController,
        decoration: InputDecoration(hintText: 'Enter event title'),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
          ),
          child: Text('Save'),
          onPressed: () {
            final newEvent = _eventController.text;
            widget.onEventAdded(newEvent);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}
