import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/models/CheckButtonStateModel.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../components/CustomCloseButton.dart';
import '../../components/IconButtonListWidget.dart';
import '../../components/InputNumber.dart';
import '../../config/CONSTANTS.dart';
import '../../config/ENUMS.dart';
import '../../models/DateTimeModel.dart';
import '../../models/FolderModel.dart';
import '../../util/ThemeManager.dart';
import '../createFolderPage/components/ColorsGridViewWidget.dart';

// {unit: 0-days 1-hours 2-minutes,priority: [0, 1, 2, 3], keyword: '', missionType: 1, startTime: 0, endTime:  1000, listingId: [string, string, string]}
class AddFilterPage extends StatefulWidget {
  FolderModel? folderModel;
  PageModeEnum pageModeEnum;

  AddFilterPage({required this.folderModel, required this.pageModeEnum});

  @override
  _AddFilterPageState createState() => _AddFilterPageState();
}

class _AddFilterPageState extends State<AddFilterPage> {
  FilterConditionBean? filterConditionBean;
  List<CheckButtonStateModel> listFilterPeriodCheckButtonStateModel =
      CONSTANTS.getFilterPeriodPageCheckButtonStateModelList();
  List<CheckButtonStateModel> listPriorityCheckButtonStateModel =
      CONSTANTS.getPriorityButtonList();
  List<CheckButtonStateModel> listListingButtonStateModel = [];
  int _selectedDate = 0;
  TimeUnitEnum _selectedTimeUnit = TimeUnitEnum.days;
  String? startTime;
  int start_time = 0;
  int end_time = 0;
  TextEditingController? textEditingController;
  TextEditingController? textKeywordEditingController;
  GlobalKey<IconButtonListWidgetState> keyColorsIconButtonListWidgetState = GlobalKey();
  GlobalKey<IconButtonListWidgetState> keyFolderIconButtonListWidgetState = GlobalKey();
  OutlineInputBorder _outlineInputBorder = OutlineInputBorder(
    gapPadding: 0,
    borderSide:
    BorderSide(color: ThemeManager.getInstance().getInputBorderColor()),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();



    // this.filterConditionBean.dateType;

    // FilterConditionBean
    // List<int>? priority; // 0, 1, 2, 3
    // String? keyword;
    // int? missionType;
    // int? startTime;
    // int? endTime;
    // List<String>? listingId;

    // this._filterName =

  }

