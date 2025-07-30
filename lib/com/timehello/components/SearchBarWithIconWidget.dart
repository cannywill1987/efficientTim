import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../util/Utility.dart';
import 'SearchBarWidget.dart';

class SearchBarWithIconWidget extends StatefulWidget {
  final Function(String) onChange;
  final Function(bool) onClickSearchListener;
  bool shouldShowSearchBar = true;
  SearchBarWithIconWidget({Key? key,this.shouldShowSearchBar = true, required this.onClickSearchListener, required this.onChange}): super(key: key);

  @override
  _SearchBarWithIconWidgetState createState() =>
      _SearchBarWithIconWidgetState();
}

class _SearchBarWithIconWidgetState extends State<SearchBarWithIconWidget> {
  bool _isFocused = false;
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if(Utility.isHandsetBySize() == false && this.widget.shouldShowSearchBar) {
      if (!_isFocused) {
        return getSearchIcon();
      } else {
        return getSearchbar();

        return Expanded(
          child: TextField(
            controller: _controller,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: '请输入您想要查找的任务',
            ),
            onChanged: widget.onChange,
            onEditingComplete: unfocus,
          ),
        );
      }
    } else {
      return getSearchIcon();
    }

  }

  SearchBarWidget getSearchbar() {
    return SearchBarWidget(width: 250, onClickResetListener: () {
      setState(() {
        _isFocused = !_isFocused;
        this.widget.onClickSearchListener(_isFocused);
      });
    }, onChangeListener: (val) {
      this.widget.onChange(val);
    });
  }

  Container getSearchIcon() {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        // color: Colors.orange,
        borderRadius: BorderRadius.circular(20),
      ),
      child: IconButton(
        icon: Icon(Icons.search, size: 22, color: ThemeManager.getInstance().getIconColor(defaultColor: Colors.black,)),
        onPressed: () {
          setState(() {
            _isFocused = !_isFocused;
            this.widget.onClickSearchListener(_isFocused);
          });
        }
      ),
    );
  }

  void unfocus() {
    setState(() {
      _isFocused = false;
      _controller.clear();
    });
  }
}
