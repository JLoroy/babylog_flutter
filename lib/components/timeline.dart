import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import '../datamodel/babylogevent.dart';

class BabyTimeline extends StatefulWidget {
  @override
  BabyTimelineState createState() => BabyTimelineState();
}

class BabyTimelineState extends State<BabyTimeline> {
  ScrollController _scrollController = ScrollController();
  
  FirebaseAuth? _auth;
  FirebaseAuth get auth {
    return _auth ?? FirebaseAuth.instance;
  }
  
  FirebaseFirestore db = FirebaseFirestore.instance;

  final eventsQuery = FirebaseFirestore.instance.collection('events')
  .orderBy('when')
  .withConverter<BabylogEvent>(
     fromFirestore: (snapshot, _) => BabylogEvent.fromJson(snapshot.data()!),
     toFirestore: (BabylogEvent event, _) => event.toJson(),
   );


  void _scrollDown() {
    if (_scrollController.hasClients){
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
    
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scrollDown());
    
  }

  @override
  void dispose() {
    super.dispose();
  }

   @override
  Widget build(BuildContext context) {

    return FutureBuilder<QuerySnapshot<BabylogEvent>>(
        future: eventsQuery.get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<DocumentSnapshot<BabylogEvent>> documents = snapshot.data!.docs;
            var _sortedEntries = documents.map((doc) => doc.data()!).toList();

            if(_sortedEntries.isNotEmpty){
              List<BabylogEvent> mergedEntries = [];
              _sortedEntries.sort((a, b) => a.when!.compareTo(b.when!));  // Sort by 'when'
              List<BabylogEvent> currentBatch = [];
              for (var entry in _sortedEntries) {
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
              _scrollDown;
              return timeline;
            }
          } else if (snapshot.hasError) {
            return Text("It's Error!");
          }
          return Text("unknown");
        });
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