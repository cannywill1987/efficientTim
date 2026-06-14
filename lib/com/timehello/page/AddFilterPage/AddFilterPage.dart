import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../../r.dart';
import '../../components/CustomCloseButton.dart';
import '../../components/IconButtonListWidget.dart';
import '../../components/InputNumber.dart';
import '../../config/CONSTANTS.dart';
import '../../config/ENUMS.dart';
import '../../config/Params.dart';
import '../../models/DateTimeModel.dart';
import '../../models/EventFn.dart';
import '../../models/FolderModel.dart';
import '../../util/ThemeManager.dart';
import '../createFolderPage/components/ColorsGridViewWidget.dart';

/// 文件类型：页面
/// 文件作用：创建或编辑任务过滤器，并把清单、颜色、日期、优先级和关键词条件保存到 FolderModel。
/// 主要职责：负责筛选条件表单展示、用户输入同步和本地 Mongo 数据写入。
// {unit: 0-days 1-hours 2-minutes,priority: [0, 1, 2, 3], keyword: '', missionType: 1, startTime: 0, endTime:  1000, listingId: [string, string, string]}
class AddFilterPage extends StatefulWidget {
  final FolderModel? folderModel;
  final PageModeEnum pageModeEnum;

  AddFilterPage({required this.folderModel, required this.pageModeEnum});

  @override
  _AddFilterPageState createState() => _AddFilterPageState();
}

class _AddFilterPageState extends State<AddFilterPage> {
  static const Color _modernAccentColor = Color(0xFFA7DE2B);
  static const Color _modernAccentDarkColor = Color(0xFF8AB92A);
  static const Color _modernSurfaceColor = Color(0xFFFFFEFB);
  static const Color _modernTextColor = Color(0xFF222222);
  static const Color _modernSubTextColor = Color(0xFF8A8A8A);
  static const Color _modernBorderColor = Color(0xFFD7EE9C);

  FilterConditionBean? filterConditionBean;
  List<CheckButtonStateModel> listFilterPeriodCheckButtonStateModel =
      CONSTANTS.getFilterPeriodPageCheckButtonStateModelList();
  List<CheckButtonStateModel> listPriorityCheckButtonStateModel =
      CONSTANTS.getPriorityButtonList();
  List<CheckButtonStateModel> listListingButtonStateModel = [];
  int _selectedDate = 0;
  TimeUnitEnum _selectedTimeUnit = TimeUnitEnum.days;
  int start_time = 0;
  int end_time = 0;
  TextEditingController? textEditingController;
  TextEditingController? textKeywordEditingController;
  GlobalKey<IconButtonListWidgetState> keyFolderIconButtonListWidgetState =
      GlobalKey();

  @override
  void initState() {
    super.initState();
    // 进入页面后先把数据库中的清单和已有过滤条件转成表单状态。
    initData();
  }

