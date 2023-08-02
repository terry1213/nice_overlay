import 'package:flutter/material.dart';
import 'package:nice_overlay/nice_overlay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    NiceOverlay.init(navigatorKey);
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'NiceOverlay Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text('Show NiceInAppNotification'),
                onPressed: () => NiceOverlay.showInAppNotification(
                  NiceInAppNotification(
                    title: const Text('In app notification'),
                    body: const Text('What a nice in app notification!'),
                    onTap: () => debugPrint('Tap'),
                  ),
                ),
              ),
              ElevatedButton(
                child: const Text('Show NiceSnackBar'),
                onPressed: () => NiceOverlay.showSnackBar(
                  NiceSnackBar(
                    message: const Text('What a nice snack bar!'),
                    action: GestureDetector(
                      onTap: NiceOverlay.closeSnackBar,
                      child: const Text('close'),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                child: const Text('Show NiceToast'),
                onPressed: () => NiceOverlay.showToast(
                  NiceToast(
                    message: const Text('What a nice toast!'),
                    onTap: () => debugPrint('Tap'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
