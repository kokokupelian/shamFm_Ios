import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shamfm_ios/Pages/radio_page.dart';
import '../../Helpers/data.dart';
import '../../Providers/main_provider.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500));

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        MainProvider mainProvider =
            Provider.of<MainProvider>(context, listen: false);
        await _controller.forward();

        // if (await Connectivity().checkConnectivity() ==
        //     ConnectivityResult.none) {
        //   await showDialog(
        //     context: context,
        //     builder: (context) {
        //       return AlertDialog(
        //         title: Icon(Icons.wifi_off),
        //         content: Text(
        //           "تأكد من جودة الاتصال بالإنترنت",
        //           textDirection: TextDirection.rtl,
        //           textAlign: TextAlign.center,
        //         ),
        //         actionsAlignment: MainAxisAlignment.start,
        //         actions: [
        //           TextButton(
        //             onPressed: () {
        //               exit(0);
        //             },
        //             child: Text("Exit"),
        //           ),
        //         ],
        //       );
        //     },
        //     barrierDismissible: false,
        //   );
        // }

        WidgetsFlutterBinding.ensureInitialized();

        mainProvider.setRadioList(await GetRadios());
        mainProvider.setisUploaded(await GetUploaded());
        print("done");
        _controller.reverse().then(
              (value) => Navigator.of(context).pushReplacement(
                PageTransition(
                  child: const RadioPage(),
                  type: PageTransitionType.fade,
                  duration: const Duration(milliseconds: 500),
                ),
              ),
            );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        child: Center(
          child: ConstrainedBox(
            constraints:
                BoxConstraints.tight(Size(size.width * 1 / 2, size.height)),
            child: Hero(
              tag: "ShamFmLogo",
              child: Shimmer.fromColors(
                  period: const Duration(seconds: 1),
                  baseColor: Colors.grey.shade600,
                  highlightColor: Colors.grey.shade400,
                  child: Image.asset(
                    "assets/ShamFMLogo.png",
                    color: Colors.grey.shade600,
                  )),
            ),
          ),
        ),
        builder: (context, child) {
          return Opacity(
            opacity: _controller.value,
            child: child,
          );
        },
      ),
    );
  }
}
