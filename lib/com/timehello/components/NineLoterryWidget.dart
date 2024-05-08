import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/EditItemWidget.dart';
import 'package:time_hello/com/timehello/components/SelectPresentDialogUtil.dart';
import 'package:time_hello/com/timehello/models/PresentModel.dart';

import '../util/SharePreferenceUtil.dart';
import '../util/Utility.dart';
import 'SelectMoneySettingDialogUtil.dart';

/**
 * 九宫格抽奖
 */
class NineLoterryWidget extends StatefulWidget {
  final Function()? onPress;
  final NineLoterryController nineLoterryController;

  // final List commodityList;

  const NineLoterryWidget(
      {Key? key,
      // required this.commodityList,
      required this.onPress,
      required this.nineLoterryController})
      : super(key: key);

  @override
  State<NineLoterryWidget> createState() => _NineLoterryWidgetState();
}

class _NineLoterryWidgetState extends State<NineLoterryWidget>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  Future<int>? future; // 标识
  List<PresentModel>? list;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        height: 300,
        // decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(8))),
        child: FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                // width: 250,
                // height: 200,
                // color: Colors.red,
                children: [
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1.0, color: Colors.red),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: 9,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 6,
                                mainAxisSpacing: 6),
                        itemBuilder: (context, index) {
                          if (index != 4) {
                            return getItem(index, list?[index] ?? null);
                          }
                          return GestureDetector(
                            onTap: widget.onPress,
                            child:
                                lotteryButton(getI18NKey().lottery.toString()),
                          );
                        }),
                  )
                ]);
          },
        ));
  }

  // 点击抽奖按钮
  Widget lotteryButton(String text) {
    return GestureDetector(
      onTap: widget.onPress,
      child: DecoratedBox(
          decoration: BoxDecoration(
              color: Colors.deepOrangeAccent,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Center(
              child: Text(text,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )))),
    );
  }

  String getText() {
    return getI18NKey().lottery.toString();
  }

  // 商品列表
  Widget getItem(int index, PresentModel? presentModel) {
    final int toIndex;
    if (index > 4) {
      toIndex = _deserializeMap[index];
    } else {
      toIndex = _deserializeMap[index];
    }
    // final dataInfo = widget.commodityList[toIndex];
    return Stack(
      children: [
        //背景
        Container(
            decoration: BoxDecoration(
          color: index == _currentSelect ? Colors.red : Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        )),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            // 九个按钮
            borderRadius: const BorderRadius.all(Radius.circular(6)),
          ),
          child: GestureDetector(
            onTap: () {
              SelectPresentDialogUtil.show(context,
                  title: "", content: "", isCheckButtonShow: true,
                  okCallBack: (List<PresentModel> datas) async {
                List<PresentModel> list = await MongoApisManager.getInstance().listPresentModel;
                List<PresentModel> listTmp = [];
                // datas 是都要更新的
                // datas.forEach((elem) {
                //   if(list.indexOf(elem)==) {
                //     elem.isLottery = true;
                //     list.remove(elem);
                //   }
                // });

                list.forEach((element) {
                  if (element.isLottery == true) {
                    element.isLottery = false;
                    list.add(element);
                  }
                });
                await MongoApisManager.getInstance()
                    .batchUpdate_PresentModel(listParam: datas);
                list = await requestGetPresentModelList();
                // setState(() {});
              });
            },
            child: EditItemWidget(
              isEnable: index == _currentSelect,
              text: presentModel?.title.toString() ?? "",
            ),
          ),
        ),
      ],
    );
  }

  Future<List<PresentModel>> requestGetPresentModelList() async {
    List<PresentModel> presentModelList = await MongoApisManager.getInstance()
        .queryWhereEqual_presentModelWithLottery();
    list = presentModelList;
    return presentModelList;
  }

  Animation? _selectedIndexTween;
  AnimationController? _startAnimateController;
  int _currentSelect = -1;
  int _target = 0;

  /// 旋转的圈数
  final int repeatRound = 3;
  VoidCallback? _listener;

  /// 选中下标的映射
  final Map _selectMap = {0: 0, 1: 3, 2: 6, 3: 7, 4: 8, 5: 5, 6: 2, 7: 1};

  //反下标的映射
  final Map _deserializeMap = {0: 0, 3: 1, 6: 2, 7: 3, 8: 4, 5: 5, 2: 6, 1: 7};

  simpleLotteryWidgetState() {
    _listener = () {
      // 开启抽奖动画
      if (widget.nineLoterryController.value.isPlaying) {
        _startAnimateController?.reset();
        _target = widget.nineLoterryController.value.target;
        _selectedIndexTween = _initSelectIndexTween(_target);

        _startAnimateController?.forward();
      }
    };
  }

  /// 初始化tween
  ///
  /// [target] 中奖的目标
  Animation _initSelectIndexTween(int target) =>
      StepTween(begin: 0, end: repeatRound * 8 + target).animate(
          CurvedAnimation(
              parent: _startAnimateController!, curve: Curves.easeOutQuart));

  @override
  void initState() {
    super.initState();

    future = Future.value(42);

     requestGetPresentModelList();
    _startAnimateController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    _selectedIndexTween = _initSelectIndexTween(_target);

    simpleLotteryWidgetState();

    // 控制监听
    widget.nineLoterryController.addListener(_listener!);

    // 动画监听
    _startAnimateController?.addListener(() {
      // 更新选中的下标
      _currentSelect = _selectMap[_selectedIndexTween?.value % 8];

      if (_startAnimateController!.isCompleted) {
        widget.nineLoterryController.finish();
      }
      setState(() {});
    });
  }

  @override
  void deactivate() {
    widget.nineLoterryController.removeListener(_listener!);
    super.deactivate();
  }

  @override
  void dispose() {
    _startAnimateController?.dispose();
    widget.nineLoterryController.dispose();
    super.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class NineLotteryValue {
  NineLotteryValue(
      {this.target = 0, this.isFinish = false, this.isPlaying = false});

  /// 中奖目标
  int target = 0;

  bool isPlaying = false;
  bool isFinish = false;

  NineLotteryValue copyWith({
    int target = 0,
    bool isPlaying = false,
    bool isFinish = false,
  }) {
    return NineLotteryValue(
        target: target, isFinish: isFinish, isPlaying: isPlaying);
  }

  @override
  String toString() {
    return "target : $target , isPlaying : $isPlaying , isFinish : $isFinish";
  }
}

class NineLoterryController extends ValueNotifier {
  NineLoterryController() : super(NineLotteryValue());

  /// 开启抽奖
  ///
  /// [target] 中奖目标
  void start(int target) {
    // 九宫格抽奖里范围为0~8
    assert(target >= 0 && target <= 8);
    if (value.isPlaying) {
      return;
    }
    value = value.copyWith(target: target, isPlaying: true);
  }

  void finish() {
    value = value.copyWith(isFinish: true);
  }
}
