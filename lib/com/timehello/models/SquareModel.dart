/**
 * 每个bar的一格
 */
class SquareModel {
  String val;
  double posX;
  double posY;
  double width; //当前对象宽度
  double height; //当前对象高度
  double containerWidth; //容器宽度
  double containerHeight; //容器高度
  bool isChecked;
  SquareModel(
      {required this.val,
      required this.posX,
      required this.posY,
      required this.width,
      required this.height,
      required this.containerWidth,
      required this.containerHeight,
        this.isChecked = false});

  /**
   * 是否交叉
   */
  bool isIntersect(SquareModel squareModel, {int margin = 15}) {
    if (this.posX > (squareModel.posX + squareModel.width + margin) || (this.posX + this.width + margin) < squareModel.posX) {
      return false;
    } else if (this.posY > (squareModel.posY + squareModel.height + margin) || (this.posY + this.height + margin) < squareModel.posY) {
      return false;
    }
    return true;
  }
}
