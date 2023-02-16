import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  YoutubePlayerController? _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = YoutubePlayerController(
        initialVideoId: 'kn9ejUcAbqM',
        flags: YoutubePlayerFlags(autoPlay: false, mute: true, isLive: false));
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.amber,
        progressColors: const ProgressBarColors(
            playedColor: Colors.amber, handleColor: Colors.amberAccent),
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Youtube Player'),
          ),
          body: player,
        );
      },
    );
  }
}
