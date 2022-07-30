
import 'package:flutter/cupertino.dart';
import 'package:possessions_app/main.dart';

import 'QuarterScoreWidget.dart';

class Defense {

  Defense(this.defenseType);

  String defenseType;

  int twoPointMisses = 0;
  int twoPointMakes = 0;
  int threePointMisses = 0;
  int threePointMakes = 0;
  int turnovers = 0;
  int oBoards = 0;
  int freeThrowMakes = 0;
  int freeThrowMisses = 0;
  int fouls = 0;
  int foulEndedPossessions = 0;
  List <PossessionEnds> possessionHistory = [];

  int twoPointMissesFirstHalf = 0;
  int twoPointMakesFirstHalf = 0;
  int threePointMissesFirstHalf = 0;
  int threePointMakesFirstHalf = 0;
  int turnoversFirstHalf = 0;
  int oBoardsFirstHalf = 0;
  int freeThrowMakesFirstHalf = 0;
  int freeThrowMissesFirstHalf = 0;
  int foulsFirstHalf = 0;
  int foulEndedPossessionsFirstHalf = 0;
  List <PossessionEnds> possessionHistoryFirstHalf = [];

  int twoPointMissesSecondHalf = 0;
  int twoPointMakesSecondHalf = 0;
  int threePointMissesSecondHalf = 0;
  int threePointMakesSecondHalf = 0;
  int turnoversSecondHalf = 0;
  int oBoardsSecondHalf = 0;
  int freeThrowMakesSecondHalf = 0;
  int freeThrowMissesSecondHalf = 0;
  int foulsSecondHalf = 0;
  int foulEndedPossessionsSecondHalf = 0;
  List <PossessionEnds> possessionHistorySecondHalf = [];

  int get possessions {
    return (twoPointAttempts + threePointAttempts + turnovers + foulEndedPossessions) - oBoards;
  }

  int get possessionsFirstHalf {
    return (twoPointAttemptsFirstHalf + threePointAttemptsFirstHalf + turnoversFirstHalf + foulEndedPossessionsFirstHalf) - oBoardsFirstHalf;
  }
  int get possessionsSecondHalf {
    return (twoPointAttemptsSecondHalf + threePointAttemptsSecondHalf + turnoversSecondHalf + foulEndedPossessionsSecondHalf) - oBoardsSecondHalf;
  }

  String get pointsPerPossession {
    if (possessions == 0) {
      return '0.0';
    }
    return (((twoPointMakes * 2) + (threePointMakes * 3) + freeThrowMakes).toDouble() / possessions.toDouble()).toStringAsFixed(1);
  }

  String get hudlPointsPerPossession {
    if (possessions == 0) {
      return '0.0';
    }

    return (((twoPointMakes * 2) + (threePointMakes * 3) + freeThrowMakes).toDouble() / (((twoPointAttempts + threePointAttempts) - oBoards) + turnovers + (0.44 * freeThrowAttempts)).toDouble()).toStringAsFixed(1);
  }

  String get hudlPointsPerPossessionFirstHalf {
    if (possessionsFirstHalf == 0) {
      return '0.0';
    }

    return (((twoPointMakesFirstHalf * 2) + (threePointMakesFirstHalf * 3) + freeThrowMakesFirstHalf).toDouble() / (((twoPointAttemptsFirstHalf + threePointAttemptsFirstHalf) - oBoardsFirstHalf) + turnoversFirstHalf + (0.44 * freeThrowAttemptsFirstHalf)).toDouble()).toStringAsFixed(1);
  }

  String get hudlPointsPerPossessionSecondHalf {
    if (possessionsSecondHalf == 0) {
      return '0.0';
    }

    return (((twoPointMakesSecondHalf * 2) + (threePointMakesSecondHalf * 3) + freeThrowMakesSecondHalf).toDouble() / (((twoPointAttemptsSecondHalf + threePointAttemptsSecondHalf) - oBoardsSecondHalf) + turnoversSecondHalf + (0.44 * freeThrowAttemptsSecondHalf)).toDouble()).toStringAsFixed(1);
  }

