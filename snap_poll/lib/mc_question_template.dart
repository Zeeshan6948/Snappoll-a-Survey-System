import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MultipleChoiceQuestionWidget extends StatefulWidget {
  final String question;
  final List<String> options;
  final ValueChanged<Map<int, bool>> onChanged;

  const MultipleChoiceQuestionWidget({
    Key? key,
    required this.question,
    required this.options,
    required this.onChanged,
  }) : super(key: key);

  @override
  _MultipleChoiceQuestionWidgetState createState() =>
      _MultipleChoiceQuestionWidgetState();
}

class _MultipleChoiceQuestionWidgetState
    extends State<MultipleChoiceQuestionWidget> {
  Map<int, bool> checkedItems = {};

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.question,
              style: GoogleFonts.lato(
                color: Colors.deepPurpleAccent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.options.length,
                itemBuilder: (context, index) {
                  final option = widget.options[index];
                  final isChecked = checkedItems.containsKey(index)
                      ? checkedItems[index]
                      : false;

                  return CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      option,
                      style: GoogleFonts.lato(
                        color: Colors.deepPurpleAccent,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        checkedItems[index] = value!;
                      });

                      widget.onChanged(checkedItems);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