  void initData() {
       List<FolderModel> listFolderModel =
    MongoApisManager.getInstance().queryWhereEqual_folderModelWithCircle();
      this.filterConditionBean =
          this.widget.folderModel?.filterConditionMapBean ??
              FilterConditionBean();
    if(this.widget.folderModel?.objectId == null) {
      this.widget.folderModel?.color = CONSTANTS.getColors()[0].color;
      _selectedDate = listFilterPeriodCheckButtonStateModel[0].value ?? '';
      this.filterConditionBean?.dateType = _selectedDate;
      this.filterConditionBean?.priority = this.getPriorityList();
      this.listListingButtonStateModel =
          listFolderModel.map((FolderModel folderModel) {
            return CheckButtonStateModel(
                title: folderModel.title, code: folderModel.objectId, isCheck: false);
          }).toList(); // 获取所有的清单
    } else {
      _selectedDate = this.widget.folderModel?.filterConditionMapBean?.dateType ?? 0;
      this.listListingButtonStateModel =
          listFolderModel.map((FolderModel folderModel) {
            if(this.filterConditionBean?.listingId?.indexOf(folderModel?.objectId ?? '') != -1) {
              return CheckButtonStateModel(
                  title: folderModel.title,
                  code: folderModel.objectId,
                  isCheck: true);
            } else {
              return CheckButtonStateModel(
                  title: folderModel.title,
                  code: folderModel.objectId,
                  isCheck: false);
            }
          }).toList(); // 获取所有的清单
      if(mounted) {
        keyColorsIconButtonListWidgetState.currentState?.setList(
            this.listListingButtonStateModel);
      }
      // this.start_time = ((this.widget.folderModel?.filterConditionMapBean?.startTime ?? 0) / 24 / 60 / 60 / 1000).toInt();
      // this.end_time = ((this.widget.folderModel?.filterConditionMapBean?.endTime ?? 0) / 24 / 60 / 60 / 1000).toInt();
      textEditingController = TextEditingController(text: this.widget.folderModel?.title ?? '');
      textKeywordEditingController = TextEditingController(text: this.widget.folderModel?.filterConditionMapBean?.keyword ?? '');
      listPriorityCheckButtonStateModel.forEach((elem) {
        if (this.filterConditionBean?.priority?.contains(int.parse(elem.code ?? '1')) ?? false) {
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
    if(oldWidget.folderModel != this.widget.folderModel) {
      initData();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getI18NKey().add_filterer),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 普通/高级 tabs
              // Row(
              //   children: [
              //     _buildTab('普通', true),
              //     _buildTab('高级', false),
              //   ],
              // ),
              SizedBox(height: 16.0),
              // 过滤器名称
              TextField(
                controller: textEditingController,
                onChanged: (value) {
                  setState(() {
                    // _filterName = value;
                    this.widget.folderModel?.title = value;
                  });
                },
                  decoration: InputDecoration(
                    // border: OutlineInputBorder(),
                      hoverColor: ThemeManager.getInstance()
                          .getCardBackgroundColor(
                        defaultColor: Colors.white,
                      ),
                      focusColor: ThemeManager.getInstance()
                          .getInputThemeColor(
                          defaultColor: Colors.white,
                          defaultDarkColor: ThemeManager.getInstance()
                              .getBackgroundColor()),
                      //右边距是为了放置番茄计数器
                      fillColor: ThemeManager.getInstance()
                          .getInputThemeColor(defaultColor: Colors.white),
                      filled: true,
                      focusedBorder: _outlineInputBorder,
                      enabledBorder: _outlineInputBorder,
                      disabledBorder: _outlineInputBorder,
                      focusedErrorBorder: _outlineInputBorder,
                      errorBorder: _outlineInputBorder,
                      border: _outlineInputBorder,
                    labelText: getI18NKey().filter_name,
                      contentPadding: EdgeInsets.all(0.0),
                      prefixIcon: Icon(Icons.filter_alt, color: Color(this.widget.folderModel?.color ?? 0xff000000)),
                      )

              ),
              SizedBox(height: 16.0),

              // 清单下拉菜单
              _SectionTitleWidget(
                  child: IconButtonListWidget(
                    key: keyColorsIconButtonListWidgetState,
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
                      this.filterConditionBean?.listingId = listId ?? [];
                    },
                  ),
                  title: getI18NKey().listing),
              // DropdownButton<String>(
              //   value: _selectedList,
              //   items: ['所有', '列表1', '列表2'].map((String value) {
              //     return DropdownMenuItem<String>(
              //       value: value,
              //       child: Text(value),
              //     );
              //   }).toList(),
              //   onChanged: (newValue) {
              //     setState(() {
              //       _selectedList = newValue!;
              //     });
              //   },
              // ),
        SizedBox(height: 16.0),
        _SectionTitleWidget(
          title: getI18NKey().color,
          child:ColorsGridViewWidget(
              defaultIndexColor: this.widget.folderModel!.color,
              onTapListener: (data) {
                setState(() {
                  this.widget.folderModel?.color = data.color;
                });
              })
        ),

              SizedBox(height: 16.0),
              _SectionTitleWidget(
                title: getI18NKey().date,
                child: Wrap(
                  children: [
                    DropdownButton<int>(
                      value: _selectedDate,
                      items: listFilterPeriodCheckButtonStateModel
                          .map((CheckButtonStateModel value) {
                        return DropdownMenuItem<int>(
                          value: value.value,
                          child: Text(value.title ?? ''),
                        );
                      }).toList(),
                      onChanged: (int? code) {
                        CheckButtonStateModel model =
                            listFilterPeriodCheckButtonStateModel[(code ?? 0)];
                        switch (model.code) {
                          case 'today':
                            // Utility.getFilterDateTimeFromDateTime(DateTime.now());
                            break;
                          case 'tomorrow':
                            break;
                          case 'this_week':
                            break;
                          case 'customize_days_before':
                            this.filterConditionBean?.unit = TimeUnitEnum.values.indexOf(this._selectedTimeUnit);
                            break;
                          case 'customize_days_period':
                            break;
                        }
                          _selectedDate = code!;
                        this.filterConditionBean?.dateType = model.value;
                        setState(() {
                        });
                      },
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    if (_selectedDate == 4)
                      InputNumber(
                        minVal: 0,
                        defaultVal: ((this.filterConditionBean?.valueBefore ?? (24 * 60 * 60 * 1000))/ 24 / 60 / 60 / 1000).toInt(),
                        onValueChangeListener: (obj, int? durationEachTomato) {
                          switch(_selectedTimeUnit) {
                            case TimeUnitEnum.days: // 天
                              this.filterConditionBean?.valueBefore = obj * 24 * 60 * 60 * 1000;
                              break;
                            case TimeUnitEnum.hours: // 小时
                              this.filterConditionBean?.valueBefore = obj * 60 * 60 * 1000;
                              break;
                          }
                          // this.filterConditionBean?.value = obj;
                        },
                        unit: getUnitBefore(),
                      ),
                    SizedBox(width: 20,),
                    if (_selectedDate == 4)
                    InputNumber(
                      minVal: 0,
                      defaultVal: ((this.filterConditionBean?.valueAfter ?? (24 * 60 * 60 * 1000))/ 24 / 60 / 60 / 1000).toInt(),
                      onValueChangeListener: (obj, int? durationEachTomato) {
                        switch(_selectedTimeUnit) {
                          case TimeUnitEnum.days: // 天
                            this.filterConditionBean?.valueAfter = obj * 24 * 60 * 60 * 1000;
                            break;
                          case TimeUnitEnum.hours: // 小时
                            this.filterConditionBean?.valueAfter = obj * 60 * 60 * 1000;
                            break;
                        }
                        // this.filterConditionBean?.value = obj;
                      },
                      unit: getUnitAfter(),
                    ),

                    if (_selectedDate == 5)
                      SizedBox(
                        width: 30,
                      ),
                    if (_selectedDate == 5)
                      getDailyStartTimeWidget(context),
                    if (_selectedDate == 5)
                      SizedBox(
                        width: 30,
                      ),
                    if (_selectedDate == 5)
                      getDailyEndTimeWidget(context),
                  ],

                ),
              ),
              // 日期下拉菜单

              SizedBox(height: 16.0),
              _SectionTitleWidget(
                title: getI18NKey().priority,
                child: getPrioritiesWidget(),
              ),
              // 优先级选择

              SizedBox(height: 16.0),
              // 内容包含关键词
              _SectionTitleWidget(
                title: getI18NKey().keyword,
                child: Container(
                  child: TextField(
                    controller: textKeywordEditingController,
                    onChanged: (value) {
                      setState(() {
                        filterConditionBean?.keyword = value;
                        // _taskKeyword = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: getI18NKey().please_input_keyword,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),

              //       SizedBox(height: 16.0),
              //       _SectionTitleWidget(title: '任务类型', child:Wrap(
              //         spacing: 8.0,
              //         children: ['所有', '任务', '笔记'].map((String option) {
              //           return ChoiceChip(
              //             label: Text(option),
              //             selected: _selectedTaskType == option,
              //             onSelected: (bool selected) {
              //               setState(() {
              //                 _selectedTaskType = option;
              //               });
              //             },
              //           );
              //         }).toList(),
              //       ),),
              //
              SizedBox(height: 16.0),

              // 保存按钮
              Container(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: onclickSaveFilter,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (TextUtil.isEmpty(this.widget.folderModel?.title)) {
                          return ThemeManager.getInstance().getDefautThemeColor().withOpacity(0.5); // 淡红色
                        }
                        return ThemeManager.getInstance().getDefautThemeColor(); // 红色
                      },
                    ),
                  ),
                  child: Text(getI18NKey().save, style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
        list.add(int.parse((elem?.code ?? "1")));
      }
    });
    return list;
  }

  // 构建 tab
  Widget _buildTab(String label, bool selected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton(
        onPressed: () {},
        child: Text(
          label,
          style: TextStyle(color: selected ? Colors.pink : Colors.black),
        ),
      ),
    );
  }

  // 保存过滤器的逻辑
  void onclickSaveFilter() {
    // 保存过滤器的代码处理
    this.widget.folderModel?.filterType = 1;
    this.widget.folderModel?.tag = 4;
    this.widget.folderModel?.filterConditionMapBean = this.filterConditionBean;
    if(this.widget.folderModel?.objectId == null) {
      MongoApisManager.getInstance().insertFolderModel(folderModel: this.widget.folderModel!);
    } else {
      MongoApisManager.getInstance().update_FolderModelWithFM(folderModel: this.widget.folderModel!);
    }
    // print('过滤器已保存: $_filterName');
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
              (start_time == null || start_time == 0) ? getI18NKey().now :CONSTANTS
                  .getAlertDateString(Utility.getDateTimeModelFromTimeStamp(this.start_time ?? 0)),
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
        DateTimeModel? model =
        await Utility.showDateTimePickerDialog(context);
        // updateAlertTime();
        this.setState(() {
          this.start_time =
              model?.datetime?.millisecondsSinceEpoch ?? 0; //计划到期日
          this.filterConditionBean?.startTime = this.end_time;
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
              (end_time == null || end_time == 0) ? getI18NKey().now : CONSTANTS
                  .getAlertDateString(Utility.getDateTimeModelFromTimeStamp(this.end_time ?? 0)),
              style: TextStyle(
                  color: ThemeManager.getInstance()
                      .getTextColor(defaultColor: Colors.black87),
                  fontSize: 12)),
          CustomCloseButton(
            margin: EdgeInsets.only(left: 5),
            onTapListener: () {
              this.end_time =
                  0; //计划到期日
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
        DateTimeModel? model =
        await Utility.showDateTimePickerDialog(context);
        // updateAlertTime();
        this.setState(() {
          this.end_time =
              model?.datetime?.millisecondsSinceEpoch ?? 0; //计划到期日
          this.filterConditionBean?.endTime = this.end_time;

        });
        setState(() {});
      },
    );
  }
  String getUnitBefore() {
    switch(_selectedTimeUnit) {
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
    switch(_selectedTimeUnit) {
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

class _SectionTitleWidget extends StatelessWidget {
  Widget child;
  String title;

  _SectionTitleWidget({required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 100,
            child: Text(
              title,
              style: TextStyle(fontSize: 15),
            ),
          ),
          SizedBox(
            width: 30,
          ),
          Expanded(child: child)
        ],
      ),
    );
  }
}
