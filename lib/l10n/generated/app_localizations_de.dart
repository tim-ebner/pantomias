// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Pantomias';

  @override
  String get startTileTitle => 'Los geht\'s!';

  @override
  String get quickStartLabel => 'Schnellstart';

  @override
  String get scoredGameModeLabel => 'Spiel mit Punkten';

  @override
  String get nextImageLabel => 'Nächstes Bild';

  @override
  String get modeSelectionTooltip => 'Modusauswahl';

  @override
  String roundLabel(int round) {
    return 'Runde $round';
  }

  @override
  String roundLabelWithLimit(int round, int limit) {
    return 'Runde $round von $limit';
  }

  @override
  String activePlayerLabel(String name) {
    return 'Am Zug: $name';
  }

  @override
  String get notGuessedLabel => 'Falsch';

  @override
  String get guessedLabel => 'Erraten';

  @override
  String get timeExpiredLabel => 'Zeit abgelaufen';

  @override
  String get imageHiddenLabel => 'Versteckt';

  @override
  String get addPlayerLabel => 'Spieler hinzufügen';

  @override
  String playerLabel(int number) {
    return 'Spieler $number';
  }

  @override
  String get removePlayerTooltip => 'Spieler entfernen';

  @override
  String get roundsOptionalLabel => 'Runden (optional)';

  @override
  String get positiveRoundsError => 'Bitte positive Rundenzahl eingeben';

  @override
  String get timeOptionalLabel => 'Zeit (Min:Sek, optional)';

  @override
  String get positiveTimeError => 'Bitte positive Zeit eingeben';

  @override
  String get increaseTooltip => 'Erhöhen';

  @override
  String get decreaseTooltip => 'Verringern';

  @override
  String get startGameLabel => 'Spiel starten';

  @override
  String get resultsTitle => 'Ergebnis';

  @override
  String get resultsSubtitle => 'Super gespielt! Alle sind Gewinner! 😉';

  @override
  String get newScoredGameLabel => 'Neues Punktespiel';

  @override
  String scoreLabel(int score) {
    String _temp0 = intl.Intl.pluralLogic(
      score,
      locale: localeName,
      other: '$score Pkt',
      one: '$score Pkt',
    );
    return '$_temp0';
  }

  @override
  String get winnerPraise1 => 'Souveräner Auftritt!';

  @override
  String get winnerPraise2 => 'Super Spiel!';

  @override
  String get winnerPraise3 => 'Beschde!';

  @override
  String get winnerPraise4 => 'Geil Geil Geil!';

  @override
  String get winnerPraise5 => 'Abgeliefert!';

  @override
  String get winnerPraise6 => 'Päääm!';

  @override
  String get winnerBadgeLabel => '1. PLATZ';

  @override
  String rankLabel(int rank) {
    return '$rank. Platz';
  }

  @override
  String get promptCat => 'Katze';

  @override
  String get promptDog => 'Hund';

  @override
  String get promptWizard => 'Zauberer';

  @override
  String get promptAnt => 'Ameise';

  @override
  String get promptBackpack => 'Rucksack';

  @override
  String get promptBaker => 'Bäcker';

  @override
  String get promptBee => 'Biene';

  @override
  String get promptBicycle => 'Fahrrad';

  @override
  String get promptBunny => 'Hase';

  @override
  String get promptBurger => 'Burger';

  @override
  String get promptClimbing => 'Klettern';

  @override
  String get promptDancing => 'Tanzen';

  @override
  String get promptDragon => 'Drache';

  @override
  String get promptEgg => 'Ei';

  @override
  String get promptFarmer => 'Bauer';

  @override
  String get promptFish => 'Fisch';

  @override
  String get promptFondue => 'Fondue';

  @override
  String get promptFork => 'Gabel';

  @override
  String get promptHero => 'Held';

  @override
  String get promptKnight => 'Ritter';

  @override
  String get promptLama => 'Lama';

  @override
  String get promptNinja => 'Ninja';

  @override
  String get promptPenguin => 'Pinguin';

  @override
  String get promptPirate => 'Pirat';

  @override
  String get promptReindeer => 'Rentier';

  @override
  String get promptShip => 'Schiff';

  @override
  String get promptSkiing => 'Skifahren';

  @override
  String get promptSnake => 'Schlange';

  @override
  String get promptSpaghetti => 'Spaghetti';

  @override
  String get promptSquirrel => 'Eichhörnchen';

  @override
  String get promptStorm => 'Sturm';

  @override
  String get promptTree => 'Baum';

  @override
  String get promptUmbrella => 'Regenschirm';

  @override
  String get promptUnicorn => 'Einhorn';

  @override
  String get promptVolleyball => 'Volleyball';

  @override
  String get promptMonkey => 'Affe';

  @override
  String get promptOpenBook => 'Offenes Buch';

  @override
  String get promptSoccerBall => 'Fußball';

  @override
  String get promptAlarmClock => 'Wecker';

  @override
  String get promptBalloon => 'Ballon';

  @override
  String get promptBeanie => 'Mütze';

  @override
  String get promptBear => 'Bär';

  @override
  String get promptBee2 => 'Biene';

  @override
  String get promptBird => 'Vogel';

  @override
  String get promptBlanket => 'Decke';

  @override
  String get promptBroom => 'Besen';

  @override
  String get promptBucket => 'Eimer';

  @override
  String get promptButterfly => 'Schmetterling';

  @override
  String get promptCamel => 'Kamel';

  @override
  String get promptCamera => 'Kamera';

  @override
  String get promptChair => 'Stuhl';

  @override
  String get promptChicken => 'Huhn';

  @override
  String get promptCow => 'Kuh';

  @override
  String get promptCrab => 'Krabbe';

  @override
  String get promptCrocodile => 'Krokodil';

  @override
  String get promptCup => 'Tasse';

  @override
  String get promptDeer => 'Hirsch';

  @override
  String get promptDolphin => 'Delfin';

  @override
  String get promptDrums => 'Schlagzeug';

  @override
  String get promptDuck => 'Ente';

  @override
  String get promptEagle => 'Adler';

  @override
  String get promptElephant => 'Elefant';

  @override
  String get promptFlashlight => 'Taschenlampe';

  @override
  String get promptFloorLamp => 'Stehlampe';

  @override
  String get promptFlute => 'Flöte';

  @override
  String get promptFox => 'Fuchs';

  @override
  String get promptFrog => 'Frosch';

  @override
  String get promptGift => 'Geschenk';

  @override
  String get promptGiraffe => 'Giraffe';

  @override
  String get promptGlasses => 'Brille';

  @override
  String get promptGloves => 'Handschuhe';

  @override
  String get promptGoat => 'Ziege';

  @override
  String get promptGuineaPig => 'Meerschweinchen';

  @override
  String get promptGuitar => 'Gitarre';

  @override
  String get promptHamster => 'Hamster';

  @override
  String get promptHat => 'Hut';

  @override
  String get promptHedgehog => 'Igel';

  @override
  String get promptKey => 'Schlüssel';

  @override
  String get promptLadybug => 'Marienkäfer';

  @override
  String get promptLeopard => 'Leopard';

  @override
  String get promptLion => 'Löwe';

  @override
  String get promptMirror => 'Spiegel';

  @override
  String get promptMobile => 'Handy';

  @override
  String get promptMouse => 'Maus';

  @override
  String get promptOwl => 'Eule';

  @override
  String get promptPanda => 'Panda';

  @override
  String get promptParrot => 'Papagei';

  @override
  String get promptPelican => 'Pelikane';

  @override
  String get promptPencil => 'Bleistift';

  @override
  String get promptPenguin2 => 'Pinguin';

  @override
  String get promptPig => 'Schwein';

  @override
  String get promptPillow => 'Kissen';

  @override
  String get promptPlate => 'Teller';

  @override
  String get promptRabbit => 'Kaninchen';

  @override
  String get promptRemoteControl => 'Fernbedienung';

  @override
  String get promptRope => 'Seil';

  @override
  String get promptRuler => 'Lineal';

  @override
  String get promptScarf => 'Schal';

  @override
  String get promptScissors => 'Schere';

  @override
  String get promptScooter => 'Roller';

  @override
  String get promptShark => 'Hai';

  @override
  String get promptSheep => 'Schaf';

  @override
  String get promptSheetOfPaper => 'Blatt Papier';

  @override
  String get promptSkateboard => 'Skateboard';

  @override
  String get promptSledge => 'Schlitten';

  @override
  String get promptSlide => 'Rutsche';

  @override
  String get promptSnail => 'Schnecke';

  @override
  String get promptSoap => 'Seife';

  @override
  String get promptSpider => 'Spinne';

  @override
  String get promptSpoon => 'Löffel';

  @override
  String get promptStarfish => 'Seestern';

  @override
  String get promptSuitcase => 'Koffer';

  @override
  String get promptSwing => 'Schaukel';

  @override
  String get promptTable => 'Tisch';

  @override
  String get promptTelevision => 'Fernseher';

  @override
  String get promptTiger => 'Tiger';

  @override
  String get promptToothbrush => 'Zahnbürste';

  @override
  String get promptTowel => 'Handtuch';

  @override
  String get promptTurtle => 'Schildkröte';

  @override
  String get promptWatch => 'Uhr';

  @override
  String get promptWhale => 'Wal';

  @override
  String get promptWolf => 'Wolf';

  @override
  String get promptZebra => 'Zebra';
}
