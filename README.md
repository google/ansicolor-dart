ANSI / Xterm 256 color library for Dart
------

Feel like you're missing some color in your terminal programs? Use AnsiPen to add ANSI color codes to your log messages.  

Easy to disable for production, just set `color_disabled = false` and all codes will be empty - no re-writing debug messages.  

Example
------

Foreground to bright white with default background:
```dart
AnsiPen pen = new AnsiPen()..white(bold: true);
print("${pen}Bright white foreground");
```

Background as a peach, foreground as white:
```dart
AnsiPen pen = new AnsiPen()..white()..rgb(r: 1.0, g: 0.8, b: 0.2);
print("${pen}White foreground with a peach background");
```

Reset all pen colors in the terminal:
```dart
AnsiPen pen = new AnsiPen()..black()..white(bg: true);
print("${pen}Black text on white background ${pen.up}that is now reset to terminal defaults");
```



Rainbow Demo
------

If you want a specific color, you can call the `xterm()` with the index listed in the rainbow below. To show the rainbow on your own terminal, just call `print(ansi_demo());`

![alt tag](https://raw.github.com/google/ansicolor-dart/master/ansicolor-dart.png)
