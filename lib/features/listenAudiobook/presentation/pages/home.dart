import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/constants/constants.dart';
import 'widgets/widgets.dart';

AppSize _appSize = AppSize();

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backGroundColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: _appSize.heightApp(context),
          width: _appSize.widthApp(context),
          child: Column(
            children: [
              Container(
                height: 60,
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: _appSize.widthApp(context),
                decoration: BoxDecoration(
                  color: contentColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(20),
                    hintText: 'Rechercher l\'article...',
                    hintStyle: TextStyle(
                      color: textColor,
                    ),
                    prefixIcon: Icon(
                      LucideIcons.search,
                      color: textColor,
                    ),
                  ),
                ),
              ),
              Container(
                height: _appSize.heightApp(context) * .8,
                width: _appSize.widthApp(context),
                padding: const EdgeInsets.only(bottom: 20),
                child: ListView.builder(
                  itemCount: 6,
                  itemBuilder: (BuildContext context, index) {
                    return const ChapterWidget();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
