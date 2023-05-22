import 'dart:math';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:just_waveform/just_waveform.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:suntzu/core/constants/constants.dart';

AppSize _appSize = AppSize();

class ChapterWidget extends StatefulWidget {
  const ChapterWidget({super.key});

  @override
  State<ChapterWidget> createState() => _ChapterWidgetState();
}

class _ChapterWidgetState extends State<ChapterWidget> {
  RecorderController controller = RecorderController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      padding: const EdgeInsets.all(15),
      height: 150,
      decoration: BoxDecoration(
        color: contentColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 30,
            width: _appSize.widthApp(context),
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Center(
              child: Text(
                "Article II De l'engagement",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Divider(
            thickness: 1.5,
            color: textColor,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    height: 40,
                    width: 40,
                    // margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: textColor,
                    ),
                    child: Center(
                      child: Icon(
                        LucideIcons.play,
                        color: contentColor,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                AudioWaveforms(
                  size: const Size(230, 50.0),
                  recorderController: controller,
                  enableGesture: true,
                  waveStyle: const WaveStyle(
                    waveColor: Colors.white,
                    showDurationLabel: true,
                    spacing: 8.0,
                    showBottom: false,
                    extendWaveform: true,
                    showMiddleLine: false,
                  ),
                ),
                /*AudioWave(
                  height: 50,
                  animation: false,
                  width: 230,
                  spacing: 7,
                  animationLoop: 3,
                  bars: List.generate(
                    waveHeightFactors.length,
                    (index) => AudioWaveBar(
                        heightFactor: waveHeightFactors[index],
                        color: textColor),
                  ),
                ),*/
                Text(
                  '03:25',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AudioWaveformWidget extends StatefulWidget {
  final Color waveColor;
  final double scale;
  final double strokeWidth;
  final double pixelsPerStep;
  final Waveform waveform;
  final Duration start;
  final Duration duration;

  const AudioWaveformWidget({
    Key? key,
    required this.waveform,
    required this.start,
    required this.duration,
    this.waveColor = Colors.blue,
    this.scale = 1.0,
    this.strokeWidth = 5.0,
    this.pixelsPerStep = 8.0,
  }) : super(key: key);

  @override
  State<AudioWaveformWidget> createState() => _AudioWaveformState();
}

class _AudioWaveformState extends State<AudioWaveformWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: CustomPaint(
        painter: AudioWaveformPainter(
          waveColor: widget.waveColor,
          waveform: widget.waveform,
          start: widget.start,
          duration: widget.duration,
          scale: widget.scale,
          strokeWidth: widget.strokeWidth,
          pixelsPerStep: widget.pixelsPerStep,
        ),
      ),
    );
  }
}

class AudioWaveformPainter extends CustomPainter {
  final double scale;
  final double strokeWidth;
  final double pixelsPerStep;
  final Paint wavePaint;
  final Waveform waveform;
  final Duration start;
  final Duration duration;

  AudioWaveformPainter({
    required this.waveform,
    required this.start,
    required this.duration,
    Color waveColor = Colors.blue,
    this.scale = 1.0,
    this.strokeWidth = 5.0,
    this.pixelsPerStep = 8.0,
  }) : wavePaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round
          ..color = waveColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (duration == Duration.zero) return;

    double width = size.width;
    double height = size.height;

    final waveformPixelsPerWindow = waveform.positionToPixel(duration).toInt();
    final waveformPixelsPerDevicePixel = waveformPixelsPerWindow / width;
    final waveformPixelsPerStep = waveformPixelsPerDevicePixel * pixelsPerStep;
    final sampleOffset = waveform.positionToPixel(start);
    final sampleStart = -sampleOffset % waveformPixelsPerStep;
    for (var i = sampleStart.toDouble();
        i <= waveformPixelsPerWindow + 1.0;
        i += waveformPixelsPerStep) {
      final sampleIdx = (sampleOffset + i).toInt();
      final x = i / waveformPixelsPerDevicePixel;
      final minY = normalise(waveform.getPixelMin(sampleIdx), height);
      final maxY = normalise(waveform.getPixelMax(sampleIdx), height);
      canvas.drawLine(
        Offset(x + strokeWidth / 2, max(strokeWidth * 0.75, minY)),
        Offset(x + strokeWidth / 2, min(height - strokeWidth * 0.75, maxY)),
        wavePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant AudioWaveformPainter oldDelegate) {
    return false;
  }

  double normalise(int s, double height) {
    if (waveform.flags == 0) {
      final y = 32768 + (scale * s).clamp(-32768.0, 32767.0).toDouble();
      return height - 1 - y * height / 65536;
    } else {
      final y = 128 + (scale * s).clamp(-128.0, 127.0).toDouble();
      return height - 1 - y * height / 256;
    }
  }
}
