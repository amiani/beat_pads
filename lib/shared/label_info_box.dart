import 'package:flutter/material.dart';

/// A Card-based Info-Text Box Widget that takes an array of Strings and an optional header
class InfoBox extends StatelessWidget {
  const InfoBox({required this.body, this.header, Key? key}) : super(key: key);

  final String? header;
  final List<String> body;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.fromLTRB(8, 30, 8, 8),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (header != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    header!,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ...body
                  .map(
                    (text) => Column(children: [
                      Text(text),
                      SizedBox(
                        height: 5,
                      )
                    ]),
                  )
                  .toList()
            ],
          ),
        ),
      ),
    );
  }
}
