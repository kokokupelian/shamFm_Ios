import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:shimmer/shimmer.dart';

class ImageWithLoader extends StatefulWidget {
  final String imagePath;
  final BoxFit boxFit;
  final double? aspectRatio;
  final double? height;
  const ImageWithLoader(
      {Key? key,
      required this.imagePath,
      this.boxFit = BoxFit.cover,
      this.aspectRatio,
      this.height})
      : super(key: key);

  @override
  State<ImageWithLoader> createState() => _ImageWithLoaderState();
}

class _ImageWithLoaderState extends State<ImageWithLoader> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          "assets/ShamFMIcon.png",
          color: Colors.black12,
          height: widget.height,
        ),
        widget.aspectRatio != null
            ? AspectRatio(
                aspectRatio: widget.aspectRatio!,
                child: Image.network(
                  widget.imagePath,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress != null) {
                      return Shimmer.fromColors(
                          child: Image.asset("assets/ShamFMIcon.png"),
                          baseColor: Colors.black12,
                          highlightColor: Colors.black26);
                    } else {
                      return child;
                    }
                  },
                  fit: widget.boxFit,
                ),
              )
            : Image.network(
                widget.imagePath,
                height: widget.height,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) {
                    return Shimmer.fromColors(
                        child: Image.asset("assets/ShamFMIcon.png"),
                        baseColor: Colors.black12,
                        highlightColor: Colors.black26);
                  } else {
                    return child;
                  }
                },
                fit: widget.boxFit,
              ),
      ],
    );
  }
}
