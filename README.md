A package for controlling overlay components such as in-app notification, toast, and snack bar.

## Features

<img src="https://raw.githubusercontent.com/terry1213/nice_overlay/main/screenshot/in_app_notification.gif" width="320px" />
<img src="https://raw.githubusercontent.com/terry1213/nice_overlay/main/screenshot/snack_bar.gif" width="320px" />
<img src="https://raw.githubusercontent.com/terry1213/nice_overlay/main/screenshot/toast.gif" width="320px" />

* Support all platforms(Implemented only with dart)
* Provide several types of overlays
  * in-app notification
  * toast
  * snack bar
* Various overlay control features
  * set display priority
  * show
  * close
  * close all
  * queued
  * clear queue
  * dismissible
* Easily customizable
  * animation
  * duration
  * shadow
  * vibration
  * color
  * etc


## Hot to use

### Add package in `pubspec.yaml` file.

```yaml
dependencies:
  nice_overlay: ^latest_version
```

### Import package in your dart file.

```dart
import 'package:nice_overlay/nice_overlay.dart';
```

### Create navigator key and call `NiceOverlay.init()`.

```dart
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
NiceOverlay.init(navigatorKey);
```

### Set `MaterialApp`'s `navigatorKey` property by `navigatorKey` we created.

```dart
MaterialApp(
    navigatorKey: navigatorKey,
    // ...
);
```

### Call `NiceOverlay`'s show method.

```dart
// These examples are just very simple examples.
// There are more properties for customizing.
// Please check the Properties part to see other properties!

// in-app notification
NiceOverlay.showInAppNotification(
    NiceInAppNotification(
        title: const Text('In app notification'),
        body: const Text('What a nice in app notification!'),
    ),
);

// snack bar
NiceOverlay.showSnackBar(
    NiceSnackBar(
        message: Text('What a nice snack bar!'),
        action: GestureDetector(
            onTap: NiceOverlay.closeSnackBar,
            child: const Text('close'),
        ),
    ),
);

// toast
NiceOverlay.showToast(
    NiceToast(
        message: const Text('What a nice toast!'),
    ),
);
```

## Properties

### NiceInAppNotification

| name                     | type             |
|--------------------------|------------------|
| title                    | Widget?          |
| body                     | Widget?          |
| onTap                    | void Function()? |
| leading                  | Widget?          |
| trailing                 | Widget?          |
| vibrate                  | bool             |
| displayDuration          | Duration         |
| minimumDisplayDuration   | Duration         |
| dismissDirection         | DismissDirection |
| isDismissible            | bool             |
| showingAnimationCurve    | Curve            |
| showingAnimationDuration | Duration         |
| closingAnimationCurve    | Curve            |
| closingAnimationDuration | Duration         |
| backgroundColor          | Color            |
| boxShadows               | List<BoxShadow>  |
| borderRadius             | BorderRadius     |
| padding                  | EdgeInsets       |
| margin                   | EdgeInsets       |

### NiceSnackBar

| name                     | type                 |
|--------------------------|----------------------|
| message                  | Widget?              |
| action                   | Widget?              |
| vibrate                  | bool                 |
| displayDuration          | Duration             |
| minimumDisplayDuration   | Duration             |
| isDismissible            | bool                 |
| showingAnimationCurve    | Curve                |
| showingAnimationDuration | Duration             |
| closingAnimationCurve    | Curve                |
| closingAnimationDuration | Duration             |
| backgroundColor          | Color                |
| boxShadows               | List<BoxShadow>      |
| borderRadius             | BorderRadius         |
| padding                  | EdgeInsets           |
| margin                   | EdgeInsets           |
| niceSnackBarPosition     | NiceSnackBarPosition |
| useSafeArea              | bool                 |

### NiceToast

| name                     | type              |
|--------------------------|-------------------|
| message                  | Widget?           |
| onTap                    | void Function()?  |
| vibrate                  | bool              |
| displayDuration          | Duration          |
| minimumDisplayDuration   | Duration          |
| dismissDirection         | DismissDirection  |
| isDismissible            | bool              |
| showingAnimationCurve    | Curve             |
| showingAnimationDuration | Duration          |
| closingAnimationCurve    | Curve             |
| closingAnimationDuration | Duration          |
| backgroundColor          | Color             |
| boxShadows               | List<BoxShadow>   |
| borderRadius             | BorderRadius      |
| padding                  | EdgeInsets        |
| margin                   | EdgeInsets        |
| niceToastPosition        | NiceToastPosition |