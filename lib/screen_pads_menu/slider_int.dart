import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';

class IntSliderTile extends StatelessWidget {
  const IntSliderTile({
    required this.setValue,
    required this.readValue,
    required this.trailing,
    this.label = '#label',
    this.subtitle,
    this.min = 0,
    this.max = 128,
    this.resetValue,
    this.onChangeEnd,
    super.key,
  });

  final void Function()? onChangeEnd;
  final String label;
  final String? subtitle;
  final int min;
  final int max;
  final int readValue;
  final void Function(int) setValue;
  final void Function()? resetValue;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Row(
            children: [
              Text(label),
              if (resetValue != null)
                TextButton(
                  onPressed: () => resetValue!(),
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Reset'),
                ),
            ],
          ),
          subtitle: subtitle != null ? Text(subtitle!) : null,
          trailing: Text(
            trailing,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Builder(
          builder: (context) {
            final double width = MediaQuery.of(context).size.width;
            return SizedBox(
              width: width * ThemeConst.sliderWidthFactor,
              child: Slider(
                min: min.toDouble(),
                max: max.toDouble(),
                value: readValue.clamp(min, max).toDouble(),
                onChanged: (value) {
                  setValue(value.toInt());
                },
                onChangeEnd: (_) {
                  onChangeEnd?.call();
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
