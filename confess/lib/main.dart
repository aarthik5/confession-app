import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/post_confession_screen.dart';
import 'screens/moderator_screen.dart';
import 'package:confess/screens/signup_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Confession Wall',
      theme: ThemeData.dark(),
      routes: {
        '/auth': (ctx) => AuthScreen(),
        '/signup': (ctx) => SignUpScreen(),
        '/home': (ctx) => HomeScreen(),
        '/post': (ctx) => PostConfessionScreen(),
        '/moderator': (ctx) => ModeratorScreen(),
      },
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return HomeScreen();
          } else {
            return AuthScreen();
          }
        },
      ),
    );
  }
}
