import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PatientEducationPage extends StatelessWidget {
  PatientEducationPage({Key? key}) : super(key: key);

  static const routeName = '/patient-education-page';

  final YoutubePlayerController _video1Controller = YoutubePlayerController(
    initialVideoId: 'PCNTMIcOMpE',
    flags: const YoutubePlayerFlags(
      autoPlay: false,
    ),
  );

  final YoutubePlayerController _video2Controller = YoutubePlayerController(
    initialVideoId: '7MPJauo4DdY',
    flags: const YoutubePlayerFlags(
      autoPlay: false,
    ),
  );

  final YoutubePlayerController _video3Controller = YoutubePlayerController(
    initialVideoId: 'pjmDY3tR6ak',
    flags: const YoutubePlayerFlags(
      autoPlay: false,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const Text(
              'Following are some educational videos for you to watch:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 25,
            ),
            YoutubePlayer(
              controller: _video1Controller,
              showVideoProgressIndicator: true,
              bottomActions: [],
            ),
            const SizedBox(
              height: 25,
            ),
            YoutubePlayer(
              controller: _video2Controller,
              showVideoProgressIndicator: true,
              bottomActions: [],
            ),
            const SizedBox(
              height: 25,
            ),
            YoutubePlayer(
              controller: _video3Controller,
              showVideoProgressIndicator: true,
              bottomActions: [],
            ),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }
}
