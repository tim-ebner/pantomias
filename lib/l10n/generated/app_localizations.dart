import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In de, this message translates to:
  /// **'Pantomias'**
  String get appTitle;

  /// No description provided for @startTileTitle.
  ///
  /// In de, this message translates to:
  /// **'Los geht\'s!'**
  String get startTileTitle;

  /// No description provided for @quickStartLabel.
  ///
  /// In de, this message translates to:
  /// **'Schnellstart'**
  String get quickStartLabel;

  /// No description provided for @scoredGameModeLabel.
  ///
  /// In de, this message translates to:
  /// **'Spiel mit Punkten'**
  String get scoredGameModeLabel;

  /// No description provided for @nextImageLabel.
  ///
  /// In de, this message translates to:
  /// **'Nächstes Bild'**
  String get nextImageLabel;

  /// No description provided for @modeSelectionTooltip.
  ///
  /// In de, this message translates to:
  /// **'Modusauswahl'**
  String get modeSelectionTooltip;

  /// No description provided for @roundLabel.
  ///
  /// In de, this message translates to:
  /// **'Runde {round}'**
  String roundLabel(int round);

  /// No description provided for @roundLabelWithLimit.
  ///
  /// In de, this message translates to:
  /// **'Runde {round} von {limit}'**
  String roundLabelWithLimit(int round, int limit);

  /// No description provided for @activePlayerLabel.
  ///
  /// In de, this message translates to:
  /// **'Am Zug: {name}'**
  String activePlayerLabel(String name);

  /// No description provided for @notGuessedLabel.
  ///
  /// In de, this message translates to:
  /// **'Falsch'**
  String get notGuessedLabel;

  /// No description provided for @guessedLabel.
  ///
  /// In de, this message translates to:
  /// **'Erraten'**
  String get guessedLabel;

  /// No description provided for @timeExpiredLabel.
  ///
  /// In de, this message translates to:
  /// **'Zeit abgelaufen'**
  String get timeExpiredLabel;

  /// No description provided for @imageHiddenLabel.
  ///
  /// In de, this message translates to:
  /// **'Versteckt'**
  String get imageHiddenLabel;

  /// No description provided for @addPlayerLabel.
  ///
  /// In de, this message translates to:
  /// **'Spieler hinzufügen'**
  String get addPlayerLabel;

  /// No description provided for @playerLabel.
  ///
  /// In de, this message translates to:
  /// **'Spieler {number}'**
  String playerLabel(int number);

  /// No description provided for @removePlayerTooltip.
  ///
  /// In de, this message translates to:
  /// **'Spieler entfernen'**
  String get removePlayerTooltip;

  /// No description provided for @roundsOptionalLabel.
  ///
  /// In de, this message translates to:
  /// **'Runden (optional)'**
  String get roundsOptionalLabel;

  /// No description provided for @positiveRoundsError.
  ///
  /// In de, this message translates to:
  /// **'Bitte positive Rundenzahl eingeben'**
  String get positiveRoundsError;

  /// No description provided for @timeOptionalLabel.
  ///
  /// In de, this message translates to:
  /// **'Zeit (Min:Sek, optional)'**
  String get timeOptionalLabel;

  /// No description provided for @positiveTimeError.
  ///
  /// In de, this message translates to:
  /// **'Bitte positive Zeit eingeben'**
  String get positiveTimeError;

  /// No description provided for @increaseTooltip.
  ///
  /// In de, this message translates to:
  /// **'Erhöhen'**
  String get increaseTooltip;

  /// No description provided for @decreaseTooltip.
  ///
  /// In de, this message translates to:
  /// **'Verringern'**
  String get decreaseTooltip;

  /// No description provided for @startGameLabel.
  ///
  /// In de, this message translates to:
  /// **'Spiel starten'**
  String get startGameLabel;

  /// No description provided for @resultsTitle.
  ///
  /// In de, this message translates to:
  /// **'Ergebnis'**
  String get resultsTitle;

  /// No description provided for @resultsSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Super gespielt! Alle sind Gewinner! 😉'**
  String get resultsSubtitle;

  /// No description provided for @newScoredGameLabel.
  ///
  /// In de, this message translates to:
  /// **'Neues Punktespiel'**
  String get newScoredGameLabel;

  /// No description provided for @scoreLabel.
  ///
  /// In de, this message translates to:
  /// **'{score, plural, one{{score} Pkt} other{{score} Pkt}}'**
  String scoreLabel(int score);

  /// No description provided for @winnerPraise1.
  ///
  /// In de, this message translates to:
  /// **'Souveräner Auftritt!'**
  String get winnerPraise1;

  /// No description provided for @winnerPraise2.
  ///
  /// In de, this message translates to:
  /// **'Super Spiel!'**
  String get winnerPraise2;

  /// No description provided for @winnerPraise3.
  ///
  /// In de, this message translates to:
  /// **'Beschde!'**
  String get winnerPraise3;

  /// No description provided for @winnerPraise4.
  ///
  /// In de, this message translates to:
  /// **'Geil Geil Geil!'**
  String get winnerPraise4;

  /// No description provided for @winnerPraise5.
  ///
  /// In de, this message translates to:
  /// **'Abgeliefert!'**
  String get winnerPraise5;

  /// No description provided for @winnerPraise6.
  ///
  /// In de, this message translates to:
  /// **'Päääm!'**
  String get winnerPraise6;

  /// No description provided for @winnerBadgeLabel.
  ///
  /// In de, this message translates to:
  /// **'1. PLATZ'**
  String get winnerBadgeLabel;

  /// No description provided for @rankLabel.
  ///
  /// In de, this message translates to:
  /// **'{rank}. Platz'**
  String rankLabel(int rank);

  /// No description provided for @promptCat.
  ///
  /// In de, this message translates to:
  /// **'Katze'**
  String get promptCat;

  /// No description provided for @promptDog.
  ///
  /// In de, this message translates to:
  /// **'Hund'**
  String get promptDog;

  /// No description provided for @promptWizard.
  ///
  /// In de, this message translates to:
  /// **'Zauberer'**
  String get promptWizard;

  /// No description provided for @promptAnt.
  ///
  /// In de, this message translates to:
  /// **'Ameise'**
  String get promptAnt;

  /// No description provided for @promptBackpack.
  ///
  /// In de, this message translates to:
  /// **'Rucksack'**
  String get promptBackpack;

  /// No description provided for @promptBaker.
  ///
  /// In de, this message translates to:
  /// **'Bäcker'**
  String get promptBaker;

  /// No description provided for @promptBee.
  ///
  /// In de, this message translates to:
  /// **'Biene'**
  String get promptBee;

  /// No description provided for @promptBicycle.
  ///
  /// In de, this message translates to:
  /// **'Fahrrad'**
  String get promptBicycle;

  /// No description provided for @promptBunny.
  ///
  /// In de, this message translates to:
  /// **'Hase'**
  String get promptBunny;

  /// No description provided for @promptBurger.
  ///
  /// In de, this message translates to:
  /// **'Burger'**
  String get promptBurger;

  /// No description provided for @promptClimbing.
  ///
  /// In de, this message translates to:
  /// **'Klettern'**
  String get promptClimbing;

  /// No description provided for @promptDancing.
  ///
  /// In de, this message translates to:
  /// **'Tanzen'**
  String get promptDancing;

  /// No description provided for @promptDragon.
  ///
  /// In de, this message translates to:
  /// **'Drache'**
  String get promptDragon;

  /// No description provided for @promptEgg.
  ///
  /// In de, this message translates to:
  /// **'Ei'**
  String get promptEgg;

  /// No description provided for @promptFarmer.
  ///
  /// In de, this message translates to:
  /// **'Bauer'**
  String get promptFarmer;

  /// No description provided for @promptFish.
  ///
  /// In de, this message translates to:
  /// **'Fisch'**
  String get promptFish;

  /// No description provided for @promptFondue.
  ///
  /// In de, this message translates to:
  /// **'Fondue'**
  String get promptFondue;

  /// No description provided for @promptFork.
  ///
  /// In de, this message translates to:
  /// **'Gabel'**
  String get promptFork;

  /// No description provided for @promptHero.
  ///
  /// In de, this message translates to:
  /// **'Held'**
  String get promptHero;

  /// No description provided for @promptKnight.
  ///
  /// In de, this message translates to:
  /// **'Ritter'**
  String get promptKnight;

  /// No description provided for @promptLama.
  ///
  /// In de, this message translates to:
  /// **'Lama'**
  String get promptLama;

  /// No description provided for @promptNinja.
  ///
  /// In de, this message translates to:
  /// **'Ninja'**
  String get promptNinja;

  /// No description provided for @promptPenguin.
  ///
  /// In de, this message translates to:
  /// **'Pinguin'**
  String get promptPenguin;

  /// No description provided for @promptPirate.
  ///
  /// In de, this message translates to:
  /// **'Pirat'**
  String get promptPirate;

  /// No description provided for @promptReindeer.
  ///
  /// In de, this message translates to:
  /// **'Rentier'**
  String get promptReindeer;

  /// No description provided for @promptShip.
  ///
  /// In de, this message translates to:
  /// **'Schiff'**
  String get promptShip;

  /// No description provided for @promptSkiing.
  ///
  /// In de, this message translates to:
  /// **'Skifahren'**
  String get promptSkiing;

  /// No description provided for @promptSnake.
  ///
  /// In de, this message translates to:
  /// **'Schlange'**
  String get promptSnake;

  /// No description provided for @promptSpaghetti.
  ///
  /// In de, this message translates to:
  /// **'Spaghetti'**
  String get promptSpaghetti;

  /// No description provided for @promptSquirrel.
  ///
  /// In de, this message translates to:
  /// **'Eichhörnchen'**
  String get promptSquirrel;

  /// No description provided for @promptStorm.
  ///
  /// In de, this message translates to:
  /// **'Sturm'**
  String get promptStorm;

  /// No description provided for @promptTree.
  ///
  /// In de, this message translates to:
  /// **'Baum'**
  String get promptTree;

  /// No description provided for @promptUmbrella.
  ///
  /// In de, this message translates to:
  /// **'Regenschirm'**
  String get promptUmbrella;

  /// No description provided for @promptUnicorn.
  ///
  /// In de, this message translates to:
  /// **'Einhorn'**
  String get promptUnicorn;

  /// No description provided for @promptVolleyball.
  ///
  /// In de, this message translates to:
  /// **'Volleyball'**
  String get promptVolleyball;

  /// No description provided for @promptMonkey.
  ///
  /// In de, this message translates to:
  /// **'Affe'**
  String get promptMonkey;

  /// No description provided for @promptOpenBook.
  ///
  /// In de, this message translates to:
  /// **'Offenes Buch'**
  String get promptOpenBook;

  /// No description provided for @promptSoccerBall.
  ///
  /// In de, this message translates to:
  /// **'Fußball'**
  String get promptSoccerBall;

  /// No description provided for @promptAlarmClock.
  ///
  /// In de, this message translates to:
  /// **'Wecker'**
  String get promptAlarmClock;

  /// No description provided for @promptBalloon.
  ///
  /// In de, this message translates to:
  /// **'Ballon'**
  String get promptBalloon;

  /// No description provided for @promptBeanie.
  ///
  /// In de, this message translates to:
  /// **'Mütze'**
  String get promptBeanie;

  /// No description provided for @promptBear.
  ///
  /// In de, this message translates to:
  /// **'Bär'**
  String get promptBear;

  /// No description provided for @promptBee2.
  ///
  /// In de, this message translates to:
  /// **'Biene'**
  String get promptBee2;

  /// No description provided for @promptBird.
  ///
  /// In de, this message translates to:
  /// **'Vogel'**
  String get promptBird;

  /// No description provided for @promptBlanket.
  ///
  /// In de, this message translates to:
  /// **'Decke'**
  String get promptBlanket;

  /// No description provided for @promptBroom.
  ///
  /// In de, this message translates to:
  /// **'Besen'**
  String get promptBroom;

  /// No description provided for @promptBucket.
  ///
  /// In de, this message translates to:
  /// **'Eimer'**
  String get promptBucket;

  /// No description provided for @promptButterfly.
  ///
  /// In de, this message translates to:
  /// **'Schmetterling'**
  String get promptButterfly;

  /// No description provided for @promptCamel.
  ///
  /// In de, this message translates to:
  /// **'Kamel'**
  String get promptCamel;

  /// No description provided for @promptCamera.
  ///
  /// In de, this message translates to:
  /// **'Kamera'**
  String get promptCamera;

  /// No description provided for @promptChair.
  ///
  /// In de, this message translates to:
  /// **'Stuhl'**
  String get promptChair;

  /// No description provided for @promptChicken.
  ///
  /// In de, this message translates to:
  /// **'Huhn'**
  String get promptChicken;

  /// No description provided for @promptCow.
  ///
  /// In de, this message translates to:
  /// **'Kuh'**
  String get promptCow;

  /// No description provided for @promptCrab.
  ///
  /// In de, this message translates to:
  /// **'Krabbe'**
  String get promptCrab;

  /// No description provided for @promptCrocodile.
  ///
  /// In de, this message translates to:
  /// **'Krokodil'**
  String get promptCrocodile;

  /// No description provided for @promptCup.
  ///
  /// In de, this message translates to:
  /// **'Tasse'**
  String get promptCup;

  /// No description provided for @promptDeer.
  ///
  /// In de, this message translates to:
  /// **'Hirsch'**
  String get promptDeer;

  /// No description provided for @promptDolphin.
  ///
  /// In de, this message translates to:
  /// **'Delfin'**
  String get promptDolphin;

  /// No description provided for @promptDrums.
  ///
  /// In de, this message translates to:
  /// **'Schlagzeug'**
  String get promptDrums;

  /// No description provided for @promptDuck.
  ///
  /// In de, this message translates to:
  /// **'Ente'**
  String get promptDuck;

  /// No description provided for @promptEagle.
  ///
  /// In de, this message translates to:
  /// **'Adler'**
  String get promptEagle;

  /// No description provided for @promptElephant.
  ///
  /// In de, this message translates to:
  /// **'Elefant'**
  String get promptElephant;

  /// No description provided for @promptFlashlight.
  ///
  /// In de, this message translates to:
  /// **'Taschenlampe'**
  String get promptFlashlight;

  /// No description provided for @promptFloorLamp.
  ///
  /// In de, this message translates to:
  /// **'Stehlampe'**
  String get promptFloorLamp;

  /// No description provided for @promptFlute.
  ///
  /// In de, this message translates to:
  /// **'Flöte'**
  String get promptFlute;

  /// No description provided for @promptFox.
  ///
  /// In de, this message translates to:
  /// **'Fuchs'**
  String get promptFox;

  /// No description provided for @promptFrog.
  ///
  /// In de, this message translates to:
  /// **'Frosch'**
  String get promptFrog;

  /// No description provided for @promptGift.
  ///
  /// In de, this message translates to:
  /// **'Geschenk'**
  String get promptGift;

  /// No description provided for @promptGiraffe.
  ///
  /// In de, this message translates to:
  /// **'Giraffe'**
  String get promptGiraffe;

  /// No description provided for @promptGlasses.
  ///
  /// In de, this message translates to:
  /// **'Brille'**
  String get promptGlasses;

  /// No description provided for @promptGloves.
  ///
  /// In de, this message translates to:
  /// **'Handschuhe'**
  String get promptGloves;

  /// No description provided for @promptGoat.
  ///
  /// In de, this message translates to:
  /// **'Ziege'**
  String get promptGoat;

  /// No description provided for @promptGuineaPig.
  ///
  /// In de, this message translates to:
  /// **'Meerschweinchen'**
  String get promptGuineaPig;

  /// No description provided for @promptGuitar.
  ///
  /// In de, this message translates to:
  /// **'Gitarre'**
  String get promptGuitar;

  /// No description provided for @promptHamster.
  ///
  /// In de, this message translates to:
  /// **'Hamster'**
  String get promptHamster;

  /// No description provided for @promptHat.
  ///
  /// In de, this message translates to:
  /// **'Hut'**
  String get promptHat;

  /// No description provided for @promptHedgehog.
  ///
  /// In de, this message translates to:
  /// **'Igel'**
  String get promptHedgehog;

  /// No description provided for @promptKey.
  ///
  /// In de, this message translates to:
  /// **'Schlüssel'**
  String get promptKey;

  /// No description provided for @promptLadybug.
  ///
  /// In de, this message translates to:
  /// **'Marienkäfer'**
  String get promptLadybug;

  /// No description provided for @promptLeopard.
  ///
  /// In de, this message translates to:
  /// **'Leopard'**
  String get promptLeopard;

  /// No description provided for @promptLion.
  ///
  /// In de, this message translates to:
  /// **'Löwe'**
  String get promptLion;

  /// No description provided for @promptMirror.
  ///
  /// In de, this message translates to:
  /// **'Spiegel'**
  String get promptMirror;

  /// No description provided for @promptMobile.
  ///
  /// In de, this message translates to:
  /// **'Handy'**
  String get promptMobile;

  /// No description provided for @promptMouse.
  ///
  /// In de, this message translates to:
  /// **'Maus'**
  String get promptMouse;

  /// No description provided for @promptOwl.
  ///
  /// In de, this message translates to:
  /// **'Eule'**
  String get promptOwl;

  /// No description provided for @promptPanda.
  ///
  /// In de, this message translates to:
  /// **'Panda'**
  String get promptPanda;

  /// No description provided for @promptParrot.
  ///
  /// In de, this message translates to:
  /// **'Papagei'**
  String get promptParrot;

  /// No description provided for @promptPelican.
  ///
  /// In de, this message translates to:
  /// **'Pelikane'**
  String get promptPelican;

  /// No description provided for @promptPencil.
  ///
  /// In de, this message translates to:
  /// **'Bleistift'**
  String get promptPencil;

  /// No description provided for @promptPenguin2.
  ///
  /// In de, this message translates to:
  /// **'Pinguin'**
  String get promptPenguin2;

  /// No description provided for @promptPig.
  ///
  /// In de, this message translates to:
  /// **'Schwein'**
  String get promptPig;

  /// No description provided for @promptPillow.
  ///
  /// In de, this message translates to:
  /// **'Kissen'**
  String get promptPillow;

  /// No description provided for @promptPlate.
  ///
  /// In de, this message translates to:
  /// **'Teller'**
  String get promptPlate;

  /// No description provided for @promptRabbit.
  ///
  /// In de, this message translates to:
  /// **'Kaninchen'**
  String get promptRabbit;

  /// No description provided for @promptRemoteControl.
  ///
  /// In de, this message translates to:
  /// **'Fernbedienung'**
  String get promptRemoteControl;

  /// No description provided for @promptRope.
  ///
  /// In de, this message translates to:
  /// **'Seil'**
  String get promptRope;

  /// No description provided for @promptRuler.
  ///
  /// In de, this message translates to:
  /// **'Lineal'**
  String get promptRuler;

  /// No description provided for @promptScarf.
  ///
  /// In de, this message translates to:
  /// **'Schal'**
  String get promptScarf;

  /// No description provided for @promptScissors.
  ///
  /// In de, this message translates to:
  /// **'Schere'**
  String get promptScissors;

  /// No description provided for @promptScooter.
  ///
  /// In de, this message translates to:
  /// **'Roller'**
  String get promptScooter;

  /// No description provided for @promptShark.
  ///
  /// In de, this message translates to:
  /// **'Hai'**
  String get promptShark;

  /// No description provided for @promptSheep.
  ///
  /// In de, this message translates to:
  /// **'Schaf'**
  String get promptSheep;

  /// No description provided for @promptSheetOfPaper.
  ///
  /// In de, this message translates to:
  /// **'Blatt Papier'**
  String get promptSheetOfPaper;

  /// No description provided for @promptSkateboard.
  ///
  /// In de, this message translates to:
  /// **'Skateboard'**
  String get promptSkateboard;

  /// No description provided for @promptSledge.
  ///
  /// In de, this message translates to:
  /// **'Schlitten'**
  String get promptSledge;

  /// No description provided for @promptSlide.
  ///
  /// In de, this message translates to:
  /// **'Rutsche'**
  String get promptSlide;

  /// No description provided for @promptSnail.
  ///
  /// In de, this message translates to:
  /// **'Schnecke'**
  String get promptSnail;

  /// No description provided for @promptSoap.
  ///
  /// In de, this message translates to:
  /// **'Seife'**
  String get promptSoap;

  /// No description provided for @promptSpider.
  ///
  /// In de, this message translates to:
  /// **'Spinne'**
  String get promptSpider;

  /// No description provided for @promptSpoon.
  ///
  /// In de, this message translates to:
  /// **'Löffel'**
  String get promptSpoon;

  /// No description provided for @promptStarfish.
  ///
  /// In de, this message translates to:
  /// **'Seestern'**
  String get promptStarfish;

  /// No description provided for @promptSuitcase.
  ///
  /// In de, this message translates to:
  /// **'Koffer'**
  String get promptSuitcase;

  /// No description provided for @promptSwing.
  ///
  /// In de, this message translates to:
  /// **'Schaukel'**
  String get promptSwing;

  /// No description provided for @promptTable.
  ///
  /// In de, this message translates to:
  /// **'Tisch'**
  String get promptTable;

  /// No description provided for @promptTelevision.
  ///
  /// In de, this message translates to:
  /// **'Fernseher'**
  String get promptTelevision;

  /// No description provided for @promptTiger.
  ///
  /// In de, this message translates to:
  /// **'Tiger'**
  String get promptTiger;

  /// No description provided for @promptToothbrush.
  ///
  /// In de, this message translates to:
  /// **'Zahnbürste'**
  String get promptToothbrush;

  /// No description provided for @promptTowel.
  ///
  /// In de, this message translates to:
  /// **'Handtuch'**
  String get promptTowel;

  /// No description provided for @promptTurtle.
  ///
  /// In de, this message translates to:
  /// **'Schildkröte'**
  String get promptTurtle;

  /// No description provided for @promptWatch.
  ///
  /// In de, this message translates to:
  /// **'Uhr'**
  String get promptWatch;

  /// No description provided for @promptWhale.
  ///
  /// In de, this message translates to:
  /// **'Wal'**
  String get promptWhale;

  /// No description provided for @promptWolf.
  ///
  /// In de, this message translates to:
  /// **'Wolf'**
  String get promptWolf;

  /// No description provided for @promptZebra.
  ///
  /// In de, this message translates to:
  /// **'Zebra'**
  String get promptZebra;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
