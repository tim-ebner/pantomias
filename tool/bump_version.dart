// Bumps the `version:` line in pubspec.yaml and prints the resulting
// version string on stdout as the last line, so CI can capture it with
// `$(dart run tool/bump_version.dart [override])`.
//
// With no argument (or an empty one): bumps the patch component and the
// build number by 1, keeping major/minor unchanged.
// With an argument matching X.Y.Z+B: uses that value verbatim as an
// explicit override.
import 'dart:io';

final _versionLine = RegExp(r'^version:\s*(\d+)\.(\d+)\.(\d+)\+(\d+)\s*$');
final _overrideFormat = RegExp(r'^\d+\.\d+\.\d+\+\d+$');

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

  final override = args.isNotEmpty ? args.first.trim() : '';
  final String newVersion;
  if (override.isEmpty) {
    final match = _versionLine.firstMatch(lines[lineIndex])!;
    final major = int.parse(match.group(1)!);
    final minor = int.parse(match.group(2)!);
    final patch = int.parse(match.group(3)!) + 1;
    final build = int.parse(match.group(4)!) + 1;
    newVersion = '$major.$minor.$patch+$build';
  } else {
    if (!_overrideFormat.hasMatch(override)) {
      stderr.writeln(
        'Invalid version override "$override" — expected format X.Y.Z+B',
      );
      exit(1);
    }
    newVersion = override;
  }

  lines[lineIndex] = 'version: $newVersion';
  pubspecFile.writeAsStringSync('${lines.join('\n')}\n');

  // ignore: avoid_print
  print(newVersion);
}
