// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Pantomias';

  @override
  String get startTileTitle => 'Let\'s go!';

  @override
  String get quickStartLabel => 'Quick Start';

  @override
  String get scoredGameModeLabel => 'Points Game';

  @override
  String get pointModeSetupTitle => 'Points Setup';

  @override
  String get nextImageLabel => 'Next Image';

  @override
  String get modeSelectionTooltip => 'Mode Selection';

  @override
  String roundLabel(int round) {
    return 'Round $round';
  }

  @override
  String roundLabelWithLimit(int round, int limit) {
    return 'Round $round of $limit';
  }

  @override
  String activePlayerLabel(String name) {
    return 'Turn: $name';
  }

  @override
  String get notGuessedLabel => 'Wrong';

  @override
  String get guessedLabel => 'Guessed';

  @override
  String get timeExpiredLabel => 'Time\'s up';

  @override
  String get imageHiddenLabel => 'Hidden';

  @override
  String get turnGuessedFeedbackLabel => 'Guessed!';

  @override
  String get stageHiddenHelperLabel => 'Tap to reveal';

  @override
  String get stageRevealedHelperLabel => 'Tap to hide';

  @override
  String get addPlayerLabel => 'Add Player';

  @override
  String playerLabel(int number) {
    return 'Player $number';
  }

  @override
  String get removePlayerTooltip => 'Remove player';

  @override
  String get gameModeSectionLabel => 'Game Mode';

  @override
  String get winnerNextModeLabel => 'Winner goes next';

  @override
  String get winnerNextModeDescription => 'The guesser mimes next';

  @override
  String get sequenceModeLabel => 'Turn Order';

  @override
  String get sequenceModeDescription => 'Players take turns in order';

  @override
  String get whoGuessedLabel => 'Who guessed it?';

  @override
  String get roundsOptionalLabel => 'Rounds (optional)';

  @override
  String get positiveRoundsError => 'Please enter a positive number of rounds';

  @override
  String get timeOptionalLabel => 'Time (Min:Sec, optional)';

  @override
  String get positiveTimeError => 'Please enter a positive time';

  @override
  String get increaseTooltip => 'Increase';

  @override
  String get decreaseTooltip => 'Decrease';

  @override
  String get startGameLabel => 'Start Game';

  @override
  String get resultsTitle => 'Results';

  @override
  String get resultsSubtitle => 'Great game! Everyone\'s a winner! 😉';

  @override
  String get newScoredGameLabel => 'New Points Game';

  @override
  String scoreLabel(int score) {
    String _temp0 = intl.Intl.pluralLogic(
      score,
      locale: localeName,
      other: '$score pts',
      one: '$score pt',
    );
    return '$_temp0';
  }

  @override
  String get winnerPraise1 => 'Commanding performance!';

  @override
  String get winnerPraise2 => 'Great game!';

  @override
  String get winnerPraise3 => 'Top notch!';

  @override
  String get winnerPraise4 => 'Crushed it!';

  @override
  String get winnerPraise5 => 'Delivered!';

  @override
  String get winnerPraise6 => 'Boom!';

  @override
  String get winnerBadgeLabel => '1ST PLACE';

  @override
  String rankLabel(int rank, String ordinalSuffix) {
    return '$rank$ordinalSuffix place';
  }

  @override
  String get promptCat => 'Cat';

  @override
  String get promptDog => 'Dog';

  @override
  String get promptWizard => 'Wizard';

  @override
  String get promptAnt => 'Ant';

  @override
  String get promptBackpack => 'Backpack';

  @override
  String get promptBaker => 'Baker';

  @override
  String get promptBee => 'Bee';

  @override
  String get promptBicycle => 'Bicycle';

  @override
  String get promptBunny => 'Bunny';

  @override
  String get promptBurger => 'Burger';

  @override
  String get promptClimbing => 'Climbing';

  @override
  String get promptDancing => 'Dancing';

  @override
  String get promptDragon => 'Dragon';

  @override
  String get promptEgg => 'Egg';

  @override
  String get promptFarmer => 'Farmer';

  @override
  String get promptFish => 'Fish';

  @override
  String get promptFondue => 'Fondue';

  @override
  String get promptFork => 'Fork';

  @override
  String get promptHero => 'Hero';

  @override
  String get promptKnight => 'Knight';

  @override
  String get promptLama => 'Llama';

  @override
  String get promptNinja => 'Ninja';

  @override
  String get promptPenguin => 'Penguin';

  @override
  String get promptPirate => 'Pirate';

  @override
  String get promptReindeer => 'Reindeer';

  @override
  String get promptShip => 'Ship';

  @override
  String get promptSkiing => 'Skiing';

  @override
  String get promptSnake => 'Snake';

  @override
  String get promptSpaghetti => 'Spaghetti';

  @override
  String get promptSquirrel => 'Squirrel';

  @override
  String get promptStorm => 'Storm';

  @override
  String get promptTree => 'Tree';

  @override
  String get promptUmbrella => 'Umbrella';

  @override
  String get promptUnicorn => 'Unicorn';

  @override
  String get promptVolleyball => 'Volleyball';

  @override
  String get promptMonkey => 'Monkey';

  @override
  String get promptOpenBook => 'Open Book';

  @override
  String get promptSoccerBall => 'Soccer Ball';

  @override
  String get promptBalloon => 'Balloon';

  @override
  String get promptBeanie => 'Beanie';

  @override
  String get promptBear => 'Bear';

  @override
  String get promptBee2 => 'Bee';

  @override
  String get promptBird => 'Bird';

  @override
  String get promptBlanket => 'Blanket';

  @override
  String get promptBroom => 'Broom';

  @override
  String get promptBucket => 'Bucket';

  @override
  String get promptButterfly => 'Butterfly';

  @override
  String get promptCamel => 'Camel';

  @override
  String get promptCamera => 'Camera';

  @override
  String get promptChair => 'Chair';

  @override
  String get promptChicken => 'Chicken';

  @override
  String get promptCow => 'Cow';

  @override
  String get promptCrab => 'Crab';

  @override
  String get promptCrocodile => 'Crocodile';

  @override
  String get promptCup => 'Cup';

  @override
  String get promptDeer => 'Deer';

  @override
  String get promptDolphin => 'Dolphin';

  @override
  String get promptDrums => 'Drums';

  @override
  String get promptDuck => 'Duck';

  @override
  String get promptEagle => 'Eagle';

  @override
  String get promptElephant => 'Elephant';

  @override
  String get promptFlashlight => 'Flashlight';

  @override
  String get promptFloorLamp => 'Floor Lamp';

  @override
  String get promptFlute => 'Flute';

  @override
  String get promptFox => 'Fox';

  @override
  String get promptFrog => 'Frog';

  @override
  String get promptGift => 'Gift';

  @override
  String get promptGiraffe => 'Giraffe';

  @override
  String get promptGlasses => 'Glasses';

  @override
  String get promptGloves => 'Gloves';

  @override
  String get promptGoat => 'Goat';

  @override
  String get promptGuineaPig => 'Guinea Pig';

  @override
  String get promptGuitar => 'Guitar';

  @override
  String get promptHamster => 'Hamster';

  @override
  String get promptHat => 'Hat';

  @override
  String get promptHedgehog => 'Hedgehog';

  @override
  String get promptKey => 'Key';

  @override
  String get promptLadybug => 'Ladybug';

  @override
  String get promptLeopard => 'Leopard';

  @override
  String get promptLion => 'Lion';

  @override
  String get promptMirror => 'Mirror';

  @override
  String get promptMobile => 'Mobile Phone';

  @override
  String get promptMouse => 'Mouse';

  @override
  String get promptOwl => 'Owl';

  @override
  String get promptPanda => 'Panda';

  @override
  String get promptParrot => 'Parrot';

  @override
  String get promptPelican => 'Pelicans';

  @override
  String get promptPencil => 'Pencil';

  @override
  String get promptPenguin2 => 'Penguin';

  @override
  String get promptPig => 'Pig';

  @override
  String get promptPillow => 'Pillow';

  @override
  String get promptPlate => 'Plate';

  @override
  String get promptRabbit => 'Rabbit';

  @override
  String get promptRemoteControl => 'Remote Control';

  @override
  String get promptRope => 'Rope';

  @override
  String get promptRuler => 'Ruler';

  @override
  String get promptScarf => 'Scarf';

  @override
  String get promptScissors => 'Scissors';

  @override
  String get promptScooter => 'Scooter';

  @override
  String get promptShark => 'Shark';

  @override
  String get promptSheep => 'Sheep';

  @override
  String get promptSheetOfPaper => 'Sheet of Paper';

  @override
  String get promptSkateboard => 'Skateboard';

  @override
  String get promptSledge => 'Sled';

  @override
  String get promptSlide => 'Slide';

  @override
  String get promptSnail => 'Snail';

  @override
  String get promptSoap => 'Soap';

  @override
  String get promptSpider => 'Spider';

  @override
  String get promptSpoon => 'Spoon';

  @override
  String get promptStarfish => 'Starfish';

  @override
  String get promptSuitcase => 'Suitcase';

  @override
  String get promptSwing => 'Swing';

  @override
  String get promptTable => 'Table';

  @override
  String get promptTelevision => 'Television';

  @override
  String get promptTiger => 'Tiger';

  @override
  String get promptToothbrush => 'Toothbrush';

  @override
  String get promptTowel => 'Towel';

  @override
  String get promptTurtle => 'Turtle';

  @override
  String get promptWhale => 'Whale';

  @override
  String get promptWolf => 'Wolf';

  @override
  String get promptZebra => 'Zebra';

  @override
  String get promptAstronaut => 'Astronaut';

  @override
  String get promptCandle => 'Candle';

  @override
  String get promptChef => 'Chef';

  @override
  String get promptFirefighter => 'Firefighter';

  @override
  String get promptFlamingo => 'Flamingo';

  @override
  String get promptGhost => 'Ghost';

  @override
  String get promptHippo => 'Hippo';

  @override
  String get promptKangaroo => 'Kangaroo';

  @override
  String get promptKite => 'Kite';

  @override
  String get promptKoala => 'Koala';

  @override
  String get promptMermaid => 'Mermaid';

  @override
  String get promptOctopus => 'Octopus';

  @override
  String get promptRaccoon => 'Raccoon';

  @override
  String get promptRobot => 'Robot';

  @override
  String get promptSwimming => 'Swimming';

  @override
  String get promptTrumpet => 'Trumpet';

  @override
  String get promptViolin => 'Violin';

  @override
  String get promptWitch => 'Witch';

  @override
  String get promptAlien => 'Alien';

  @override
  String get promptDoctor => 'Doctor';

  @override
  String get promptFishing => 'Fishing';

  @override
  String get promptHammer => 'Hammer';

  @override
  String get promptMummy => 'Mummy';

  @override
  String get promptOtter => 'Otter';

  @override
  String get promptPainter => 'Painter';

  @override
  String get promptPeacock => 'Peacock';

  @override
  String get promptPlatypus => 'Platypus';

  @override
  String get promptRhino => 'Rhino';

  @override
  String get promptSeal => 'Seal';

  @override
  String get promptSinging => 'Singing';

  @override
  String get promptSleeping => 'Sleeping';

  @override
  String get promptSloth => 'Sloth';

  @override
  String get promptTelephone => 'Telephone';

  @override
  String get promptVampire => 'Vampire';

  @override
  String get promptWalrus => 'Walrus';

  @override
  String get promptJellyfish => 'Jellyfish';

  @override
  String get promptBeaver => 'Beaver';

  @override
  String get promptSeahorse => 'Seahorse';

  @override
  String get promptTeacher => 'Teacher';

  @override
  String get promptPoliceOfficer => 'Police officer';

  @override
  String get promptMechanic => 'Mechanic';

  @override
  String get promptTeapot => 'Teapot';

  @override
  String get promptVacuumCleaner => 'Vacuum cleaner';

  @override
  String get promptLaptop => 'Laptop';

  @override
  String get promptSock => 'Sock';

  @override
  String get promptJuggling => 'Juggling';

  @override
  String get promptSneezing => 'Sneezing';

  @override
  String get promptYoga => 'Yoga';
}
