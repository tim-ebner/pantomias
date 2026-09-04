import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pantomias/l10n/l10n.dart';
import 'package:pantomias/shared/widgets/stage_card.dart';

void main() {
  Future<void> pumpStageCard(WidgetTester tester, {required String word}) {
    return tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 300.0,
              height: 400.0,
              child: StageCard(
                isRevealed: true,
                promptWord: word,
                imageAssetPath: null,
                feedback: null,
                onTap: () {},
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('short word renders at full size on one line', (tester) async {
    await pumpStageCard(tester, word: 'Hund');

    final headline = tester.widget<Text>(find.text('Hund'));

    expect(headline.style?.fontSize, 44.0);
    expect(headline.maxLines, 1);
  });

  testWidgets('long compound word shrinks below the max font size', (
    tester,
  ) async {
    const longWord = 'Basketballspielerin';
    await pumpStageCard(tester, word: longWord);

    final headline = tester.widget<Text>(find.text(longWord));

    expect(headline.style?.fontSize, lessThan(44.0));
    expect(headline.style?.fontSize, greaterThanOrEqualTo(24.0));
  });
}
