import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shamfm_ios/Pages/home_page.dart';
import 'package:shamfm_ios/Providers/main_provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MainProvider(),
        )
      ],
      child: NeumorphicApp(
        themeMode: ThemeMode.light,
        theme: NeumorphicThemeData(textTheme: GoogleFonts.cairoTextTheme()),
        home: HomePage(),
      ),
    );
  }
}
