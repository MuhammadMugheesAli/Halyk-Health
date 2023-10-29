import 'package:flutter/material.dart';

class PatientDiseasesHelplines extends StatelessWidget {
  const PatientDiseasesHelplines({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Обращаться за психологической поддержкой можно и по WhatsApp (круглосуточно) по следующим номерам:',
            style: TextStyle(fontSize: 16),
          ),
          SelectableText.rich(
              TextSpan(style: TextStyle(fontSize: 16), children: [
            TextSpan(text: '+ 7 747 102 70 03,'),
            TextSpan(text: '\n+ 7 777 928 73 33,'),
            TextSpan(text: '\n+7 705 234 33 03,'),
            TextSpan(text: '\n+ 7 707 550 08 03.'),
          ])),
        ],
      ),
    );
  }
}
