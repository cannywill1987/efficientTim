import 'package:time_hello/com/timehello/models/SquareModel.dart';

import '../config/ENUMS.dart';

class GameManager {
  static GameItemStatusEnum isSquareModelCorrect({required List<SquareModel> list, required SquareModel squareModel}) {
    SquareModel? squareModelCorrect = null;
    int i = 0;
    for (SquareModel squareModelTmp in list) {
        i++;
      if (squareModelTmp.isChecked == false) {
        squareModelCorrect = squareModelTmp;
        break;
      }
    }
    if (squareModelCorrect == null || i == list.length) {
      return GameItemStatusEnum.complete;
    } else if (squareModelCorrect == squareModel) {
      return GameItemStatusEnum.correct;
    } else {
      return GameItemStatusEnum.fail;
    }
  }
}