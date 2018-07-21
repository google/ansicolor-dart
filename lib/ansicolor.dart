///
/// Copyright 2013 Google Inc. All Rights Reserved.
///
/// ANSI/XTERM SGR (Select Graphics Rendering) support for 256 colors.
/// Note: if you're using the dart editor, these won't look right in the
/// terminal; disable via [color_disabled] or use Eclipse with the Dart and
/// AnsiConsol plugins!
///
library ansicolor;

/// Globally enable or disable [AnsiPen] settings
///
/// Handy for turning on and off embedded colors without commenting out code.
bool color_disabled = false;

/// Pen attributes for foreground and background colors.
///
/// Use the pen in string interpolation to output ansi codes.
/// Use [up] in string interpolation to globally reset colors.
class AnsiPen {
  /// Treat a pen instance as a function such that pen("msg") is the same as
  /// pen.write("msg").
  call(String msg) => write(msg);

  /// Allow pen colors to be used in a string.
  ///
  /// Note: Once the pen is down, its attributes remain in effect till they are
  /// changed by another pen or [up].
  String toString() {
    if (color_disabled) return "";
    if (_pen != null) return _pen;

    StringBuffer sb = new StringBuffer();
    if (_fcolor != null) {
      sb.write("${ansi_esc}38;5;${_fcolor}m");
    }

    if (_bcolor != null) {
      sb.write("${ansi_esc}48;5;${_bcolor}m");
    }

    _pen = sb.toString();
    return _pen;
  }

  /// Returns control codes to change the terminal colors.
  String get down => this.toString();

  /// Resets all pen attributes in the terminal.
  String get up => color_disabled ? "" : ansi_default;

  /// Write the [msg] with the pen's current settings and then reset all
  /// attributes.
  String write(String msg) => "${this}$msg$up";

  void black({bool bg: false, bool bold: false}) => _std(0, bold, bg);
  void red({bool bg: false, bool bold: false}) => _std(1, bold, bg);
  void green({bool bg: false, bool bold: false}) => _std(2, bold, bg);
  void yellow({bool bg: false, bool bold: false}) => _std(3, bold, bg);
  void blue({bool bg: false, bool bold: false}) => _std(4, bold, bg);
  void magenta({bool bg: false, bool bold: false}) => _std(5, bold, bg);
  void cyan({bool bg: false, bool bold: false}) => _std(6, bold, bg);
  void white({bool bg: false, bool bold: false}) => _std(7, bold, bg);

  /// Sets the pen color to the rgb value between 0.0..1.0.
  void rgb({r: 1.0, g: 1.0, b: 1.0, bool bg: false}) => xterm(
      (r.clamp(0.0, 1.0) * 5).toInt() * 36 +
          (g.clamp(0.0, 1.0) * 5).toInt() * 6 +
          (b.clamp(0.0, 1.0) * 5).toInt() +
          16,
      bg: bg);

  /// Sets the pen color to a grey scale value between 0.0 and 1.0.
  void gray({level: 1.0, bool bg: false}) =>
      xterm(232 + (level.clamp(0.0, 1.0) * 23).round(), bg: bg);

  void _std(int color, bool bold, bool bg) =>
      xterm(color + (bold ? 8 : 0), bg: bg);

  /// Directly index the xterm 256 color palette.
  void xterm(int color, {bool bg: false}) {
    _pen = null;
    var c = color.toInt().clamp(0, 256);
    if (bg) {
      _bcolor = c;
    } else {
      _fcolor = c;
    }
  }

  ///Resets the pen's attributes.
  void reset() {
    _pen = null;
    _bcolor = _fcolor = null;
  }

  int _fcolor;
  int _bcolor;
  String _pen;
}

/// ANSI Control Sequence Introducer, signals the terminal for new settings.
String get ansi_esc => color_disabled ? "" : '\x1B[';

/// Reset all colors and options for current SGRs to terminal defaults.
String get ansi_default => color_disabled ? "" : "${ansi_esc}0m";

/// Defaults the terminal's foreground color without altering the background.
/// Does not modify [AnsiPen]!
String resetForeground() => "${ansi_esc}39m";

/// Defaults the terminal's background color without altering the foreground.
/// Does not modify [AnsiPen]!
String resetBackground() => "${ansi_esc}49m";
