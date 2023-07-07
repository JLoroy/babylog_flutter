import 'package:flutter_svg/svg.dart';
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
  ScrollController _scrollController = ScrollController();
  Future<Box>? _boxFuture;


  void _scrollDown() {
    if (_scrollController.hasClients){
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
    
  }
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
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scrollDown());
    
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

          var entryDateFormat = DateFormat('yyyy-MM-dd');

          // Group entries by date
          var entriesByDate = <String, List<MapEntry>>{};
          for (var entry in sortedEntries) {
            var date = DateTime.fromMillisecondsSinceEpoch(1000*entry.key as int);
            var dateString = entryDateFormat.format(date);
            entriesByDate.putIfAbsent(dateString, () => []).add(entry);
          }

          var timeline = ListView(children:[const Column(children: [Text("Nothing happened yet",style: const TextStyle(fontWeight: FontWeight.w200, fontSize: 12))])]);
          if(! sortedEntries.isEmpty){
            print(sortedEntries.length);
            timeline = ListView.builder(
              controller: _scrollController,
              itemCount: entriesByDate.keys.length,
              itemBuilder: (context, index) {
                var date = entriesByDate.keys.elementAt(index);
                var displayDateformat = DateFormat('EEEE d MMMM');
                var timeFormat = DateFormat('HH:mm');
                var formattedDate = displayDateformat.format(DateTime.parse(date));
                var entriesForDate = entriesByDate[date];
                var dayEvents = entriesForDate!.map<Widget>((entry) {
                    var time = timeFormat.format(DateTime.fromMillisecondsSinceEpoch(1000*entry.key as int));
                    return TimelineItem(item: EventCard(entry: entry, time: time));
                  }).toList();
                dayEvents.insert(0,TimelineItem(item: Text(
                    formattedDate,
                    style: TextStyle(fontSize: 18, color: Color(0xFFFF6B6B)),
                    )
                  ));
                return Column(children: dayEvents);
              },
            );
            _scrollDown();
          }
          return timeline;
        }
      },
    );
  }
}

class EventCard extends StatelessWidget {
  EventCard({
    super.key,
    required this.entry,
    required this.time,
  });

  final MapEntry entry;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(blurRadius: 3, offset:Offset(1, 4) ,color: Color.fromARGB(89, 195, 168, 146))],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Row(children : [
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(blurRadius: 1, color: Color.fromARGB(255, 238, 234, 230), spreadRadius: 1)],
                      ),
                      child: CircleAvatar(
                        backgroundColor: Color(0xFFFCF7F3),
                        radius: 18,
                        child: SvgPicture.asset("assets/baby-bottle.svg", color:Colors.red, width:24, height:24),

                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Text(
                        time,
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color:Color(0xFF354683))
                      ),
                    ),
                  ],),
                  const Icon(Icons.more_vert)
                ]
              ),
            Row(
              children:[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${entry.value[0]}',
                    style: const TextStyle(fontWeight: FontWeight.w200, fontSize: 12)
                  ),
                ),
              ]
            ),
          ]
        ),
      )
    );
  }
}

class TimelineItem extends StatelessWidget {
  const TimelineItem({
    super.key,
    required this.item,
  });

  final Widget item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(8.0,0,10,0),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 249, 137, 137),
                  radius:4
                  ),
              ],
            ),
          ),
          item
        ],
      ),
    );
  }
}