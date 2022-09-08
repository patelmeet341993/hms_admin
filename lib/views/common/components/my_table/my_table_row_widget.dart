import 'package:flutter/material.dart';

import 'my_table_cell_model.dart';

class MyTableRowWidget extends StatelessWidget {
  final List<MyTableCellModel> cells;
  final double borderRadius;
  final Color? backgroundColor;
  final EdgeInsets? margin, padding;

  const MyTableRowWidget({
    Key? key,
    required this.cells,
    this.borderRadius = 6,
    this.backgroundColor,
    this.margin,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    if(cells.isEmpty) {
      return const SizedBox();
    }
    return Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: backgroundColor ?? themeData.cardColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        children: cells.map((e) => Expanded(flex: e.flex, child: e.child,)).toList(),
        /*children: [
          Expanded(
            flex: flexes[0],
            child: getTableColumnTitleWidget(values[0]),
          ),
          Expanded(
            flex: flexes[1],
            child: getTableColumnTitleWidget(values[1]),
          ),
          Expanded(
            flex: flexes[2],
            child: getTableColumnTitleWidget(values[2]),
          ),
          Expanded(
            flex: flexes[3],
            child: getTableColumnTitleWidget(values[3]),
          ),
        ],*/
      ),
    );
  }
}
