import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SeparateTabBar extends StatelessWidget {
  final List<String> tabs;
  final TabController tabController;

  SeparateTabBar({required this.tabs, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.black.withOpacity(0.1),
      //       blurRadius: 4.0,
      //       offset: Offset(0, 2),
      //     ),
      //   ],
      // ),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          int tabIndex = entry.key;
          String tabText = entry.value;
          bool isSelected = tabIndex == tabController.index;
          return Expanded(
            child: InkWell(
              onTap: () {
                tabController.animateTo(tabIndex);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.sp),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected ? Colors.red : Colors.transparent,
                      width: 2.sp,
                    ),
                  ),
                ),
                child: Text(
                  tabText,
                  style: TextStyle(
                    color: isSelected ? Colors.red : Colors.black,
                    // fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}