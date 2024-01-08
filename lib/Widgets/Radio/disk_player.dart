import 'dart:math';
import 'dart:ui';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import '../../../Helpers/colors.dart';
import '../../../Models/radio.dart';
import '../../../Providers/main_provider.dart';
import '../../../Widgets/image_with_loader.dart';

class DiskPlayer extends StatefulWidget {
  final Size? size;
  late final Animation<double> cdAnimation, needleAnimation;
  DiskPlayer(
      {Key? key,
      this.size,
      required this.cdAnimation,
      required this.needleAnimation})
      : super(key: key);

  @override
  State<DiskPlayer> createState() => _DiskPlayerState();
}

class _DiskPlayerState extends State<DiskPlayer>
    with SingleTickerProviderStateMixin {
  late MainProvider mainProvider =
      Provider.of<MainProvider>(context, listen: true);
  late AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 300),
  );
  late Animation<double> _imageScale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linearToEaseOut));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.value = 1;
      mainProvider.radioChanged.addListener(() {
        _controller.forward(from: 0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Image.asset(
            "assets/DiskNeedle.png",
            color: Colors.transparent,
            height: size.height * 1 / 5,
          ),
        ),
        Container(
          height: widget.size?.height ?? size.width * 0.7,
          width: widget.size?.height ?? size.width * 0.7,
          child: Neumorphic(
            style: NeumorphicStyle(
              boxShape: NeumorphicBoxShape.circle(),
              intensity: 1,
              shape: NeumorphicShape.convex,
              shadowDarkColor: ThemeShadowDark(context),
              shadowLightColor: ThemeShadowLight(context),
            ),
            padding: EdgeInsets.all(10),
            child: AnimatedBuilder(
              animation: widget.cdAnimation,
              child: DragTarget<RadioData>(
                onAccept: (value) {
                  mainProvider.setselectedRadio(value);
                  _controller.forward(from: 0);
                },
                builder: (context, _, __) {
                  return AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) => Transform.scale(
                      scale: _imageScale.value,
                      child: ClipOval(
                        child: ImageWithLoader(
                          imagePath: mainProvider.selectedRadio.imageLink,
                          boxFit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
              builder: (context, child) {
                return RotationTransition(
                  turns: widget.cdAnimation,
                  child: child,
                );
              },
            ),
          ),
        ),
        Flexible(
          child: AnimatedBuilder(
            animation: widget.needleAnimation,
            child: Image.asset(
              "assets/DiskNeedle.png",
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey.shade600
                  : Colors.grey.shade700,
              height: size.width * 1 / 3,
            ),
            builder: (context, child) {
              return Transform.rotate(
                angle: lerpDouble(0, pi / 4, widget.needleAnimation.value)!,
                alignment: Alignment.topRight,
                child: child,
              );
            },
          ),
        ),
      ],
    );
  }
}
