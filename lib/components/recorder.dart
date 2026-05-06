import 'dart:async';
import 'package:babylog/theme/babylog_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as pth;

class AudioRecorderWidget extends StatefulWidget {
  final void Function(String path) onStop;

  const AudioRecorderWidget({Key? key, required this.onStop}) : super(key: key);

  @override
  State<AudioRecorderWidget> createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorderWidget> {
  int _recordDuration = 0;
  Timer? _timer;
  final _audioRecorder = AudioRecorder();
  StreamSubscription<RecordState>? _recordSub;
  RecordState _recordState = RecordState.stop;
  StreamSubscription<Amplitude>? _amplitudeSub;

  @override
  void initState() {
    _recordSub = _audioRecorder.onStateChanged().listen((recordState) {
      setState(() => _recordState = recordState);
    });

    _amplitudeSub = _audioRecorder
        .onAmplitudeChanged(const Duration(milliseconds: 300))
        .listen((_) {});

    super.initState();
  }

  Future<void> _start() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final dir = await getTemporaryDirectory();
        final filename =
            'babylog_recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
        final String path = pth.join(dir.path, filename);

        await _audioRecorder.start(
            const RecordConfig(
              encoder: AudioEncoder.aacLc,
              // Add other settings as needed
            ),
            path: path);

        _recordDuration = 0;
        _startTimer();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _stop() async {
    _timer?.cancel();
    _recordDuration = 0;

    final path = await _audioRecorder.stop();

    if (path != null) {
      widget.onStop(path);
    }
  }

  Future<void> _pause() async {
    _timer?.cancel();
    await _audioRecorder.pause();
  }

  Future<void> _resume() async {
    _startTimer();
    await _audioRecorder.resume();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildRecordStopControl(),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: _recordState == RecordState.stop
              ? const SizedBox(key: ValueKey('idle'), height: 18)
              : Padding(
                  key: const ValueKey('timer'),
                  padding: const EdgeInsets.only(top: 6),
                  child: _buildTimer(),
                ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recordSub?.cancel();
    _amplitudeSub?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  Widget _buildRecordStopControl() {
    late Widget icon;
    late Color color;
    final isRecording = _recordState != RecordState.stop;

    if (isRecording) {
      icon = const Icon(Icons.stop_rounded, color: Colors.white, size: 32);
      color = BabylogTheme.primary;
    } else {
      icon = SvgPicture.asset(
        "assets/micro.svg",
        colorFilter: const ColorFilter.mode(
          BabylogTheme.primary,
          BlendMode.srcIn,
        ),
        fit: BoxFit.scaleDown,
      );
      color = Colors.white;
    }

    return TweenAnimationBuilder<double>(
      tween:
          Tween(begin: isRecording ? 1.0 : 0.94, end: isRecording ? 1.08 : 1),
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeOutCubic,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: Container(
        width: 68,
        height: 68,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: BabylogTheme.primary
                  .withValues(alpha: isRecording ? 0.34 : 0.20),
              blurRadius: isRecording ? 24 : 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            child: Center(child: SizedBox(width: 34, height: 34, child: icon)),
            onTap: () {
              HapticFeedback.selectionClick();
              isRecording ? _stop() : _start();
            },
          ),
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _buildPauseResumeControl() {
    if (_recordState == RecordState.stop) {
      return const SizedBox.shrink();
    }

    late Icon icon;
    late Color color;

    if (_recordState == RecordState.record) {
      icon = const Icon(Icons.pause, color: Colors.red, size: 30);
      color = Colors.red.withValues(alpha: 0.1);
    } else {
      final theme = Theme.of(context);
      icon = const Icon(Icons.play_arrow, color: Colors.red, size: 30);
      color = theme.primaryColor.withValues(alpha: 0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child: SizedBox(width: 56, height: 56, child: icon),
          onTap: () {
            (_recordState == RecordState.pause) ? _resume() : _pause();
          },
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _buildText() {
    if (_recordState != RecordState.stop) {
      return _buildTimer();
    }

    return const Text("Waiting to record");
  }

  Widget _buildTimer() {
    final String minutes = _formatNumber(_recordDuration ~/ 60);
    final String seconds = _formatNumber(_recordDuration % 60);

    return Text(
      '$minutes:$seconds',
      style: const TextStyle(
        color: BabylogTheme.primaryDark,
        fontWeight: FontWeight.w900,
        fontSize: 12,
      ),
    );
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0$numberStr';
    }

    return numberStr;
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });
  }
}
