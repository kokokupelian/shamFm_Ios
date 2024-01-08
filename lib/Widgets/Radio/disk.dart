import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import '../../../Helpers/colors.dart';
import '../../../Models/radio.dart';
import '../../../Providers/main_provider.dart';
import '../../../Widgets/image_with_loader.dart';
import 'package:shimmer/shimmer.dart';

class RadioDisk extends StatefulWidget {
  final Size? size;
  final RadioData radio;
  const RadioDisk({Key? key, this.size, required this.radio}) : super(key: key);

  @override
  State<RadioDisk> createState() => _RadioDiskState();
}

class _RadioDiskState extends State<RadioDisk> {
  late MainProvider mainProvider =
      Provider.of<MainProvider>(context, listen: false);

  Widget child({required Size size, Widget? child}) {
    return Neumorphic(
      padding: const EdgeInsets.all(5),
      style: NeumorphicStyle(
        boxShape: const NeumorphicBoxShape.circle(),
        intensity: 1,
        shadowDarkColor: ThemeShadowDark(context),
        shadowLightColor: ThemeShadowLight(context),
      ),
      child: SizedBox(
        height: widget.size?.height ?? size.height * 1 / 10,
        width: widget.size?.height ?? size.height * 1 / 10,
        child: child != null
            ? ClipOval(
                child: ImageWithLoader(
                  imagePath: widget.radio.imageLink,
                  height: widget.size?.height ?? size.height * 1 / 10,
                ),
              )
            : Container(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        mainProvider.setselectedRadio(widget.radio);
        // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
        mainProvider.radioChanged.notifyListeners();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Draggable<RadioData>(
              data: widget.radio,
              feedback: ClipOval(
                child: Image.network(
                  widget.radio.imageLink,
                  height: widget.size?.height ?? size.height * 1 / 10,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress != null) {
                      return Shimmer.fromColors(
                          baseColor: Colors.black12,
                          highlightColor: Colors.black26,
                          child: Image.asset("assets/ShamFMIcon.png"));
                    } else {
                      return child;
                    }
                  },
                ),
              ),
              childWhenDragging: child(size: size),
              child: child(
                size: size,
                child: ClipOval(
                  child: Image.network(
                    widget.radio.imageLink,
                    height: widget.size?.height ?? size.height * 1 / 10,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress != null) {
                        return Shimmer.fromColors(
                            baseColor: Colors.black12,
                            highlightColor: Colors.black26,
                            child: Image.asset("assets/ShamFMIcon.png"));
                      } else {
                        return child;
                      }
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.radio.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
