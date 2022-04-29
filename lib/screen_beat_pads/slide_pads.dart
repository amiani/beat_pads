import 'package:beat_pads/screen_beat_pads/slide_pad.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:beat_pads/shared/_shared.dart';
import 'package:beat_pads/services/_services.dart';

class SlidePads extends StatefulWidget {
  const SlidePads({Key? key}) : super(key: key);
  @override
  State<SlidePads> createState() => _SlidePadsState();
}

class _SlidePadsState extends State<SlidePads> {
  final GlobalKey _padsWidgetKey = GlobalKey();

  int? _detectTappedItem(PointerEvent event) {
    final BuildContext? context = _padsWidgetKey.currentContext;
    if (context == null) return null;

    final RenderBox? box = context.findAncestorRenderObjectOfType<RenderBox>();
    if (box == null) return null;

    final Offset localOffset = box.globalToLocal(event.position);
    final BoxHitTestResult results = BoxHitTestResult();

    if (box.hitTest(results, position: localOffset)) {
      for (final HitTestEntry<HitTestTarget> hit in results.path) {
        final HitTestTarget target = hit.target;
        if (target is TestProxyBox) {
          return target.index >= 0 && target.index < 128 ? target.index : null;
        }
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProxyProvider<Settings, MidiReceiver>(
          create: (context) => MidiReceiver(context.read<Settings>()),
          update: (_, settings, midiReceiver) => midiReceiver!.update(settings),
        ),
        ChangeNotifierProxyProvider<Settings, MidiSender>(
          create: (context) => MidiSender(context.read<Settings>()),
          update: (_, settings, midiSender) => midiSender!.update(settings),
        ),
        ChangeNotifierProvider(create: ((context) => AftertouchModel()))
      ],
      builder: (context, child) {
        bool aT = true;
        return Stack(
          children: [
            Listener(
              onPointerDown: (touch) {
                int? result = _detectTappedItem(touch);
                if (mounted && result != null) {
                  context.read<MidiSender>().push(touch, result);
                  if (aT) context.read<AftertouchModel>().push(touch, result);
                }
              },
              onPointerMove: (touch) {
                if (mounted) {
                  int? result = _detectTappedItem(touch);
                  // ignore: dead_code
                  if (!aT) context.read<MidiSender>().move(touch, result);
                  if (aT) context.read<AftertouchModel>().move(touch);
                }
              },
              onPointerUp: (touch) {
                if (mounted) {
                  int? result = _detectTappedItem(touch);
                  context.read<MidiSender>().lift(touch, result);
                  if (aT) context.read<AftertouchModel>().lift(touch);
                }
              },
              onPointerCancel: (touch) {
                if (mounted) {
                  int? result = _detectTappedItem(touch);
                  context.read<MidiSender>().lift(touch, result);
                  if (aT) context.read<AftertouchModel>().lift(touch);
                }
              },
              child: Column(
                // Hit testing happens on this keyed Widget, which contains all the pads:
                key: _padsWidgetKey,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...context.watch<Settings>().rows.map(
                    (row) {
                      return Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ...row.map(
                              (note) {
                                return Expanded(
                                  flex: 1,
                                  child: HitTestObject(
                                    index: note,
                                    child: SlideBeatPad(note: note),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            if (aT) PaintAfterTouchLines(),
          ],
        );
      },
    );
  }
}
