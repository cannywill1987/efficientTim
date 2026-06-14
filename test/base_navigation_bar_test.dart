import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';

void main() {
  testWidgets(
      'BaseMobileNavigationConfig keeps title left aligned with small logo',
      (WidgetTester tester) async {
    late AppBar appBar;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            appBar = BaseMobileNavigationConfig(
              logo: const Icon(Icons.alarm),
              title: '时间管理局 ToDo',
              subtitle: '专注时间 | 高效生活',
            ).buildAppBar(
              context,
              defaultLeading: const SizedBox.shrink(),
              defaultActions: const <Widget>[SizedBox.shrink()],
            );
            return Scaffold(appBar: appBar, body: const SizedBox.shrink());
          },
        ),
      ),
    );

    expect(appBar.centerTitle, isFalse);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BaseMobileNavigationTitle(
            logo: Icon(Icons.alarm),
            title: '时间管理局 ToDo',
            subtitle: '专注时间 | 高效生活',
          ),
        ),
      ),
    );

    expect(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget is SizedBox && widget.width == 34 && widget.height == 34,
      ),
      findsOneWidget,
    );
  });

  testWidgets(
      'BaseFloatingNavigationBar renders selected item and handles taps',
      (WidgetTester tester) async {
    final List<int> tappedIndexes = <int>[];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: BaseFloatingNavigationBar(
            currentIndex: 1,
            onTap: tappedIndexes.add,
            items: const <BaseFloatingNavigationItem>[
              BaseFloatingNavigationItem(
                icon: Icon(Icons.alarm_outlined),
                activeIcon: Icon(Icons.alarm),
                label: '番茄钟',
              ),
              BaseFloatingNavigationItem(
                icon: Icon(Icons.pie_chart_outline),
                activeIcon: Icon(Icons.pie_chart),
                label: '实时数据',
              ),
              BaseFloatingNavigationItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: '我的',
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.byKey(const ValueKey<String>('base_floating_nav_selected_1')),
        findsOneWidget);

    await tester.tap(find.text('我的'));
    await tester.pump();

    expect(tappedIndexes, <int>[2]);
  });
}
