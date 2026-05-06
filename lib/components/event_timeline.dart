import 'package:babylog/datamodel/babylogassistant.dart';
import 'package:babylog/datamodel/babylogevent.dart';
import 'package:babylog/theme/babylog_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class Timeline extends StatelessWidget {
  Timeline({super.key, required this.assistant});

  final BabylogAssistant assistant;
  final ScrollController _scrollController = ScrollController();

  void _scrollDown() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  Future<void> _runsAfterBuild() async {
    await Future.delayed(Duration.zero); // <-- Add a 0 dummy waiting time
    _scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BabylogEvent>>(
      stream: assistant.eventsStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<BabylogEvent>> snapshot) {
        if (snapshot.hasError) {
          return const _TimelineMessage(
            icon: Icons.cloud_off_rounded,
            title: 'Something went wrong',
            body: 'Your timeline could not be loaded right now.',
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: BabylogTheme.primary),
          );
        }

        var events = snapshot.data;

        if (events == null) {
          events = [];
        }

        if (events.isNotEmpty) {
          List<BabylogEvent> mergedEntries = [];
          events.sort((a, b) => a.when!.compareTo(b.when!)); // Sort by 'when'
          List<BabylogEvent> currentBatch = [];
          for (var entry in events) {
            if (currentBatch.isEmpty || entry.when == currentBatch.first.when) {
              currentBatch.add(entry);
            } else {
              mergedEntries.add(BabylogEvent.merge(currentBatch));
              currentBatch = [entry];
            }
          }
          if (currentBatch.isNotEmpty) {
            mergedEntries.add(BabylogEvent.merge(currentBatch));
          }

          var entriesByDate = <String, List<BabylogEvent>>{};
          for (var entry in mergedEntries) {
            var dateString =
                DateFormat('yyyy-MM-dd').format(entry.when!.toDate());
            entriesByDate.putIfAbsent(dateString, () => []).add(entry);
          }
          var timeline = ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(14, 8, 18, 18),
            itemCount: entriesByDate.keys.length,
            itemBuilder: (context, index) {
              var date = entriesByDate.keys.elementAt(index);
              var displayDateformat = DateFormat('EEEE d MMMM');
              var formattedDate =
                  displayDateformat.format(DateTime.parse(date));
              var entriesForDate = entriesByDate[date];
              var dayEvents = entriesForDate!.map<Widget>((entry) {
                return TimelineItem(
                    item: EventCard(assistant: assistant, event: entry));
              }).toList();
              dayEvents.insert(
                  0,
                  TimelineItem(
                    item: _DatePill(label: formattedDate),
                    isHeader: true,
                  ));
              return Column(children: dayEvents);
            },
          );
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _runsAfterBuild());
          return timeline;
        } else {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: _TimelineMessage(
              icon: Icons.mic_rounded,
              title: 'Welcome!',
              body:
                  'Log your first event with the record button below or enter your preferences in the settings.',
            ),
          );
        }
      },
    );
  }
}

class EventCard extends StatelessWidget {
  EventCard({super.key, required this.assistant, required this.event});

  final BabylogAssistant assistant;
  final BabylogEvent event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.96, end: 1),
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      builder: (context, scale, child) {
        return Transform.scale(
            scale: scale, alignment: Alignment.centerLeft, child: child);
      },
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 92),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFFFECE5)),
          boxShadow: [
            BoxShadow(
              blurRadius: 24,
              offset: const Offset(0, 10),
              color: BabylogTheme.primaryDark.withValues(alpha: 0.08),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFFE8DF),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/${event.type}.svg",
                        colorFilter: const ColorFilter.mode(
                          BabylogTheme.primary,
                          BlendMode.srcIn,
                        ),
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    DateFormat('HH:mm').format(event.when!.toDate()),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: BabylogTheme.ink,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton<int>(
                    icon: const Icon(Icons.more_vert_rounded),
                    tooltip: 'Event menu',
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline_rounded),
                            SizedBox(width: 12),
                            Text("Delete"),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 1) {
                        assistant.deleteEvent(event);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                event.description ?? "",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: BabylogTheme.ink,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TimelineItem extends StatelessWidget {
  const TimelineItem({
    super.key,
    required this.item,
    this.isHeader = false,
  });

  final Widget item;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, isHeader ? 14 : 7, 0, isHeader ? 7 : 7),
      child: Row(
        crossAxisAlignment:
            isHeader ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 36,
            child: Column(
              children: [
                Container(
                  width: isHeader ? 12 : 10,
                  height: isHeader ? 12 : 10,
                  margin: EdgeInsets.only(top: isHeader ? 0 : 22),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isHeader ? BabylogTheme.honey : BabylogTheme.primary,
                    boxShadow: [
                      BoxShadow(
                        color: (isHeader
                                ? BabylogTheme.honey
                                : BabylogTheme.primary)
                            .withValues(alpha: 0.25),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: item),
        ],
      ),
    );
  }
}

class _DatePill extends StatelessWidget {
  const _DatePill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: const Color(0xFFFFE7CB),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: BabylogTheme.primaryDark,
                fontWeight: FontWeight.w900,
              ),
        ),
      ),
    );
  }
}

class _TimelineMessage extends StatelessWidget {
  const _TimelineMessage({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 360),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.88),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFFE8DF),
              ),
              child: Icon(icon, color: BabylogTheme.primary),
            ),
            const SizedBox(height: 14),
            Text(title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              body,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: BabylogTheme.muted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