  String get pointsPerPossessionFirstHalf {
    if (possessionsFirstHalf == 0) {
      return '0.0';
    }
    return (((twoPointMakesFirstHalf * 2) + (threePointMakesFirstHalf * 3) + freeThrowMakesFirstHalf).toDouble() / possessionsFirstHalf.toDouble()).toStringAsFixed(1);
  }

  String get pointsPerPossessionSecondHalf {
    if (possessionsSecondHalf == 0) {
      return '0.0';
    }
    return (((twoPointMakesSecondHalf * 2) + (threePointMakesSecondHalf * 3) + freeThrowMakesSecondHalf).toDouble() / possessionsSecondHalf.toDouble()).toStringAsFixed(1);
  }


  int get points {
    if (possessions == 0) {
      return 0;
    }
    return (twoPointMakes * 2) + (threePointMakes * 3) + freeThrowMakes;
  }

  int get pointsFirstHalf {
    if (possessionsFirstHalf == 0) {
      return 0;
    }
    return (twoPointMakesFirstHalf * 2) + (threePointMakesFirstHalf * 3) + freeThrowMakesFirstHalf;
  }

  int get pointsSecondHalf {
    if (possessionsSecondHalf == 0) {
      return 0;
    }
    return (twoPointMakesSecondHalf * 2) + (threePointMakesSecondHalf * 3) + freeThrowMakesSecondHalf;
  }


  String get threePointPercentage {
    if (threePointAttempts == 0) {
      return'-';
    }
    final decimal = threePointMakes.toDouble() / threePointAttempts.toDouble();
    final percent = decimal * 100;
    return percent.toStringAsFixed(2) + '%';
  }

  String get threePointPercentageFirstHalf {
    if (threePointAttemptsFirstHalf == 0) {
      return'-';
    }
    final decimal = threePointMakesFirstHalf.toDouble() / threePointAttemptsFirstHalf.toDouble();
    final percent = decimal * 100;
    return percent.toStringAsFixed(2) + '%';
  }

  String get threePointPercentageSecondHalf {
    if (threePointAttemptsSecondHalf == 0) {
      return'-';
    }
    final decimal = threePointMakesSecondHalf.toDouble() / threePointAttemptsSecondHalf.toDouble();
    final percent = decimal * 100;
    return percent.toStringAsFixed(2) + '%';
  }

  String get fieldGoalPercentage {
    if (twoPointAttempts == 0 && threePointAttempts == 0) {
      return'-';
    }
    final decimal = (twoPointMakes.toDouble() + threePointMakes.toDouble()) / (twoPointAttempts.toDouble() + threePointAttempts.toDouble());
    final percent = decimal * 100;
    return percent.toStringAsFixed(2) + '%';
  }

  String get fieldGoalPercentageFirstHalf {
    if (twoPointAttemptsFirstHalf == 0 && threePointAttemptsFirstHalf == 0) {
      return'-';
    }
    final decimal = (twoPointMakesFirstHalf.toDouble() + threePointMakesFirstHalf.toDouble()) / (twoPointAttemptsFirstHalf.toDouble() + threePointAttemptsFirstHalf.toDouble());
    final percent = decimal * 100;
    return percent.toStringAsFixed(2) + '%';
  }

  String get fieldGoalPercentageSecondHalf {
    if (twoPointAttemptsSecondHalf == 0 && threePointAttemptsSecondHalf == 0) {
      return'-';
    }
    final decimal = (twoPointMakesSecondHalf.toDouble() + threePointMakesSecondHalf.toDouble()) / (twoPointAttemptsSecondHalf.toDouble() + threePointAttemptsSecondHalf.toDouble());
    final percent = decimal * 100;
    return percent.toStringAsFixed(2) + '%';
  }

