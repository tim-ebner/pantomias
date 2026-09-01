// Bumps the `version:` line in pubspec.yaml and prints the resulting
// version string on stdout as the last line, so CI can capture it with
// `$(dart run tool/bump_version.dart [override])`.
//
// The build number always auto-increments by 1 — app stores reject a
// build that doesn't strictly increase, so it's never taken from the
// override, only computed from the current pubspec.yaml.
//
// With no argument (or an empty one): bumps the patch component by 1,
// keeping major/minor unchanged.
// With an argument matching X.Y.Z: uses that as the major.minor.patch,
// still auto-incrementing the build number.
import 'dart:io';

final _versionLine = RegExp(r'^version:\s*(\d+)\.(\d+)\.(\d+)\+(\d+)\s*$');
final _overrideFormat = RegExp(r'^(\d+)\.(\d+)\.(\d+)$');

void main(List<String> args) {
  final pubspecFile = File('pubspec.yaml');
  final lines = pubspecFile.readAsLinesSync();

  final lineIndex = lines.indexWhere(_versionLine.hasMatch);
  if (lineIndex == -1) {
    stderr.writeln(
      'Could not find a version: X.Y.Z+B line in pubspec.yaml',
    );
    exit(1);
  }

  final current = _versionLine.firstMatch(lines[lineIndex])!;
  final build = int.parse(current.group(4)!) + 1;

  final override = args.isNotEmpty ? args.first.trim() : '';
  final int major;
  final int minor;
  final int patch;
  if (override.isEmpty) {
    major = int.parse(current.group(1)!);
    minor = int.parse(current.group(2)!);
    patch = int.parse(current.group(3)!) + 1;
  } else {
    final overrideMatch = _overrideFormat.firstMatch(override);
    if (overrideMatch == null) {
      stderr.writeln(
        'Invalid version override "$override" — expected format X.Y.Z',
      );
      exit(1);
    }
    major = int.parse(overrideMatch.group(1)!);
    minor = int.parse(overrideMatch.group(2)!);
    patch = int.parse(overrideMatch.group(3)!);
  }

  final newVersion = '$major.$minor.$patch+$build';
  lines[lineIndex] = 'version: $newVersion';
  pubspecFile.writeAsStringSync('${lines.join('\n')}\n');

  // ignore: avoid_print
  print(newVersion);
}
