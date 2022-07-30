
import 'package:flutter/material.dart';
import 'package:possessions_app/QuarterScoreWidget.dart';
import 'package:provider/provider.dart';

import 'Possession.dart';

class HistoryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final globalHistoryProvider = Provider.of<GlobalHistory>(context);
    int firstQPossessions = 0;
    int secondQPossessions = 0;
    int thirdQPossessions = 0;
    int fourthQPossessions = 0;



    globalHistoryProvider.resultHistory.forEach((result) {
      if (result.quarter == Quarter.First) {
        firstQPossessions += 1;
      }

      if (result.quarter == Quarter.Second) {
        secondQPossessions += 1;
      }

      if (result.quarter == Quarter.Third) {
        thirdQPossessions += 1;
      }

      if (result.quarter == Quarter.Fourth) {
        fourthQPossessions += 1;
      }

    });

    List<GlobalPossessionResults> reversedHistory = [];

    reversedHistory = globalHistoryProvider.resultHistory.map((result) => result).toList();
    for (var i = reversedHistory.length - 1; i >= 0; i -= 1) {
      if (reversedHistory[i].possessionEnds == PossessionEnds.foulEndedPossession) {
        reversedHistory.removeAt(i);
      }
    }


    return Scaffold(
      appBar: AppBar(),
      body: ListView.separated(
        itemCount: reversedHistory.length + globalHistoryProvider.numberOfQuarters(),
        itemBuilder: (context, index) {

//          List<GlobalPossessionResults> reversedHistory = [];
//
//          reversedHistory = globalHistoryProvider.resultHistory.map((result) => result).toList();
//          for (var i = reversedHistory.length - 1; i >= 0; i -= 1) {
//            if (reversedHistory[i].possessionEnds == PossessionEnds.foulEndedPossession) {
//              reversedHistory.removeAt(i);
//            }
//          }
         // reversedHistory = reversedHistory.reversed.toList();

          if (index == 0) {
            return QuarterMarker(quarter: '1st Quarter');
          }

          if (index == firstQPossessions + 1 && secondQPossessions != 0) {
            return QuarterMarker(quarter: '2nd Quarter');
          }

          if (index == firstQPossessions + secondQPossessions + 2 && secondQPossessions != 0 && thirdQPossessions != 0) {
            return QuarterMarker(quarter: '3rd Quarter');
          }

          if (index == firstQPossessions + secondQPossessions + thirdQPossessions + 3 && secondQPossessions != 0 && thirdQPossessions != 0 && fourthQPossessions != 0) {
            return QuarterMarker(quarter: '4th Quarter');
          }


          int defenseIndex = 0;
          String defenseName = '';
          String possessionResult = '';
          Color textColor = Colors.black;

          if (index <= firstQPossessions) {
            defenseIndex = index - 1;
          } else if (index > firstQPossessions + 1 && index <= secondQPossessions + firstQPossessions + 1) {
            defenseIndex = index - 2;
          } else if (index > secondQPossessions + firstQPossessions + 2 && index <= thirdQPossessions + secondQPossessions + firstQPossessions + 2) {
            defenseIndex = index - 3;
          } else {
            defenseIndex = index - 4;
          }

          defenseName = reversedHistory[defenseIndex].defensePlayed.defenseType;
          possessionResult = Defense('').possessionHistoryAsString(reversedHistory[defenseIndex].possessionEnds);

          textColor = Colors.black;

          if (globalHistoryProvider.resultHistory[defenseIndex].possessionEnds == PossessionEnds.twoPointMake || globalHistoryProvider.resultHistory[defenseIndex].possessionEnds == PossessionEnds.threePointMake || globalHistoryProvider.resultHistory[defenseIndex].possessionEnds == PossessionEnds.freeThrowMake) {
            textColor = Colors.red;
          } else if (globalHistoryProvider.resultHistory[defenseIndex].possessionEnds == PossessionEnds.turnover || globalHistoryProvider.resultHistory[defenseIndex].possessionEnds == PossessionEnds.twoPointMiss || globalHistoryProvider.resultHistory[defenseIndex].possessionEnds == PossessionEnds.threePointMiss) {
            textColor = Colors.green;
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(defenseName,
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),),
                  SizedBox(
                    height: 3.0,
                  ),
                  Text(possessionResult,
                    style: TextStyle(
                        color: textColor
                    ),)
                ]
            ),
          );

        },
        separatorBuilder: (context, index) => Divider(),
      ),
    );
  }
}

class QuarterMarker extends StatelessWidget {

  final String quarter;

  const QuarterMarker({Key key, this.quarter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(this.quarter,
            style: TextStyle(
                fontWeight: FontWeight.bold
            ),)
      ),
    );
  }
}