  String get freeThrowPercentage {
    if (freeThrowAttempts == 0) {
      return '-';
    }
    final decimal = freeThrowMakes.toDouble() /
        (freeThrowMakes.toDouble() + freeThrowMisses.toDouble());
    final percent = decimal * 100;
    return percent.toStringAsFixed(2) + '%';
  }

  String get freeThrowPercentageFirstHalf {
    if (freeThrowAttemptsFirstHalf == 0) {
      return '-';
    }
    final decimal = freeThrowMakesFirstHalf.toDouble() /
        (freeThrowMakesFirstHalf.toDouble() + freeThrowMissesFirstHalf.toDouble());
    final percent = decimal * 100;
    return percent.toStringAsFixed(2) + '%';
  }

  String get freeThrowPercentageSecondHalf {
    if (freeThrowAttemptsSecondHalf == 0) {
      return '-';
    }
    final decimal = freeThrowMakesSecondHalf.toDouble() /
        (freeThrowMakesSecondHalf.toDouble() + freeThrowMissesSecondHalf.toDouble());
    final percent = decimal * 100;
    return percent.toStringAsFixed(2) + '%';
  }


  String get dBoardPercentage {
    if (twoPointMisses == 0 && threePointMisses == 0) {
      return '-';
    }
    final decimal = 1 - (oBoards.toDouble() / (twoPointMisses + threePointMisses).toDouble());
    final percent = decimal * 100;
    return percent.toStringAsFixed(2) + '%';
  }

  String get dBoardPercentageFirstHalf {
    if (twoPointMissesFirstHalf == 0 && threePointMissesFirstHalf == 0) {
      return '-';
    }
    final decimal = 1 - (oBoardsFirstHalf.toDouble() / (twoPointMissesFirstHalf + threePointMissesFirstHalf).toDouble());
    final percent = decimal * 100;
    return percent.toStringAsFixed(2) + '%';
  }

  String get dBoardPercentageSecondHalf {
    if (twoPointMissesSecondHalf == 0 && threePointMissesSecondHalf == 0) {
      return '-';
    }
    final decimal = 1 - (oBoardsSecondHalf.toDouble() / (twoPointMissesSecondHalf + threePointMissesSecondHalf).toDouble());
    final percent = decimal * 100;
    return percent.toStringAsFixed(2) + '%';
  }

  String get turnoverPercentage {
    if (possessions == 0) {
      return'-';
    }
    final decimal = (turnovers.toDouble() / possessions.toDouble());
    final percent = decimal * 100;
    return percent.toStringAsFixed(2) + '%';
  }

  String get turnoverPercentageFirstHalf {
    if (possessionsFirstHalf == 0) {
      return'-';
    }
    final decimal = (turnoversFirstHalf.toDouble() / possessionsFirstHalf.toDouble());
    final percent = decimal * 100;
    return percent.toStringAsFixed(2) + '%';
  }

  String get turnoverPercentageSecondHalf {
    if (possessionsSecondHalf == 0) {
      return'-';
    }
    final decimal = (turnoversSecondHalf.toDouble() / possessionsSecondHalf.toDouble());
    final percent = decimal * 100;
    return percent.toStringAsFixed(2) + '%';
  }

  int get twoPointAttempts {
    return twoPointMakes + twoPointMisses;
  }

  int get twoPointAttemptsFirstHalf {
    return twoPointMakesFirstHalf + twoPointMissesFirstHalf;
  }

  int get twoPointAttemptsSecondHalf {
    return twoPointMakesSecondHalf + twoPointMissesSecondHalf;
  }

  int get threePointAttempts {
    return threePointMakes + threePointMisses;
  }

  int get threePointAttemptsFirstHalf {
    return threePointMakesFirstHalf + threePointMissesFirstHalf;
  }

  int get threePointAttemptsSecondHalf {
    return threePointMakesSecondHalf + threePointMissesSecondHalf;
  }

  int get freeThrowAttempts {
    return freeThrowMakes + freeThrowMisses;
  }

