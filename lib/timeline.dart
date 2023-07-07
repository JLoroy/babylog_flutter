import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class BabyTimeline extends StatefulWidget {
  @override
  BabyTimelineState createState() => BabyTimelineState();
}

class BabyTimelineState extends State<BabyTimeline> {
  final String items = """[
    {"icon": "baby_changing_station", "time": "4AM", "text": "bu 120ml"},
    {"icon": "alarm", "time": "6AM", "text": "Baby pooped"},
    {"icon": "alarm", "time": "8AM", "text": "bu 120ml"}
  ];""";
  Future<Box>? _boxFuture;



  IconData getIconByName(String iconName) {
    switch (iconName) {
      case 'alarm':
        return Icons.alarm;
      case 'baby_changing_station':
        return Icons.baby_changing_station;
      // Add more cases as needed for other icons
      default:
        return Icons.help;  // default icon in case iconName is not found
    }
  }

  @override
  void initState() {
    super.initState();
    _boxFuture = Hive.openBox('babylogBox');
  }

  @override
  void dispose() {
    super.dispose();
  }

   @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _boxFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // show a loading spinner
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // show error message
        } else {
          final box = snapshot.data;
          final data = box!.toMap();
          
          // Assuming keys are timestamps in milliseconds since epoch
          var sortedEntries = data.entries.toList()
            ..sort((a, b) => (a.key as int).compareTo(b.key as int));

          var dateFormat = DateFormat('yyyy-MM-dd');
          var timeFormat = DateFormat('HH:mm');

          // Group entries by date
          var entriesByDate = <String, List<MapEntry>>{};
          for (var entry in sortedEntries) {
            var date = DateTime.fromMillisecondsSinceEpoch(1000*entry.key as int);
            var dateString = dateFormat.format(date);
            entriesByDate.putIfAbsent(dateString, () => []).add(entry);
          }

          return ListView.builder(
            itemCount: entriesByDate.keys.length,
            itemBuilder: (context, index) {
              var date = entriesByDate.keys.elementAt(index);
              var format = DateFormat('EEEE d MMMM');
              var formattedDate = format.format(DateTime.parse(date));
              var entriesForDate = entriesByDate[date];
              var dayEvents = entriesForDate!.map<Widget>((entry) {
                  var time = DateTime.fromMillisecondsSinceEpoch(entry.key as int);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0,0,10,0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundColor:const Color.fromARGB(255, 249, 137, 137),
                                radius:4
                                ),
                            ],
                          ),
                        ),
                        Container(
                          height: 60,
                          width: 300,
                          decoration: BoxDecoration(
                            border:Border.all(width:0, color:Color.fromARGB(255, 255, 114, 114)),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [BoxShadow(blurRadius: 4, offset:Offset(0, 4) ,color: Color.fromARGB(89, 195, 168, 146))],
                            gradient:LinearGradient(
                              colors: [Color.fromARGB(255, 255, 161, 193),Color.fromARGB(255, 255, 161, 193), Colors.white, Colors.white],
                              stops: [0.0,0.2,0.2,1.0]
                            )
                          ),
                          child: ListTile(
                            leading: Icon(
                              Icons.baby_changing_station,
                              color: Colors.white,
                              size: 32
                            ),
                            title: Text(timeFormat.format(time)),
                            subtitle: Text('${entry.value}'),
                            trailing: Icon(Icons.more_vert),
                            isThreeLine: true,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList();
              dayEvents.insert(0,Text(
                  formattedDate,
                  style: TextStyle(fontSize: 20),
                  )
                );
              return Column(children: dayEvents);
            },
          );
        }
      },
    );
  }
}
