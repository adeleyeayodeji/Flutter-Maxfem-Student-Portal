import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:profile_app_ui/constants.dart';
import '../Service/api.dart';
// ignore: unused_import
import 'package:profile_app_ui/widgets/profile_list_item.dart';

class CheckResult extends StatelessWidget {
  final userData;
  final result;

  CheckResult(this.userData, this.result);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: 896, width: 414, allowFontScaling: true);
    var profileInfo = Expanded(
      child: Column(
        children: <Widget>[
          Container(
            height: kSpacingUnit.w * 5,
            width: kSpacingUnit.w * 5,
            margin: EdgeInsets.only(top: 2),
            child: Stack(
              children: <Widget>[
                CircleAvatar(
                  radius: kSpacingUnit.w * 5,
                  backgroundImage:
                      NetworkImage(imageURL + this.userData["logo"]),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    var themeSwitcher = ThemeSwitcher(
      builder: (context) {
        return AnimatedCrossFade(
          duration: Duration(milliseconds: 200),
          crossFadeState:
              ThemeProvider.of(context).brightness == Brightness.dark
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
          firstChild: GestureDetector(
            onTap: () =>
                ThemeSwitcher.of(context).changeTheme(theme: kLightTheme),
            child: Icon(
              LineAwesomeIcons.sun,
              size: ScreenUtil().setSp(kSpacingUnit.w * 3),
            ),
          ),
          secondChild: GestureDetector(
            onTap: () =>
                ThemeSwitcher.of(context).changeTheme(theme: kDarkTheme),
            child: Icon(
              LineAwesomeIcons.moon,
              size: ScreenUtil().setSp(kSpacingUnit.w * 3),
            ),
          ),
        );
      },
    );

    var header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: kSpacingUnit.w * 3),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            size: ScreenUtil().setSp(kSpacingUnit.w * 3),
          ),
        ),
        profileInfo,
        themeSwitcher,
        SizedBox(width: kSpacingUnit.w * 3),
      ],
    );

    var reload = () async {
     var update = await getResult(userData["RollId"], userData["ClassId"], userData["StudentId"]);
      //Make a little delay
      Future.delayed(Duration(seconds: 1), () async {
        await setUserData("userresult", update);
      });
    };
    //Reload result 
    reload();
    //Return view
    return ThemeSwitchingArea(
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: Column(
              children: <Widget>[
                SizedBox(height: kSpacingUnit.w * 5),
                header,
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      PaginatedDataTable(
                        header: Text('All Results',
                            style: new TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                        rowsPerPage: this.result["info"].length,
                        columns: [
                          DataColumn(label: Text('Max Obt.')),
                          DataColumn(label: Text('40%')),
                          DataColumn(label: Text('60%')),
                          DataColumn(label: Text('100%')),
                        ],
                        source: _DataSource(context, this.result),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Row {
  //Constructor
  _Row(
    this.valueA,
    this.valueB,
    this.valueC,
    this.valueD,
  );

  final String valueA;
  final String valueB;
  final String valueC;
  final String valueD;

  bool selected = false;
}

class _DataSource extends DataTableSource {
  _DataSource(this.context, result) {
    _rows = <_Row>[
      for (var i = 0; i < result["info"].length; i++)
        _Row(result["info"][i]["SubjectName"], result["info"][i]["tmarks"], result["info"][i]["marks"], '${int.tryParse(result["info"][i]["tmarks"])+int.tryParse(result["info"][i]["marks"])}'),
    ];
  }

  final BuildContext context;
  List<_Row> _rows;

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _rows.length) return null;
    final row = _rows[index];
    return DataRow.byIndex(
      index: index,
      // selected: row.selected,
      // onSelectChanged: (value) {
      //   if (row.selected != value) {
      //     _selectedCount += value ? 1 : -1;
      //     assert(_selectedCount >= 0);
      //     row.selected = value;
      //     notifyListeners();
      //   }
      // },
      cells: [
        DataCell(Text(row.valueA)),
        DataCell(Text(row.valueB)),
        DataCell(Text(row.valueC)),
        DataCell(Text(row.valueD.toString())),
      ],
    );
  }

  @override
  int get rowCount => _rows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}
