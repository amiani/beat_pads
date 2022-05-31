import 'package:beat_pads/screen_beat_pads/buttons_controls.dart';
import 'package:beat_pads/screen_beat_pads/buttons_menu.dart';
import 'package:beat_pads/screen_beat_pads/slide_pads.dart';
import 'package:beat_pads/screen_beat_pads/slider_mod_wheel.dart';
import 'package:beat_pads/screen_beat_pads/slider_pitch.dart';
import 'package:beat_pads/screen_beat_pads/slider_velocity.dart';
import 'package:beat_pads/screen_midi_devices/_drawer_devices.dart';

import 'package:flutter/material.dart';
import 'package:beat_pads/services/services.dart';
import 'package:provider/provider.dart';

Future<bool> _doNothing() async => true;

class BeatPadsScreen extends StatelessWidget {
  const BeatPadsScreen({Key? key, this.preview = false}) : super(key: key);

  final bool preview;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: preview ? _doNothing() : DeviceUtils.landscapeOnly(),
      builder: ((context, AsyncSnapshot<bool?> done) {
        if (done.hasData && done.data == true) {
          return Scaffold(
            body: SafeArea(
              child: Consumer<Settings>(builder: (context, settings, _) {
                Size screenSize = MediaQuery.of(context).size;
                return MultiProvider(
                    providers: [
                      // proxyproviders, to update all other models, when Settings change:
                      if (!preview)
                        ChangeNotifierProxyProvider<Settings, MidiReceiver>(
                          create: (context) =>
                              MidiReceiver(context.read<Settings>()),
                          update: (_, settings, midiReceiver) =>
                              midiReceiver!.update(settings),
                        ),
                      ChangeNotifierProxyProvider<Settings, MidiSender>(
                        create: (context) => MidiSender(
                            context.read<Settings>(), screenSize,
                            preview: preview),
                        update: (_, settings, midiSender) =>
                            midiSender!.update(settings, screenSize),
                      ),
                      ChangeNotifierProvider<PadScreenVariables>(
                        create: (context) =>
                            PadScreenVariables(preview: preview),
                      ),
                    ],
                    builder: (context, _) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // SKIP laggy edge area. OS uses edges to detect system gestures
                              // and messes with touch detection
                              const Expanded(
                                flex: 1,
                                child: SizedBox(),
                              ),
                              // CONTROL BUTTONS
                              if (settings.octaveButtons ||
                                  settings.sustainButton)
                                const Expanded(
                                  flex: 5,
                                  child: ControlButtonsRect(),
                                ),
                              // PITCH BEND
                              if (settings.pitchBend)
                                Expanded(
                                  flex: 7,
                                  child: PitchSliderEased(
                                    channel: settings.channel,
                                    resetTime: settings.pitchBendEaseUsable,
                                  ),
                                ),
                              // MOD WHEEL
                              if (settings.modWheel)
                                Expanded(
                                  flex: 7,
                                  child: ModWheel(
                                    channel: settings.channel,
                                  ),
                                ),
                              // VELOCITY
                              if (settings.velocitySlider)
                                Expanded(
                                  flex: 7,
                                  child: SliderVelocity(
                                    channel: settings.channel,
                                    randomVelocity: settings.randomVelocity,
                                  ),
                                ),
                              // PADS
                              const Expanded(
                                flex: 60,
                                child: SlidePads(),
                              ),
                              const Expanded(
                                flex: 1,
                                child: SizedBox(),
                              ),
                            ],
                          ),
                          if (!preview)
                            if (!settings.sustainButton &&
                                !settings.octaveButtons)
                              Builder(builder: (context) {
                                double width =
                                    MediaQuery.of(context).size.width;
                                return Positioned.directional(
                                  top: width * 0.006,
                                  start: width * 0.006,
                                  textDirection: TextDirection.ltr,
                                  child: SizedBox.square(
                                    dimension: width * 0.06,
                                    child: const ReturnToMenuButton(),
                                  ),
                                );
                              }),
                          if (settings.connectedDevices.isEmpty && !preview)
                            Positioned(
                              bottom: 15,
                              right: 15,
                              child: ElevatedButton(
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Palette.lightPink,
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                child: const Text(
                                  "Select Midi Device",
                                ),
                              ),
                            ),
                        ],
                      );
                    });
              }),
            ),
            drawer: const Drawer(
              child: MidiConfig(),
            ),
          );
        }
        return const SizedBox.expand();
      }),
    );
  }
}
