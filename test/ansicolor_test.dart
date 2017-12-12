library ansicolor_test;

import 'package:ansicolor/ansicolor.dart';
import 'package:test/test.dart';

void main() {
  tearDown(() {
    color_disabled = false;
  });

  test('foreground', () {
    AnsiPen pen = new AnsiPen()..rgb(r: 1.0, g: 0.8, b: 0.2);
    expect(pen.write("Test Text"), "\x1B[38;5;221mTest Text\x1B[0m");
  });

  test('background', () {
    AnsiPen pen = new AnsiPen()..rgb(r: 0.4, g: 0.8, b: 1.0, bg: true);
    expect(pen.write("Test Text"), "\x1B[48;5;117mTest Text\x1B[0m");
  });

  test('foreground and background', () {
    AnsiPen pen = new AnsiPen()
      ..rgb(r: 1.0, g: 0.8, b: 0.2)
      ..rgb(r: 0.4, g: 0.8, b: 1.0, bg: true);
    expect(
        pen.write("Test Text"), "\x1B[38;5;221m\x1B[48;5;117mTest Text\x1B[0m");
  });

  test('foreground and background w/ resets', () {
    AnsiPen pen = new AnsiPen()
      ..rgb(r: 1.0, g: 0.8, b: 0.2)
      ..rgb(r: 0.4, g: 0.8, b: 1.0, bg: true);
    expect(pen.write("Test${resetBackground()} Text${resetForeground()}Test"),
        "\x1B[38;5;221m\x1B[48;5;117mTest\x1B[49m Text\x1B[39mTest\x1B[0m");
  });

  test('direct xterm', () {
    AnsiPen pen = new AnsiPen()..xterm(200)..xterm(100, bg: true);
    expect(
        pen.write("Test Text"), "\x1B[38;5;200m\x1B[48;5;100mTest Text\x1B[0m");
  });

  test('call() == write()', () {
    AnsiPen pen = new AnsiPen()
      ..rgb(r: 1.0, g: 0.8, b: 0.2)
      ..rgb(r: 0.4, g: 0.8, b: 1.0, bg: true);
    expect(pen.write("Test Text"), pen("Test Text"));
  });

  test('interpolated == write()', () {
    AnsiPen pen = new AnsiPen()
      ..rgb(r: 1.0, g: 0.8, b: 0.2)
      ..rgb(r: 0.4, g: 0.8, b: 1.0, bg: true);
    expect("${pen}Test Text${pen.up}", pen("Test Text"));
  });

  test('system colors', () {
    AnsiPen pen = new AnsiPen();
    expect((pen..black()).down, "\x1B[38;5;0m");
    expect((pen..red()).down, "\x1B[38;5;1m");
    expect((pen..green()).down, "\x1B[38;5;2m");
    expect((pen..yellow()).down, "\x1B[38;5;3m");
    expect((pen..blue()).down, "\x1B[38;5;4m");
    expect((pen..magenta()).down, "\x1B[38;5;5m");
    expect((pen..cyan()).down, "\x1B[38;5;6m");
    expect((pen..white()).down, "\x1B[38;5;7m");

    expect((pen..black(bold: true)).down, "\x1B[38;5;8m");
    expect((pen..red(bold: true)).down, "\x1B[38;5;9m");
    expect((pen..green(bold: true)).down, "\x1B[38;5;10m");
    expect((pen..yellow(bold: true)).down, "\x1B[38;5;11m");
    expect((pen..blue(bold: true)).down, "\x1B[38;5;12m");
    expect((pen..magenta(bold: true)).down, "\x1B[38;5;13m");
    expect((pen..cyan(bold: true)).down, "\x1B[38;5;14m");
    expect((pen..white(bold: true)).down, "\x1B[38;5;15m");

    expect((pen..reset()).down, "");

    expect((pen..black(bg: true)).down, "\x1B[48;5;0m");
    expect((pen..red(bg: true)).down, "\x1B[48;5;1m");
    expect((pen..green(bg: true)).down, "\x1B[48;5;2m");
    expect((pen..yellow(bg: true)).down, "\x1B[48;5;3m");
    expect((pen..blue(bg: true)).down, "\x1B[48;5;4m");
    expect((pen..magenta(bg: true)).down, "\x1B[48;5;5m");
    expect((pen..cyan(bg: true)).down, "\x1B[48;5;6m");
    expect((pen..white(bg: true)).down, "\x1B[48;5;7m");

    expect((pen..black(bg: true, bold: true)).down, "\x1B[48;5;8m");
    expect((pen..red(bg: true, bold: true)).down, "\x1B[48;5;9m");
    expect((pen..green(bg: true, bold: true)).down, "\x1B[48;5;10m");
    expect((pen..yellow(bg: true, bold: true)).down, "\x1B[48;5;11m");
    expect((pen..blue(bg: true, bold: true)).down, "\x1B[48;5;12m");
    expect((pen..magenta(bg: true, bold: true)).down, "\x1B[48;5;13m");
    expect((pen..cyan(bg: true, bold: true)).down, "\x1B[48;5;14m");
    expect((pen..white(bg: true, bold: true)).down, "\x1B[48;5;15m");
  });

  test('rgb overflow', () {
    AnsiPen pen = new AnsiPen()
      ..rgb(r: 2.0, g: 2.8, b: 2.2)
      ..rgb(r: 2.4, g: 2.8, b: 2.0, bg: true);
    expect(
        pen.write("Test Text"), "\x1B[38;5;231m\x1B[48;5;231mTest Text\x1B[0m");
  });

  test('rgb underflow', () {
    AnsiPen pen = new AnsiPen()
      ..rgb(r: -1.0, g: -2.8, b: -2.2)
      ..rgb(r: -1.0, g: -2.8, b: -2.0, bg: true);
    expect(
        pen.write("Test Text"), "\x1B[38;5;16m\x1B[48;5;16mTest Text\x1B[0m");
  });

  test('grayscale', () {
    AnsiPen pen = new AnsiPen();

    for (int i = 0; i < 24; i++) {
      expect((pen..gray(level: i / 23)).down, "\x1B[38;5;${232 + i}m",
          reason: "fg failed at $i");
    }

    expect((pen..reset()).down, "");

    for (int i = 0; i < 24; i++) {
      expect((pen..gray(level: i / 23, bg: true)).down, "\x1B[48;5;${232 + i}m",
          reason: "bg failed at $i");
    }
  });

  test('color_disabled', () {
    color_disabled = false;
    AnsiPen pen = new AnsiPen()
      ..rgb(r: 1.0, g: 0.8, b: 0.2)
      ..rgb(r: 0.4, g: 0.8, b: 1.0, bg: true);
    color_disabled = true;
    expect(pen.write("Test Text"), "Test Text");
  });
}
