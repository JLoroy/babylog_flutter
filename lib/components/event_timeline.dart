import 'package:babylog/datamodel/babylogassistant.dart';
import 'package:babylog/datamodel/babylogevent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class Timeline extends StatelessWidget {
  Timeline({super.key, required this.assistant});

  final BabylogAssistant assistant;
  final ScrollController _scrollController = ScrollController();

  void _scrollDown() {
    if (_scrollController.hasClients){
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  
  Future<void> _runsAfterBuild() async {
    await Future.delayed(Duration.zero); // <-- Add a 0 dummy waiting time
    _scrollDown() ;
  }


  @override
  Widget build(BuildContext context) {
    
    return StreamBuilder<List<BabylogEvent>>(
      stream: assistant.eventsStream,
      builder: (BuildContext context, AsyncSnapshot<List<BabylogEvent>> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading...");
        }

        // This is your list of events.
        var events = snapshot.data;

        if (events == null){
          events = [];
        }

        // Now use this events variable instead of assistant.events in your code.
         if(events.isNotEmpty){
            List<BabylogEvent> mergedEntries = [];
            events.sort((a, b) => a.when!.compareTo(b.when!));  // Sort by 'when'
            List<BabylogEvent> currentBatch = [];
            for (var entry in events) {
              if (currentBatch.isEmpty || entry.when == currentBatch.first.when) {
                // If the current batch is empty, or this entry has the same 'when' as the current batch, add it to the batch
                currentBatch.add(entry);
              } else {
                // Otherwise, merge the current batch and start a new one
                mergedEntries.add(BabylogEvent.merge(currentBatch));
                currentBatch = [entry];
              }
            }
            // Don't forget to merge the last batch
            if (currentBatch.isNotEmpty) {
              mergedEntries.add(BabylogEvent.merge(currentBatch));
            }


            var entriesByDate = <String, List<BabylogEvent>>{};
            for (var entry in mergedEntries) {
              var dateString = DateFormat('yyyy-MM-dd').format(entry.when!.toDate());
              entriesByDate.putIfAbsent(dateString, () => []).add(entry);
            }
            var timeline = ListView.builder(
              controller: _scrollController,
              itemCount: entriesByDate.keys.length,
              itemBuilder: (context, index) {
                var date = entriesByDate.keys.elementAt(index);
                var displayDateformat = DateFormat('EEEE d MMMM');
                var formattedDate = displayDateformat.format(DateTime.parse(date));
                var entriesForDate = entriesByDate[date];
                var dayEvents = entriesForDate!.map<Widget>((entry) {
                    return TimelineItem(item: EventCard(event: entry));
                  }).toList();
                dayEvents.insert(0,TimelineItem(item: Text(
                    formattedDate,
                    style: TextStyle(fontSize: 18, color: Color(0xFFFF6B6B)),
                    )));
                return Column(children: dayEvents);
              },
            );
            WidgetsBinding.instance.addPostFrameCallback((_) => _runsAfterBuild());
            return timeline;
          }
          else {
            return Text("nothing yet");
          }
      }
    );
  }
}

class EventCard extends StatelessWidget {
  EventCard({
    super.key,
    required this.event
  });

  final BabylogEvent event;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(blurRadius: 3, offset:Offset(1, 4) ,color: Color.fromARGB(89, 195, 168, 146))],
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
                        radius: 15,
                        child: SvgPicture.asset("assets/${event.type}.svg", color:Colors.red, width:24, height:24),

                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Text(
                        DateFormat('HH:mm').format(event.when!.toDate()),
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
                  padding: const EdgeInsets.only(top:5),
                  child: Text(
                    '${event.description}',
                    style: const TextStyle(fontWeight: FontWeight.w200, fontSize: 12),
                    overflow: TextOverflow.ellipsis,

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