import 'package:flutter/material.dart';

class SingleChoiceQuestionWidget extends StatefulWidget {
  late final List<String> options;
  final Function(String) onChanged;
  late final String question;

  // ignore: prefer_const_constructors_in_immutables
  SingleChoiceQuestionWidget({
    super.key,
    required this.question,
    required this.options,
    required this.onChanged,
  });

  @override
  State<SingleChoiceQuestionWidget> createState() =>
      _SingleChoiceQuestionWidgetState();
}

/// private State class that goes with SingleChoiceQuestionWidget
class _SingleChoiceQuestionWidgetState
    extends State<SingleChoiceQuestionWidget> {
  String? result;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 80, 8, 40),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.question,
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[800],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: Column(
            children: widget.options
                .map(
                  (option) => Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(255, 94, 126, 214),
                                  offset: Offset(
                                    5.0,
                                    2.0,
                                  ), //Offset
                                  blurRadius: 5.0,
                                  spreadRadius: 3.0,
                                ), //BoxShadow
                                BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(0.0, 0.0),
                                  blurRadius: 0.0,
                                  spreadRadius: 0.0,
                                ), //BoxShadow
                              ],
                            ),
                            child: RadioListTile(
                              title: Text(option),
                              value: option,
                              groupValue: result,
                              onChanged: (value) {
                                setState(() {
                                  result = value as String?;
                                });
                                widget.onChanged(value as String);
                              },
                            )),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {},
              child: const Text('Next'),
            ),
          ],
        )
      ],
    );
  }
}


// Sollen Ergebnisse als Strings oder als Codes/Nummerierungen ausgeliefert werden?

// add Radio (SC) and CheckBox (MC) with dynamic options adding and save it as a map (question, options, type), then work on displaying it in card form