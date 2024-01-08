import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import '../../Providers/main_provider.dart';

class RadioHandler extends BaseAudioHandler {
  AudioPlayer audioPlayer = AudioPlayer();
  late MainProvider mainProvider;

  static final _item = MediaItem(
    id: 'shamFm',
    title: "Radio",
  );

  RadioHandler(BuildContext context, {required String radioLink}) {
    mainProvider = Provider.of<MainProvider>(context, listen: false);
    audioPlayer.playbackEventStream.map(_transformEvent).pipe(playbackState);
    mediaItem.add(_item);
  }

  @override
  Future<void> play() async {
    audioPlayer.setUrl(mainProvider.selectedRadio.link);
    await audioPlayer.play();
  }

  @override
  Future<void> stop() async {
    super.mediaItem.close();
    await audioPlayer.stop();
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.stop,
      ],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[audioPlayer.processingState]!,
      playing: audioPlayer.playing,
      updatePosition: audioPlayer.position,
      bufferedPosition: audioPlayer.bufferedPosition,
      speed: audioPlayer.speed,
      queueIndex: event.currentIndex,
    );
  }
}
