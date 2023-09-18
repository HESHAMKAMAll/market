import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:market/stripe_payment/stripe_keys.dart';
import 'package:market/views/auth/login_screen.dart';
import 'package:market/views/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controller/theme.dart';
import 'firebase_options.dart';

// late bool isLogin ;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SharedPreferences pref = await SharedPreferences.getInstance();
  Stripe.publishableKey = ApiKeys.publishableKey;
  // var user = FirebaseAuth.instance.currentUser ;
  // if(user == null){
  //   isLogin = false ;
  // }else{
  //   isLogin = true ;
  // }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyTheme()),
        // ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      builder: (context, child) {
        return MaterialApp(
          title: 'Market',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Provider.of<MyTheme>(context).theme,
            primaryColor: Provider.of<MyTheme>(context).primaryColor,
            // primaryColor: Colors.lightBlue[800],
            // textTheme: TextTheme(
            //   displayLarge: GoogleFonts.acme(),
            //   titleLarge: GoogleFonts.acme(),
            //   bodyMedium: GoogleFonts.acme(),
            //   bodyLarge: GoogleFonts.acme(),
            //   bodySmall: GoogleFonts.acme(),
            //   labelLarge: GoogleFonts.acme(),
            //   displayMedium: GoogleFonts.acme(),
            //   displaySmall: GoogleFonts.acme(),
            //   headlineMedium: GoogleFonts.acme(),
            //   headlineSmall: GoogleFonts.acme(),
            //   titleSmall: GoogleFonts.acme(),
            //   titleMedium: GoogleFonts.acme(),
            //   labelSmall: GoogleFonts.acme(),
            //   labelMedium: GoogleFonts.acme(),
            //   headlineLarge: GoogleFonts.acme(),
            // ),
          ),
          // home: isLogin == false ? LoginScreen() : MainScreen(),
          // home: MainScreen(),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return MainScreen();
                } else if (snapshot.hasError) {
                  return Center(child: Text("${snapshot.error}"));
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor));
              }
              return LoginScreen();
            },
          ),
        );
      },
    );
  }
}
