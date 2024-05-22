import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

Future<void> bootstrap(Future<Widget> Function() builder) async {
  const double windowWidth = 400;
  const double windowHeight = 800;

  void setupWindow() {
    if (!kIsWeb &&
        (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      WidgetsFlutterBinding.ensureInitialized();
      setWindowTitle('Provider Demo');
      setWindowMinSize(const Size(windowWidth, windowHeight));
      setWindowMaxSize(const Size(windowWidth, windowHeight));
      getCurrentScreen().then((screen) {
        setWindowFrame(Rect.fromCenter(
          center: screen!.frame.center,
          width: windowWidth,
          height: windowHeight,
        ));
      });
    }
  }

  runApp(await builder());
}
