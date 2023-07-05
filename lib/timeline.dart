import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BabyTimeline extends StatefulWidget {
  @override
  BabyTimelineState createState() => BabyTimelineState();
}

class BabyTimelineState extends State<BabyTimeline> {

  final List<TimelineModel> items = [
      TimelineModel(
          Container(
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("6AM"),
                Text("Baby pooped"),
              ],
            ),
          ),
          position: TimelineItemPosition.right,
          iconBackground: Colors.brown,
          icon: Icon(Icons.blur_circular)),
      TimelineModel(
          Container(
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("8AM"),
                Text("Baby drank 60ml"),
              ],
            ),
          ),position: TimelineItemPosition.right,
          iconBackground: Colors.blue,
          icon: Icon(Icons.baby_changing_station)),
    ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Timeline(children: items, position: TimelinePosition.Left);
  }

}