  int get freeThrowAttemptsFirstHalf {
    return freeThrowMakesFirstHalf + freeThrowMissesFirstHalf;
  }

  int get freeThrowAttemptsSecondHalf {
    return freeThrowMakesSecondHalf + freeThrowMissesSecondHalf;
  }

  addStat(PossessionEnds end, Half half) {
    switch (end) {
      case PossessionEnds.twoPointMiss:
        twoPointMisses += 1;
        half == Half.First ? twoPointMissesFirstHalf += 1 : twoPointMissesSecondHalf += 1;
        break;
      case PossessionEnds.twoPointMake:
        twoPointMakes += 1;
        half == Half.First ? twoPointMakesFirstHalf += 1 : twoPointMakesSecondHalf += 1;
        break;
      case PossessionEnds.threePointMiss:
        threePointMisses += 1;
        half == Half.First ? threePointMissesFirstHalf += 1 : threePointMissesSecondHalf += 1;
        break;
      case PossessionEnds.threePointMake:
        threePointMakes += 1;
        half == Half.First ? threePointMakesFirstHalf += 1 : threePointMakesSecondHalf += 1;
        break;
      case PossessionEnds.turnover:
        turnovers += 1;
        half == Half.First ? turnoversFirstHalf += 1 : turnoversSecondHalf += 1;
        break;
      case PossessionEnds.oBoard:
        oBoards += 1;
        half == Half.First ? oBoardsFirstHalf += 1 : oBoardsSecondHalf += 1;
        break;
      case PossessionEnds.freeThrowMake:
        freeThrowMakes += 1;
        half == Half.First ? freeThrowMakesFirstHalf += 1 : freeThrowMakesSecondHalf += 1;
        break;
      case PossessionEnds.freeThrowMiss:
        freeThrowMisses += 1;
        half == Half.First ? freeThrowMissesFirstHalf += 1 : freeThrowMissesSecondHalf += 1;
        break;
      case PossessionEnds.foul:
        fouls += 1;
        half == Half.First ? foulsFirstHalf += 1 : foulsSecondHalf += 1;
        break;
      case PossessionEnds.foulEndedPossession:
        foulEndedPossessions += 1;
        half == Half.First ? foulEndedPossessionsFirstHalf += 1 : foulEndedPossessionsSecondHalf += 1;
        break;
      default:
        return 'Error!!';
    }

    possessionHistory.add(end);
    half == Half.First ? possessionHistoryFirstHalf.add(end) : possessionHistorySecondHalf.add(end);
  }

  String possessionHistoryAsString(PossessionEnds end) {
    switch (end) {
      case PossessionEnds.twoPointMiss:
        return '2 Point Miss';
        break;
      case PossessionEnds.twoPointMake:
        return '2 Point Make';
        break;
      case PossessionEnds.threePointMiss:
        return '3 Point Miss';
        break;
      case PossessionEnds.threePointMake:
        return '3 Point Make';
        break;
      case PossessionEnds.turnover:
        return 'Turnover';
        break;
      case PossessionEnds.oBoard:
        return 'Offensive Rebound';
        break;
      case PossessionEnds.freeThrowMake:
        return 'Free Throw Make';
        break;
      case PossessionEnds.freeThrowMiss:
        return 'Free Throw Miss';
        break;
      case PossessionEnds.foul:
        return 'Foul';
        break;
      case PossessionEnds.foulEndedPossession:
        return 'End of Possession';
        break;
      default:
        return 'Error!!';
    }
  }

