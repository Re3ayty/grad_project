import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/responsive_text.dart';

class MultiSelectDialog extends StatefulWidget {
  final List<String> days;
  final List<String> selectedDays;

  MultiSelectDialog({required this.days, required this.selectedDays});

  @override
  _MultiSelectDialogState createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  late List<String> tempSelectedDays;

  @override
  void initState() {
    super.initState();
    tempSelectedDays = widget.selectedDays;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Days',
        style: GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w400,),
          textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context),
        ),),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.days.map((day) {
            return CheckboxListTile(
              value: tempSelectedDays.contains(day),
              title: Text(day),
              onChanged: (bool? selected) {
                setState(() {
                  if (selected!) {
                    tempSelectedDays.add(day);
                  } else {
                    tempSelectedDays.remove(day);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel',style: GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w500,),
      textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context),)),
          onPressed: () {
            Navigator.of(context).pop(widget.selectedDays);
          },
        ),
        TextButton(
          child: Text('OK',style: GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w500,),
    textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context),)),
          onPressed: () {
            Navigator.of(context).pop(tempSelectedDays);
          },
        ),
      ],
    );
  }
}