  /// 功能：初始化过滤器表单数据。
  /// 说明：新建过滤器时使用默认颜色和全选优先级；编辑过滤器时回填已有筛选条件。
  void initData() {
    List<FolderModel> listFolderModel =
        MongoApisManager.getInstance().queryWhereEqual_folderModelWithCircle();
    this.filterConditionBean =
        this.widget.folderModel?.filterConditionMapBean ??
            FilterConditionBean();
    textEditingController ??= TextEditingController();
    textKeywordEditingController ??= TextEditingController();
    textEditingController?.text = this.widget.folderModel?.title ?? '';
    textKeywordEditingController?.text =
        this.filterConditionBean?.keyword ?? '';
    if (this.widget.folderModel?.objectId == null) {
      this.widget.folderModel?.color = CONSTANTS.getColors()[0].color;
      _selectedDate = listFilterPeriodCheckButtonStateModel[0].value ?? '';
      this.filterConditionBean?.dateType = _selectedDate;
      this.filterConditionBean?.priority = this.getPriorityList();
      this.listListingButtonStateModel =
          listFolderModel.map((FolderModel folderModel) {
        return CheckButtonStateModel(
          title: folderModel.title,
          code: folderModel.objectId,
          isCheck: false,
        );
      }).toList(); // 获取所有的清单
    } else {
      _selectedDate =
          this.widget.folderModel?.filterConditionMapBean?.dateType ?? 0;
      this.listListingButtonStateModel =
          listFolderModel.map((FolderModel folderModel) {
        if (this
                .filterConditionBean
                ?.listingId
                ?.indexOf(folderModel.objectId ?? '') !=
            -1) {
          return CheckButtonStateModel(
            title: folderModel.title,
            code: folderModel.objectId,
            isCheck: true,
          );
        } else {
          return CheckButtonStateModel(
            title: folderModel.title,
            code: folderModel.objectId,
            isCheck: false,
          );
        }
      }).toList(); // 获取所有的清单
      if (mounted) {
        keyFolderIconButtonListWidgetState.currentState?.setList(
          this.listListingButtonStateModel,
        );
      }
      // this.start_time = ((this.widget.folderModel?.filterConditionMapBean?.startTime ?? 0) / 24 / 60 / 60 / 1000).toInt();
      // this.end_time = ((this.widget.folderModel?.filterConditionMapBean?.endTime ?? 0) / 24 / 60 / 60 / 1000).toInt();
      listPriorityCheckButtonStateModel.forEach((elem) {
        if (this
                .filterConditionBean
                ?.priority
                ?.contains(int.parse(elem.code ?? '1')) ??
            false) {
          elem.isCheck = true;
        } else {
          elem.isCheck = false;
        }
      });
    }
  }

