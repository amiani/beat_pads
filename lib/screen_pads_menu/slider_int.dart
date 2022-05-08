import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';

class IntSliderTile extends StatelessWidget {
  const IntSliderTile(
      {this.label = "#label",
      this.subtitle,
      this.min = 0,
      this.max = 128,
      required this.setValue,
      required this.readValue,
      this.resetValue,
      Key? key})
      : super(key: key);

  final String label;
  final String? subtitle;
  final int min;
  final int max;
  final Function setValue;
  final int readValue;
  final Function? resetValue;

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
                  child: Text("Reset"),
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                )
            ],
          ),
          subtitle: subtitle != null ? Text(subtitle!) : null,
          trailing: Text(readValue.toString()),
        ),
        Builder(
          builder: (context) {
            double width = MediaQuery.of(context).size.width;
            return SizedBox(
              width: width * ThemeConst.sliderWidthFactor,
              child: Slider(
                min: min.toDouble(),
                max: max.toDouble(),
                value: readValue.toDouble(),
                onChanged: (value) {
                  setValue(value.toInt());
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