  void removeLastPossession(Half half) {
    if (possessionHistory.length > 0) {
      PossessionEnds end = possessionHistory.last;

      //Convert half if we've already gone backwards
      if (half == Half.Second && possessionHistorySecondHalf.isEmpty && possessionHistoryFirstHalf.isNotEmpty) {
        half = Half.First;
      }


      switch (end) {
        case PossessionEnds.twoPointMiss:
          twoPointMisses -= 1;
          half == Half.First ? twoPointMissesFirstHalf -= 1 : twoPointMissesSecondHalf -= 1;
          break;
        case PossessionEnds.twoPointMake:
          twoPointMakes -= 1;
          half == Half.First ? twoPointMakesFirstHalf -= 1 : twoPointMakesSecondHalf -= 1;
          break;
        case PossessionEnds.threePointMiss:
          threePointMisses -= 1;
          half == Half.First ? threePointMissesFirstHalf -= 1 : threePointMissesSecondHalf -= 1;
          break;
        case PossessionEnds.threePointMake:
          threePointMakes -= 1;
          half == Half.First ? threePointMakesFirstHalf -= 1 : threePointMakesSecondHalf -= 1;
          break;
        case PossessionEnds.turnover:
          turnovers -= 1;
          half == Half.First ? turnoversFirstHalf -= 1 : turnoversSecondHalf -= 1;
          break;
        case PossessionEnds.oBoard:
          oBoards -= 1;
          half == Half.First ? oBoardsFirstHalf -= 1 : oBoardsSecondHalf -= 1;
          break;
        case PossessionEnds.freeThrowMake:
          freeThrowMakes -= 1;
          half == Half.First ? freeThrowMakesFirstHalf -= 1 : freeThrowMakesSecondHalf -= 1;
          break;
        case PossessionEnds.freeThrowMiss:
          freeThrowMisses -= 1;
          half == Half.First ? freeThrowMissesFirstHalf -= 1 : freeThrowMakesSecondHalf -= 1;
          break;
        case PossessionEnds.foul:
          fouls -= 1;
          half == Half.First ? foulsFirstHalf -= 1 : foulsSecondHalf -= 1;
          break;
        case PossessionEnds.foulEndedPossession:
          foulEndedPossessions -= 1;
          half == Half.First ? foulEndedPossessionsFirstHalf -= 1 : foulEndedPossessionsSecondHalf -= 1;
          break;
        default:
      }


      half == Half.First ? possessionHistoryFirstHalf.removeLast() : possessionHistorySecondHalf.removeLast();

//      if (half == Half.Second && possessionHistorySecondHalf.isNotEmpty) {
//        possessionHistorySecondHalf.removeLast();
//      } else if (half == Half.Second && possessionHistorySecondHalf.isEmpty && possessionHistoryFirstHalf.isNotEmpty) {
//        possessionHistoryFirstHalf.removeLast();
//      } else if (half == Half.First && possessionHistoryFirstHalf.isNotEmpty) {
//        possessionHistoryFirstHalf.removeLast();
//      }

      possessionHistory.removeLast();
    }
  }
}

class DefensesUsed with ChangeNotifier {
  List <Defense> defensesUsed = [
    Defense('52'),
    Defense('Transition'),
    Defense('BLOB'),
  ];

  addDefense(Defense newDefense) {
    defensesUsed.insert(defensesUsed.length - 2, newDefense);
    notifyListeners();
  }

  removeDefense(Defense oldDefense) {
    final defenseToRemove = defensesUsed.indexOf(oldDefense);
    defensesUsed.removeAt(defenseToRemove);
    notifyListeners();
  }

  changeDefenseName(Defense oldDefense, String newName) {
    final index = defensesUsed.indexOf(oldDefense);
    defensesUsed[index].defenseType = newName;
    notifyListeners();
  }

}

enum PossessionEnds {
  twoPointMiss,
  twoPointMake,
  threePointMiss,
  threePointMake,
  turnover,
  oBoard,
  freeThrowMake,
  freeThrowMiss,
  foul,
  foulEndedPossession
}

class GlobalHistory with ChangeNotifier {
  List <Defense> history = [];
  List <GlobalPossessionResults> resultHistory = [];

  addPossession(Defense defensePlayed, Quarter quarter) {
    history.add(defensePlayed);
    resultHistory.add(GlobalPossessionResults(defensePlayed, defensePlayed.possessionHistory.last, quarter));
    notifyListeners();
  }

