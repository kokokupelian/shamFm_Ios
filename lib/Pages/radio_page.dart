import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import '../../../Helpers/colors.dart';
import '../../../Providers/main_provider.dart';
import '../../../Widgets/Radio/disk.dart';
import '../../../Widgets/Radio/disk_player.dart';

class RadioPage extends StatefulWidget {
  const RadioPage({Key? key}) : super(key: key);

  @override
  State<RadioPage> createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _needleController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500));
  late final Animation<double> _needleAnimation =
      Tween<double>(begin: 0, end: 1).animate(
    _needleController,
  );
  late final Animation<double> _diskOpacity =
      Tween<double>(begin: 1, end: 0).animate(
    _needleController,
  );
  late final AnimationController _cdController =
      AnimationController(vsync: this, duration: const Duration(seconds: 8));
  late final Animation<double> _cdAnimation =
      Tween<double>(begin: 0, end: 1).animate(
    _cdController,
  );
  late MainProvider mainProvider =
      Provider.of<MainProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _needleController.addListener(() async {
      if (_needleController.isCompleted) {
        Future.delayed(const Duration(milliseconds: 250))
            .then((value) => _cdController.repeat());
      }
    });

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        if (!mainProvider.isRadioInit) {
          await mainProvider.initRadio(context);
        }
        mainProvider.audioHandler.playbackState.listen(
          (event) {
            if (event.playing) {
              _needleController.forward();
            } else {
              _stop();
            }
          },
        );
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if (mainProvider.audioHandler.playbackState.value.playing) {
        if (!_needleController.isAnimating) {
          _needleController.forward();
        }
      } else {
        if (_cdController.isAnimating) {
          _stop(instant: true);
        }
      }
    }
  }

  _stop({bool instant = false}) async {
    if (instant) {
      _cdController.stop();
      _needleController.value = 0;
      _cdController.value = 0;
    } else {
      _cdController
          .animateBack(_cdController.value > 0.5 ? 1 : 0,
              duration: const Duration(milliseconds: 500))
          .then(
        (value) {
          _needleController.reverse();
          _cdController.value = 0;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: NeumorphicAppBar(
        title: Text("Sham Fm",
            style: GoogleFonts.cairo(
              fontSize: 30,
              color: Colors.grey.shade800,
            )),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _needleController,
                builder: (context, child) => AbsorbPointer(
                  absorbing: _diskOpacity.isCompleted,
                  child: Opacity(
                    opacity: _diskOpacity.value,
                    child: SizedBox(
                      width: size.width,
                      height: size.height * 1 / 10,
                      child: Wrap(
                        children: [
                          ...mainProvider.radio
                              .map((e) => RadioDisk(radio: e))
                              .toList(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              DiskPlayer(
                  cdAnimation: _cdAnimation, needleAnimation: _needleAnimation),
              NeumorphicButton(
                margin: const EdgeInsets.all(25),
                style: NeumorphicStyle(
                  boxShape: const NeumorphicBoxShape.circle(),
                  intensity: 1,
                  shape: NeumorphicShape.convex,
                  shadowDarkColor: ThemeShadowDark(context),
                  shadowLightColor: ThemeShadowLight(context),
                ),
                child: AnimatedBuilder(
                  animation: _needleController,
                  builder: (context, child) => AnimatedSwitcher(
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    duration: const Duration(milliseconds: 300),
                    child: _needleController.isCompleted
                        ? Icon(
                            Icons.stop,
                            key: const Key("stop_icon"),
                            size: 45,
                            color: Colors.grey.shade600,
                          )
                        : Icon(
                            Icons.play_arrow,
                            key: const Key("play_icon"),
                            size: 45,
                            color: Colors.grey.shade600,
                          ),
                  ),
                ),
                onPressed: () async {
                  if (mainProvider.audioHandler.playbackState.value.playing) {
                    mainProvider.audioHandler.stop();
                    _stop();
                  } else {
                    await mainProvider.audioHandler.play();
                  }
                },
              ),
              const Spacer(
                flex: 2,
              ),
              Container(
                color: Colors.black38,
                width: size.width,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextButton(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero, elevation: 0),
                    onPressed: () {
                      launchUrlString("http://shamfmapp.ulcode.dev");
                    },
                    child: Text(
                      """All Rights Reserved 2007-${DateTime.now().year}
Developed By ULCode | Powered By UNLimited World""",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