  @override
  void didUpdateWidget(AddFilterPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.folderModel != this.widget.folderModel) {
      initData();
    }
  }

  @override
  void dispose() {
    // 页面关闭时释放输入框 controller，避免反复打开过滤器表单时残留监听和文本状态。
    textEditingController?.dispose();
    textKeywordEditingController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _modernSurfaceColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isNarrow = constraints.maxWidth < 760;
            final double pagePadding = isNarrow ? 18 : 28;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                pagePadding,
                14,
                pagePadding,
                36,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 980),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildModernBrandHeader(),
                      const SizedBox(height: 18),
                      _buildModernFilterCard(isNarrow: isNarrow),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// 功能：构建页面左上角的品牌识别区。
  /// 说明：参考移动端设计稿保留番茄 Logo 和应用名，让过滤器页面与首页头部视觉一致。
  Widget _buildModernBrandHeader() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Utility.getSVGPicture(R.assetsImgIcTomato, size: 34),
        const SizedBox(width: 12),
        const Text(
          '时间管理局 ToDo',
          style: TextStyle(
            color: _modernTextColor,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  /// 功能：构建过滤器表单主体卡片。
  /// 说明：外层卡片负责承接标题、输入项和保存按钮，避免页面在桌面窗口里显得过散。
  Widget _buildModernFilterCard({required bool isNarrow}) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        isNarrow ? 18 : 36,
        isNarrow ? 20 : 28,
        isNarrow ? 18 : 36,
        isNarrow ? 28 : 42,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1EFEA)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildModernTitleBar(),
          SizedBox(height: isNarrow ? 32 : 52),
          _buildFilterNameSection(),
          SizedBox(height: isNarrow ? 28 : 42),
          _buildListingSelector(isNarrow: isNarrow),
          SizedBox(height: isNarrow ? 28 : 42),
          _buildModernFormRow(
            isNarrow: isNarrow,
            icon: _buildSectionSvgIcon(R.assetsImgIcColors),
            title: getI18NKey().color,
            child: ColorsGridViewWidget(
              defaultIndexColor: this.widget.folderModel!.color,
              onTapListener: (data) {
                setState(() {
                  this.widget.folderModel?.color = data.color;
                });
              },
            ),
          ),
          SizedBox(height: isNarrow ? 24 : 34),
          _buildModernFormRow(
            isNarrow: isNarrow,
            icon: _buildSectionSvgIcon(R.assetsImgIcCalendar),
            title: getI18NKey().date,
            child: _buildDateSelector(context),
          ),
          SizedBox(height: isNarrow ? 24 : 34),
          _buildModernFormRow(
            isNarrow: isNarrow,
            icon: _buildSectionSvgIcon(R.assetsImgIcPriority),
            title: getI18NKey().priority,
            child: getPrioritiesWidget(),
          ),
          SizedBox(height: isNarrow ? 24 : 34),
          _buildModernFormRow(
            isNarrow: isNarrow,
            icon: _buildSectionSvgIcon(R.assetsImgIcSearch),
            title: getI18NKey().keyword,
            child: _buildKeywordInput(),
          ),
          SizedBox(height: isNarrow ? 36 : 50),
          _buildModernSaveButton(),
        ],
      ),
    );
  }

  /// 功能：构建表单顶部标题栏。
  /// 说明：返回按钮放在左侧，标题保持居中，编辑模式下删除入口仍保留在右侧。
  Widget _buildModernTitleBar() {
    return SizedBox(
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 44,
                minHeight: 44,
              ),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black,
                size: 32,
              ),
              onPressed: _closeFilterPage,
            ),
          ),
          Text(
            getI18NKey().add_filterer,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (widget.pageModeEnum == PageModeEnum.edit &&
              !TextUtil.isEmpty(widget.folderModel?.objectId))
            Align(
              alignment: Alignment.centerRight,
              child: _buildDeleteFilterAction(),
            ),
        ],
      ),
    );
  }

  /// 功能：构建过滤器名称输入区。
  /// 说明：设计稿中“使用帮助”与标题同行，输入框独立成绿色描边区域。
  Widget _buildFilterNameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _buildSectionSvgIcon(R.assetsImgIcFunnel),
            const SizedBox(width: 14),
            Text(
              getI18NKey().filter_name,
              style: const TextStyle(
                color: _modernTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            _buildHelpEntry(),
          ],
        ),
        const SizedBox(height: 18),
        TextField(
          controller: textEditingController,
          onChanged: (value) {
            setState(() {
              this.widget.folderModel?.title = value;
            });
          },
          decoration: _modernInputDecoration(
            hintText: '请输入过滤器名称',
          ),
        ),
      ],
    );
  }

  /// 功能：构建帮助入口。
  /// 说明：使用真实弹窗承载说明，避免桌面端 toast 不明显导致用户以为点击无效。
  Widget _buildHelpEntry() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: _showFilterHelpDialog,
        child: Ink(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.help_outline_rounded,
                color: _modernAccentDarkColor,
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                '使用帮助',
                style: TextStyle(
                  color: _modernAccentDarkColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 功能：弹出过滤器使用帮助。
  /// 说明：帮助内容直接解释当前表单会如何组合筛选条件，便于用户理解保存后的过滤效果。
  Future<void> _showFilterHelpDialog() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            '过滤器使用帮助',
            style: TextStyle(
              color: _modernTextColor,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: const SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FilterHelpLineWidget(
                  text: '过滤器会把清单、颜色、日期、优先级和关键词组合成一个动态清单。',
                ),
                SizedBox(height: 12),
                _FilterHelpLineWidget(
                  text: '清单和优先级支持多选；未选择时表示不限制该条件。',
                ),
                SizedBox(height: 12),
                _FilterHelpLineWidget(
                  text: '关键词可用逗号分隔多个词，用于匹配任务标题或内容。',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(
                '知道了',
                style: TextStyle(
                  color: _modernAccentDarkColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// 功能：构建清单选择区域。
  /// 说明：移动端优先让清单 chip 获得横向空间，隐藏左侧分组栏；宽屏仍保留原来的标签栏结构。
  Widget _buildListingSelector({required bool isNarrow}) {
    final Widget listingContent = Padding(
      padding: EdgeInsets.fromLTRB(
        isNarrow ? 12 : 30,
        isNarrow ? 18 : 22,
        isNarrow ? 12 : 30,
        isNarrow ? 20 : 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCustomListingButton(),
          const SizedBox(height: 14),
          IconButtonListWidget(
            key: keyFolderIconButtonListWidgetState,
            initIndex: -1,
            marginVertical: 5,
            wrapMode: WrapModeEnum.wrap,
            selectTypeEnum: SelectTypeEnum.multiple,
            list: this.listListingButtonStateModel,
            onTapListener: (list) {
              List<CheckButtonStateModel> listTmp = list['data'];
              List<String> listId = [];
              listTmp.forEach((element) {
                if (element.isCheck) {
                  listId.add(element.code ?? '');
                }
              });
              this.filterConditionBean?.listingId = listId;
            },
          ),
        ],
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF0E9E0)),
      ),
      child: isNarrow
          ? listingContent
          : IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 142,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Utility.getSVGPicture(
                            R.assetsImgIcFolder,
                            size: 26,
                            color: _modernAccentDarkColor,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            getI18NKey().listing,
                            style: const TextStyle(
                              color: _modernTextColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: Color(0xFFF0E9E0),
                  ),
                  Expanded(child: listingContent),
                ],
              ),
            ),
    );
  }

  /// 功能：构建清单区域里的“自定义清单”胶囊按钮。
  /// 说明：此处只作为筛选页的轻入口提示，避免在过滤器表单里插入额外建清单流程。
  Widget _buildCustomListingButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _modernBorderColor),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add_rounded, size: 20, color: _modernAccentDarkColor),
          SizedBox(width: 8),
          Text(
            '自定义清单',
            style: TextStyle(
              color: _modernAccentDarkColor,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  /// 功能：构建常规表单行。
  /// 说明：宽屏时采用“左标签 + 右内容”，窄屏时自动纵向排列，避免移动端内容被压缩。
  Widget _buildModernFormRow({
    required bool isNarrow,
    required Widget icon,
    required String title,
    required Widget child,
  }) {
    final Widget label = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(width: 14),
        Text(
          title,
          style: const TextStyle(
            color: _modernTextColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );

    if (isNarrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label,
          const SizedBox(height: 14),
          child,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 150, child: label),
        const SizedBox(width: 28),
        Expanded(child: child),
      ],
    );
  }

  /// 功能：构建表单标题左侧的 SVG 图标。
  /// 说明：统一复用 Utility.getSVGPicture 的染色能力，保证筛选页图标和项目资产风格一致。
  Widget _buildSectionSvgIcon(String iconPath) {
    return Utility.getSVGPicture(
      iconPath,
      size: 24,
      color: _modernAccentDarkColor,
    );
  }

  /// 功能：构建日期筛选选择器。
  /// 说明：保留原有日期类型、相对天数和自定义起止时间写入逻辑，只调整控件外观。
  Widget _buildDateSelector(BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 14,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E2E2)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: _selectedDate,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF777777),
              ),
              items: listFilterPeriodCheckButtonStateModel
                  .map((CheckButtonStateModel value) {
                return DropdownMenuItem<int>(
                  value: value.value,
                  child: Text(value.title ?? ''),
                );
              }).toList(),
              onChanged: _handleDateTypeChanged,
            ),
          ),
        ),
        if (_selectedDate == 4)
          InputNumber(
            minVal: 0,
            defaultVal: ((this.filterConditionBean?.valueBefore ??
                        (24 * 60 * 60 * 1000)) /
                    24 /
                    60 /
                    60 /
                    1000)
                .toInt(),
            onValueChangeListener: (obj, int? durationEachTomato) {
              switch (_selectedTimeUnit) {
                case TimeUnitEnum.days:
                  this.filterConditionBean?.valueBefore =
                      obj * 24 * 60 * 60 * 1000;
                  break;
                case TimeUnitEnum.hours:
                  this.filterConditionBean?.valueBefore = obj * 60 * 60 * 1000;
                  break;
                case TimeUnitEnum.minutes:
                  this.filterConditionBean?.valueBefore = obj * 60 * 1000;
                  break;
              }
            },
            unit: getUnitBefore(),
          ),
        if (_selectedDate == 4)
          InputNumber(
            minVal: 0,
            defaultVal: ((this.filterConditionBean?.valueAfter ??
                        (24 * 60 * 60 * 1000)) /
                    24 /
                    60 /
                    60 /
                    1000)
                .toInt(),
            onValueChangeListener: (obj, int? durationEachTomato) {
              switch (_selectedTimeUnit) {
                case TimeUnitEnum.days:
                  this.filterConditionBean?.valueAfter =
                      obj * 24 * 60 * 60 * 1000;
                  break;
                case TimeUnitEnum.hours:
                  this.filterConditionBean?.valueAfter = obj * 60 * 60 * 1000;
                  break;
                case TimeUnitEnum.minutes:
                  this.filterConditionBean?.valueAfter = obj * 60 * 1000;
                  break;
              }
            },
            unit: getUnitAfter(),
          ),
        if (_selectedDate == 5) getDailyStartTimeWidget(context),
        if (_selectedDate == 5) getDailyEndTimeWidget(context),
      ],
    );
  }

  /// 功能：处理日期类型切换。
  /// 说明：日期类型会直接写入 FilterConditionBean，后续保存时随 FolderModel 一起入库。
  void _handleDateTypeChanged(int? code) {
    if (code == null) {
      return;
    }
    CheckButtonStateModel model = listFilterPeriodCheckButtonStateModel[code];
    switch (model.code) {
      case 'today':
        // Utility.getFilterDateTimeFromDateTime(DateTime.now());
        break;
      case 'tomorrow':
        break;
      case 'this_week':
        break;
      case 'customize_days_before':
        this.filterConditionBean?.unit =
            TimeUnitEnum.values.indexOf(this._selectedTimeUnit);
        break;
      case 'customize_days_period':
        break;
    }
    _selectedDate = code;
    this.filterConditionBean?.dateType = model.value;
    setState(() {});
  }

  /// 功能：构建关键词输入框。
  /// 说明：关键词写入过滤条件后，列表页可按任务标题或内容进行二次筛选。
  Widget _buildKeywordInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: textKeywordEditingController,
          onChanged: (value) {
            setState(() {
              filterConditionBean?.keyword = value;
            });
          },
          decoration: _modernInputDecoration(
            hintText: getI18NKey().please_input_keyword,
            borderColor: const Color(0xFFE8E8E8),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          '多个关键词用逗号分隔，例如：设计，会议，报告',
          style: TextStyle(
            color: _modernSubTextColor,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  InputDecoration _modernInputDecoration({
    required String hintText,
    Color borderColor = _modernBorderColor,
  }) {
    final OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: borderColor, width: 1),
    );

    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Color(0xFFB8B8B8),
        fontSize: 16,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(color: _modernAccentColor, width: 1.2),
      ),
      enabledBorder: border,
      disabledBorder: border,
      focusedErrorBorder: border,
      errorBorder: border,
      border: border,
    );
  }

  /// 功能：构建底部保存按钮。
  /// 说明：名称为空时只降低视觉强度，点击后仍交给原保存逻辑做最终校验，避免改动旧行为。
  Widget _buildModernSaveButton() {
    final bool isNameEmpty = TextUtil.isEmpty(this.widget.folderModel?.title);
    return Opacity(
      opacity: isNameEmpty ? 0.55 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onclickSaveFilter,
          child: Ink(
            height: 62,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(
                colors: [
                  _modernAccentColor,
                  ThemeManager.getInstance().getDefautThemeColor(),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: _modernAccentColor.withValues(alpha: 0.28),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                '保存过滤器',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 编辑过滤器时给一个更显眼的删除入口，避免用户只能去列表页里猜操作。
  Widget _buildDeleteFilterAction() {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: _confirmDeleteFilter,
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1ED),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFFFD9CF)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.delete_outline_rounded,
                  size: 16,
                  color: Color(0xFFE26645),
                ),
                const SizedBox(width: 4),
                Text(
                  getI18NKey().delete,
                  style: const TextStyle(
                    color: Color(0xFFE26645),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDeleteFilter() async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Text(
            getI18NKey().confirm_delete_folder(widget.folderModel?.title ?? ''),
          ),
          content: Text(getI18NKey().confirm_delete_folder_desc),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(getI18NKey().cancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFE26645),
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(getI18NKey().confirm),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true ||
        TextUtil.isEmpty(widget.folderModel?.objectId)) {
      return;
    }

    await MongoApisManager.getInstance()
        .delete_FolderModel(currentObjectId: widget.folderModel?.objectId);
    eventBus.fire(EventFn(Params.ACTION_UPDATE_LISTVIEW, {}));
    Utility.showToastMsg(msg: '过滤器已删除');
    if (mounted) {
      _closeFilterPage(true);
    }
  }

  Wrap getPrioritiesWidget() {
    return Wrap(
      spacing: 8.0,
      children:
          listPriorityCheckButtonStateModel.map((CheckButtonStateModel option) {
        return FilterChip(
          label: Text(option.title ?? ''),
          selected: option.isCheck,
          onSelected: (bool selected) {
            option.isCheck = selected;
            this.filterConditionBean?.priority = this.getPriorityList();
            setState(() {});
          },
        );
      }).toList(),
    );
  }

  List<int> getPriorityList() {
    List<int> list = [];
    listPriorityCheckButtonStateModel.forEach((elem) {
      if (elem.isCheck) {
        list.add(int.parse((elem.code ?? "1")));
      }
    });
    return list;
  }

  /// 功能：保存过滤器配置。
  /// 说明：保存成功后移动端走 Navigator pop，桌面端走 Env.routerData 清理，回到任务内容区。
  Future<void> onclickSaveFilter() async {
    final FolderModel? folderModel = this.widget.folderModel;
    if (folderModel == null) {
      return;
    }

    folderModel.filterType = 1;
    folderModel.tag = 4;
    folderModel.filterConditionMapBean = this.filterConditionBean;

    final bool isCreate = folderModel.objectId == null;
    dynamic saveResult;
    if (isCreate) {
      saveResult = await MongoApisManager.getInstance()
          .insertFolderModel(folderModel: folderModel);
    } else {
      saveResult = await MongoApisManager.getInstance()
          .update_FolderModelWithFM(folderModel: folderModel);
    }

    // 数据库保存失败或权限校验失败时不关闭页面，保留当前表单方便用户继续处理。
    if (saveResult == null) {
      return;
    }

    eventBus.fire(EventFn(Params.ACTION_UPDATE_FOLDER_PAGE, {}));
    Utility.showToastMsg(
      msg: isCreate ? getI18NKey().createSuccess : getI18NKey().updateSuccess,
    );
    if (mounted) {
      _closeAfterSaveFilter(saveResult);
    }
  }

  /// 功能：保存过滤器后关闭当前表单。
  /// 说明：移动端和桌面端使用的路由机制不同，因此这里集中处理返回差异。
  void _closeAfterSaveFilter(dynamic saveResult) {
    _closeFilterPage(saveResult);
  }

  /// 功能：关闭过滤器表单。
  /// 说明：移动端页面是 Navigator 栈，桌面端页面是 Env.routerData 切换出来的内容区。
  void _closeFilterPage([dynamic result]) {
    if (!mounted) {
      return;
    }

    if (Utility.isHandsetBySize()) {
      if (result != null) {
        Utility.popNavigator(context, result);
      } else {
        Utility.popNavigator(context);
      }
      return;
    }

    Utility.popupDesktopNavigator(context);
  }

  InkWell getDailyStartTimeWidget(BuildContext context) {
    return InkWell(
      child: Wrap(
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            getI18NKey().start_time,
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
          SizedBox(
            width: 5,
          ),
          new Text(
              start_time == 0
                  ? getI18NKey().now
                  : CONSTANTS.getAlertDateString(
                      Utility.getDateTimeModelFromTimeStamp(this.start_time)),
              style: TextStyle(
                  color: ThemeManager.getInstance()
                      .getTextColor(defaultColor: Colors.black87),
                  fontSize: 12)),
          Icon(
            Icons.arrow_right_sharp,
            color: ThemeManager.getInstance()
                .getIconColor(defaultColor: Colors.black87),
          ),
          Icon(
            Icons.arrow_right_sharp,
            color: ThemeManager.getInstance()
                .getIconColor(defaultColor: Colors.black87),
          )
        ],
      ),
      onTap: () async {
        DateTimeModel? model = await Utility.showDateTimePickerDialog(context);
        // updateAlertTime();
        this.setState(() {
          this.start_time =
              model?.datetime?.millisecondsSinceEpoch ?? 0; //计划到期日
          this.filterConditionBean?.startTime = this.start_time;
        });
      },
    );
  }

  InkWell getDailyEndTimeWidget(BuildContext context) {
    return InkWell(
      child: Wrap(
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            getI18NKey().end_time,
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
          SizedBox(
            width: 5,
          ),
          new Text(
              end_time == 0
                  ? getI18NKey().now
                  : CONSTANTS.getAlertDateString(
                      Utility.getDateTimeModelFromTimeStamp(this.end_time)),
              style: TextStyle(
                  color: ThemeManager.getInstance()
                      .getTextColor(defaultColor: Colors.black87),
                  fontSize: 12)),
          CustomCloseButton(
            margin: EdgeInsets.only(left: 5),
            onTapListener: () {
              this.end_time = 0; //计划到期日
              // this.daily_end_time = null;
              setState(() {});
            },
          ),
          Icon(
            Icons.arrow_right_sharp,
            color: ThemeManager.getInstance()
                .getIconColor(defaultColor: Colors.black87),
          )
        ],
      ),
      onTap: () async {
        DateTimeModel? model = await Utility.showDateTimePickerDialog(context);
        // updateAlertTime();
        this.setState(() {
          this.end_time = model?.datetime?.millisecondsSinceEpoch ?? 0; //计划到期日
          this.filterConditionBean?.endTime = this.end_time;
        });
        setState(() {});
      },
    );
  }

  String getUnitBefore() {
    switch (_selectedTimeUnit) {
      case TimeUnitEnum.days:
        return getI18NKey().before_n_days;
      case TimeUnitEnum.hours:
        return '小时';
      case TimeUnitEnum.minutes:
        return '分钟';
      default:
        return '天';
    }
  }

  String getUnitAfter() {
    switch (_selectedTimeUnit) {
      case TimeUnitEnum.days:
        return getI18NKey().after_n_days;
      case TimeUnitEnum.hours:
        return '小时';
      case TimeUnitEnum.minutes:
        return '分钟';
      default:
        return '天';
    }
  }
}

/// 文件内组件：过滤器帮助弹窗的单行说明。
/// 作用：统一帮助文案前的绿色圆点和文字样式，避免弹窗内容里重复写布局。
class _FilterHelpLineWidget extends StatelessWidget {
  final String text;

  const _FilterHelpLineWidget({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 7,
          height: 7,
          margin: const EdgeInsets.only(top: 8, right: 10),
          decoration: const BoxDecoration(
            color: _AddFilterPageState._modernAccentDarkColor,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: _AddFilterPageState._modernTextColor,
              fontSize: 15,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}