  removeLast() {
    print('history:');
    history.forEach((defense){
      print(defense.defenseType);
    });
    print('result history:');
    resultHistory.forEach((result){
      print(result.defensePlayed.defenseType);
    });
    history.removeLast();
    resultHistory.removeLast();
    notifyListeners();
  }


  removeAllOfDefenseType(Defense defenseToRemove) {

    for (var i = resultHistory.length - 1; i >= 0; i -= 1) {
      if (resultHistory[i].defensePlayed == defenseToRemove) {
        resultHistory.removeAt(i);
      }
    }

    for (var i = history.length - 1; i >= 0; i -= 1) {
      if (history[i].defenseType == defenseToRemove.defenseType) {
        history.removeAt(i);
      }
    }

    notifyListeners();
  }

  int numberOfQuarters() {

    bool q2 = false;
    bool q3 = false;
    bool q4 = false;

    resultHistory.forEach((possession){
      if (possession.quarter == Quarter.Fourth) {
        q4 = true;
      }
      else if (possession.quarter == Quarter.Third) {
        q3 = true;
      } else if (possession.quarter == Quarter.Second) {
        q2 = true;
      }
    });

    if (q4) {
      return 4;
    } else if (q3) {
      return 3;
    } else if (q2) {
      return 2;
    } else {
      return 1;
    }
  }

  int get possessions {

    int numberOfPossessions = 0;

    for (var i = 0; i < resultHistory.length; i += 1) {
      if (resultHistory[i].possessionEnds == PossessionEnds.twoPointMake || resultHistory[i].possessionEnds == PossessionEnds.twoPointMiss || resultHistory[i].possessionEnds == PossessionEnds.threePointMake || resultHistory[i].possessionEnds == PossessionEnds.threePointMiss || resultHistory[i].possessionEnds == PossessionEnds.turnover || resultHistory[i].possessionEnds == PossessionEnds.foulEndedPossession) {
        numberOfPossessions += 1;
      } else if (resultHistory[i].possessionEnds == PossessionEnds.oBoard) {
        numberOfPossessions -= 1;
      }
    }

    if (numberOfPossessions < 0) {
      numberOfPossessions = 0;
    }

    return numberOfPossessions;
  }

  int get points {
    int count = 0;
    resultHistory.forEach((possession) {
      if (possession.possessionEnds == PossessionEnds.twoPointMake) {
        count += 2;
      }

      if (possession.possessionEnds == PossessionEnds.threePointMake) {
        count += 3;
      }

      if (possession.possessionEnds == PossessionEnds.freeThrowMake) {
        count += 1;
      }

    });
    return count;
  }

  String get pointsPerPossession {
    if (possessions == 0) {
      return '0.0';
    }
    return (((twoPointMakes * 2) + (threePointMakes * 3) + freeThrowMakes).toDouble() / possessions.toDouble()).toStringAsFixed(1);
  }

  String get hudlPointsPerPossession {
    if (possessions == 0) {
      return '0.0';
    }

    return (((twoPointMakes * 2) + (threePointMakes * 3) + freeThrowMakes).toDouble() / (((twoPointAttempts + threePointAttempts) - oBoards) + turnovers + (0.44 * freeThrowAttempts)).toDouble()).toStringAsFixed(1);
  }

  int get twoPointMisses {
    int count = 0;
    resultHistory.forEach((possession) {
      if (possession.possessionEnds == PossessionEnds.twoPointMiss) {
        count += 1;
      }
    });
    return count;
  }

  int get twoPointMakes {
    int count = 0;
    resultHistory.forEach((possession) {
      if (possession.possessionEnds == PossessionEnds.twoPointMake) {
        count += 1;
      }
    });
    return count;
  }

  int get twoPointAttempts {
    return twoPointMakes + twoPointMisses;
  }

  int get threePointMisses {
    int count = 0;
    resultHistory.forEach((possession) {
      if (possession.possessionEnds == PossessionEnds.threePointMiss) {
        count += 1;
      }
    });
    return count;
  }

