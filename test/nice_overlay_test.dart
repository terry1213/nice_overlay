import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nice_overlay/nice_overlay.dart';

void main() {
  MaterialApp testWidget({
    required GlobalKey<NavigatorState> navigatorKey,
    required Widget child,
  }) =>
      MaterialApp(
        navigatorKey: navigatorKey,
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) => child,
          ),
        ),
      );

  testWidgets(
    'test NiceOverlay.showInAppNotification()',
    (WidgetTester tester) async {
      GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
      NiceOverlay.init(navigatorKey);
      await tester.pumpWidget(
        testWidget(
          navigatorKey: navigatorKey,
          child: ElevatedButton(
            child: const Text('Show NiceInAppNotification'),
            onPressed: () => NiceOverlay.showInAppNotification(
              NiceInAppNotification(
                title: const Text('title'),
                body: const Text('body'),
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('title'), findsNothing);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(find.text('title'), findsOneWidget);

      await tester.pump(const Duration(seconds: 5));
      expect(find.text('title'), findsNothing);
    },
  );

  testWidgets(
    'test NiceOverlay.isInAppNotificationOpen',
    (WidgetTester tester) async {
      GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
      NiceOverlay.init(navigatorKey);
      await tester.pumpWidget(
        testWidget(
          navigatorKey: navigatorKey,
          child: ElevatedButton(
            child: const Text('Show NiceInAppNotification'),
            onPressed: () => NiceOverlay.showInAppNotification(
              NiceInAppNotification(
                title: const Text('title'),
                body: const Text('body'),
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(NiceOverlay.isInAppNotificationOpen, false);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(NiceOverlay.isInAppNotificationOpen, true);

      await tester.pump(const Duration(seconds: 5));
      expect(NiceOverlay.isInAppNotificationOpen, false);
    },
  );

  testWidgets(
    'test NiceOverlay.closeInAppNotification()',
    (WidgetTester tester) async {
      GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
      NiceOverlay.init(navigatorKey);
      await tester.pumpWidget(
        testWidget(
          navigatorKey: navigatorKey,
          child: ElevatedButton(
            child: const Text('Show NiceInAppNotification'),
            onPressed: () {
              NiceOverlay.showInAppNotification(
                NiceInAppNotification(
                  title: const Text('title'),
                  body: const Text('body'),
                ),
              );
              NiceOverlay.closeInAppNotification();
            },
          ),
        ),
      );

      await tester.pump();
      expect(NiceOverlay.isInAppNotificationOpen, false);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(NiceOverlay.isInAppNotificationOpen, false);
    },
  );

  testWidgets(
    'test NiceOverlay.closeAllInAppNotification()',
    (WidgetTester tester) async {
      GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
      NiceOverlay.init(navigatorKey);
      await tester.pumpWidget(
        testWidget(
          navigatorKey: navigatorKey,
          child: ElevatedButton(
            child: const Text('Show NiceInAppNotification'),
            onPressed: () {
              NiceOverlay.showInAppNotification(
                NiceInAppNotification(
                  title: const Text('title'),
                  body: const Text('body'),
                ),
              );

              NiceOverlay.showInAppNotification(
                NiceInAppNotification(
                  title: const Text('title'),
                  body: const Text('body'),
                ),
              );
              NiceOverlay.closeAllInAppNotification();
            },
          ),
        ),
      );

      await tester.pump();
      expect(NiceOverlay.isInAppNotificationOpen, false);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(NiceOverlay.isInAppNotificationOpen, false);
    },
  );

  testWidgets(
    'test NiceOverlay.clearInAppNotificationQueue()',
    (WidgetTester tester) async {
      GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
      NiceOverlay.init(navigatorKey);
      await tester.pumpWidget(
        testWidget(
          navigatorKey: navigatorKey,
          child: ElevatedButton(
            child: const Text('Show NiceInAppNotification'),
            onPressed: () {
              NiceOverlay.showInAppNotification(
                NiceInAppNotification(
                  title: const Text('title'),
                  body: const Text('body'),
                ),
              );
              NiceOverlay.showInAppNotification(
                NiceInAppNotification(
                  title: const Text('title'),
                  body: const Text('body'),
                ),
              );
              NiceOverlay.clearInAppNotificationQueue();
            },
          ),
        ),
      );
      await tester.pump();
      expect(NiceOverlay.isInAppNotificationOpen, false);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(NiceOverlay.isInAppNotificationOpen, true);

      await tester.pump(const Duration(seconds: 5));
      expect(NiceOverlay.isInAppNotificationOpen, false);
    },
  );

  testWidgets(
    'test NiceOverlay.showSnackBar()',
    (WidgetTester tester) async {
      GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
      NiceOverlay.init(navigatorKey);
      await tester.pumpWidget(
        testWidget(
          navigatorKey: navigatorKey,
          child: ElevatedButton(
            child: const Text('Show NiceSnackBar'),
            onPressed: () => NiceOverlay.showSnackBar(
              NiceSnackBar(message: const Text('NiceSnackBar')),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('NiceSnackBar'), findsNothing);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(find.text('NiceSnackBar'), findsOneWidget);

      await tester.pump(const Duration(seconds: 5));
      expect(find.text('NiceSnackBar'), findsNothing);
    },
  );

  testWidgets(
    'test NiceOverlay.isSnackBarOpen',
    (WidgetTester tester) async {
      GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
      NiceOverlay.init(navigatorKey);
      await tester.pumpWidget(
        testWidget(
          navigatorKey: navigatorKey,
          child: ElevatedButton(
            child: const Text('Show NiceSnackBar'),
            onPressed: () => NiceOverlay.showSnackBar(
              NiceSnackBar(message: const Text('NiceSnackBar')),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(NiceOverlay.isSnackBarOpen, false);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(NiceOverlay.isSnackBarOpen, true);

      await tester.pump(const Duration(seconds: 5));
      expect(NiceOverlay.isSnackBarOpen, false);
    },
  );

  testWidgets(
    'test NiceOverlay.closeSnackBar()',
    (WidgetTester tester) async {
      GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
      NiceOverlay.init(navigatorKey);
      await tester.pumpWidget(
        testWidget(
          navigatorKey: navigatorKey,
          child: ElevatedButton(
            child: const Text('Show NiceSnackBar'),
            onPressed: () {
              NiceOverlay.showSnackBar(
                NiceSnackBar(
                    message: const Text('NiceSnackBar')
                ),
              );
              NiceOverlay.closeSnackBar();
            },
          ),
        ),
      );

      await tester.pump();
      expect(NiceOverlay.isSnackBarOpen, false);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(NiceOverlay.isSnackBarOpen, false);
    },
  );

  testWidgets(
    'test NiceOverlay.closeAllSnackBar()',
    (WidgetTester tester) async {
      GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
      NiceOverlay.init(navigatorKey);
      await tester.pumpWidget(
        testWidget(
          navigatorKey: navigatorKey,
          child: ElevatedButton(
            child: const Text('Show NiceSnackBar'),
            onPressed: () {
              NiceOverlay.showSnackBar(
                NiceSnackBar(
                    message: const Text('NiceSnackBar')
                ),
              );
              NiceOverlay.showSnackBar(
                NiceSnackBar(
                    message: const Text('NiceSnackBar')
                ),
              );
              NiceOverlay.closeAllSnackBar();
            },
          ),
        ),
      );

      await tester.pump();
      expect(NiceOverlay.isSnackBarOpen, false);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(NiceOverlay.isSnackBarOpen, false);
    },
  );

  testWidgets(
    'test NiceOverlay.clearSnackBarQueue()',
    (WidgetTester tester) async {
      GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
      NiceOverlay.init(navigatorKey);
      await tester.pumpWidget(
        testWidget(
          navigatorKey: navigatorKey,
          child: ElevatedButton(
            child: const Text('Show NiceSnackBar'),
            onPressed: () {
              NiceOverlay.showSnackBar(
                NiceSnackBar(
                    message: const Text('NiceSnackBar')
                ),
              );
              NiceOverlay.showSnackBar(
                NiceSnackBar(
                    message: const Text('NiceSnackBar')
                ),
              );
              NiceOverlay.clearSnackBarQueue();
            },
          ),
        ),
      );

      await tester.pump();
      expect(NiceOverlay.isSnackBarOpen, false);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(NiceOverlay.isSnackBarOpen, true);

      await tester.pump(const Duration(seconds: 5));
      expect(NiceOverlay.isSnackBarOpen, false);
    },
  );

  testWidgets(
    'test NiceOverlay.showToast()',
    (WidgetTester tester) async {
      GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
      NiceOverlay.init(navigatorKey);
      await tester.pumpWidget(
        testWidget(
          navigatorKey: navigatorKey,
          child: ElevatedButton(
            child: const Text('Show NiceToast'),
            onPressed: () => NiceOverlay.showToast(
              NiceToast(
                message: const Text('NiceToast'),
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('NiceToast'), findsNothing);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(find.text('NiceToast'), findsOneWidget);

      await tester.pump(const Duration(seconds: 5));
      expect(find.text('NiceToast'), findsNothing);
    },
  );

  testWidgets(
    'test NiceOverlay.isToastOpen',
    (WidgetTester tester) async {
      GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
      NiceOverlay.init(navigatorKey);
      await tester.pumpWidget(
        testWidget(
          navigatorKey: navigatorKey,
          child: ElevatedButton(
            child: const Text('Show NiceToast'),
            onPressed: () => NiceOverlay.showToast(
              NiceToast(
                message: const Text('NiceToast'),
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(NiceOverlay.isToastOpen, false);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(NiceOverlay.isToastOpen, true);

      await tester.pump(const Duration(seconds: 5));
      expect(NiceOverlay.isToastOpen, false);
    },
  );

  testWidgets(
    'test NiceOverlay.closeToast()',
    (WidgetTester tester) async {
      GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
      NiceOverlay.init(navigatorKey);
      await tester.pumpWidget(
        testWidget(
          navigatorKey: navigatorKey,
          child: ElevatedButton(
            child: const Text('Show NiceToast'),
            onPressed: () {
              NiceOverlay.showToast(
                NiceToast(
                  message: const Text('NiceToast'),
                ),
              );
              NiceOverlay.closeToast();
            },
          ),
        ),
      );

      await tester.pump();
      expect(NiceOverlay.isToastOpen, false);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(NiceOverlay.isToastOpen, false);
    },
  );

  testWidgets(
    'test NiceOverlay.closeAllToast()',
    (WidgetTester tester) async {
      GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
      NiceOverlay.init(navigatorKey);
      await tester.pumpWidget(
        testWidget(
          navigatorKey: navigatorKey,
          child: ElevatedButton(
            child: const Text('Show NiceToast'),
            onPressed: () {
              NiceOverlay.showToast(
                NiceToast(
                  message: const Text('NiceToast'),
                ),
              );
              NiceOverlay.showToast(
                NiceToast(
                  message: const Text('NiceToast'),
                ),
              );
              NiceOverlay.closeAllToast();
            },
          ),
        ),
      );

      await tester.pump();
      expect(NiceOverlay.isToastOpen, false);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(NiceOverlay.isToastOpen, false);
    },
  );

  testWidgets(
    'test NiceOverlay.clearToastQueue()',
    (WidgetTester tester) async {
      GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
      NiceOverlay.init(navigatorKey);
      await tester.pumpWidget(
        testWidget(
          navigatorKey: navigatorKey,
          child: ElevatedButton(
            child: const Text('Show NiceToast'),
            onPressed: () {
              NiceOverlay.showToast(
                NiceToast(
                  message: const Text('NiceToast'),
                ),
              );
              NiceOverlay.showToast(
                NiceToast(
                  message: const Text('NiceToast'),
                ),
              );
              NiceOverlay.clearToastQueue();
            },
          ),
        ),
      );

      await tester.pump();
      expect(NiceOverlay.isToastOpen, false);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(NiceOverlay.isToastOpen, true);

      await tester.pump(const Duration(seconds: 5));
      expect(NiceOverlay.isToastOpen, false);
    },
  );
}