  int get threePointMakes {
    int count = 0;
    resultHistory.forEach((possession) {
      if (possession.possessionEnds == PossessionEnds.threePointMake) {
        count += 1;
      }
    });
    return count;
  }

  int get threePointAttempts {
    return threePointMakes + threePointMisses;
  }

  String get fieldGoalPercentage {
    if (twoPointAttempts == 0 && threePointAttempts == 0) {
      return'-';
    }
    final decimal = (twoPointMakes.toDouble() + threePointMakes.toDouble()) / (twoPointAttempts.toDouble() + threePointAttempts.toDouble());
    final percent = decimal * 100;
    return percent.toStringAsFixed(2) + '%';
  }

  String get threePointPercentage {
    if (threePointAttempts == 0) {
      return'-';
    }
    final decimal = threePointMakes.toDouble() / threePointAttempts.toDouble();
    final percent = decimal * 100;
    return percent.toStringAsFixed(2) + '%';
  }

  int get turnovers {
    int count = 0;
    resultHistory.forEach((possession) {
      if (possession.possessionEnds == PossessionEnds.turnover) {
        count += 1;
      }
    });
    return count;
  }

  String get turnoverPercentage {
    if (possessions == 0) {
      return'-';
    }
    final decimal = (turnovers.toDouble() / possessions.toDouble());
    final percent = decimal * 100;
    return percent.toStringAsFixed(2) + '%';
  }

  int get oBoards {
    int count = 0;
    resultHistory.forEach((possession) {
      if (possession.possessionEnds == PossessionEnds.oBoard) {
        count += 1;
      }
    });
    return count;
  }

  String get dBoardPercentage {
    if (twoPointMisses == 0 && threePointMisses == 0) {
      return '-';
    }
    final decimal = 1 - (oBoards.toDouble() / (twoPointMisses + threePointMisses).toDouble());
    final percent = decimal * 100;
    return percent.toStringAsFixed(2) + '%';
  }


  int get fouls {
    int count = 0;
    resultHistory.forEach((possession) {
      if (possession.possessionEnds == PossessionEnds.foul) {
        count += 1;
      }
    });
    return count;
  }

  int get freeThrowMakes {
    int count = 0;
    resultHistory.forEach((possession) {
      if (possession.possessionEnds == PossessionEnds.freeThrowMake) {
        count += 1;
      }
    });
    return count;
  }

  int get freeThrowMisses {
    int count = 0;
    resultHistory.forEach((possession) {
      if (possession.possessionEnds == PossessionEnds.freeThrowMiss) {
        count += 1;
      }
    });
    return count;
  }

  int get freeThrowAttempts {
    return freeThrowMakes + freeThrowMisses;
  }

  String get freeThrowPercentage {
    if (freeThrowAttempts == 0) {
      return '-';
    }
    final decimal = freeThrowMakes.toDouble() / freeThrowAttempts.toDouble();
    final percent = decimal * 100;
    return percent.toStringAsFixed(2) + '%';
  }



}

class GlobalPossessionResults {
  final Defense defensePlayed;
  final PossessionEnds possessionEnds;
  final Quarter quarter;

  GlobalPossessionResults(this.defensePlayed, this.possessionEnds, this.quarter);
}


class GameStatus with ChangeNotifier {
  Half half = Half.First;
  Quarter quarter = Quarter.First;

  updateQuarter(Quarter quarter) {

    if (quarter == Quarter.First) {
      half = Half.First;
      if (this.quarter == Quarter.First) {
        this.quarter = Quarter.Second;
      }
    } else {
      half = Half.Second;
      if (quarter == Quarter.Second && this.quarter == Quarter.Second) {
        this.quarter = Quarter.Third;
      } else if (quarter == Quarter.Third && this.quarter == Quarter.Third) {
        this.quarter = Quarter.Fourth;
      }
    }

    notifyListeners();
  }

}
