// lib/view/main_tab/main_tab_view.dart

import 'dart:ui';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common_widget/tab_button.dart';
import 'package:aigymbuddy/view/main_tab/select_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../home/home_view.dart';
import '../photo_progress/photo_progress_view.dart';
import '../profile/profile_view.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int _selected = 0;

  late final List<Widget> _tabs = const [
    HomeView(),
    SelectView(),
    PhotoProgressView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.of(context).padding;
    final bottomInset = pad.bottom;

    // ukuran FAB & gap tengah agar jarak tab konsisten
    const fabDiameter = 64.0;
    const centerGap = fabDiameter + 20; // FAB + margin kecil
    const tabSpacing = 32.0;

    return Scaffold(
      backgroundColor: TColor.white,

      // Simpan state per tab
      body: IndexedStack(index: _selected, children: _tabs),

      // FAB tengah: bulat, gradient, shadow
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: fabDiameter,
        height: fabDiameter,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(fabDiameter / 2),
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: TColor.primaryG),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              // ikon cupertino berkesan AI/assistant
              child: const Icon(
                CupertinoIcons.chat_bubble_text_fill,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        ),
      ),

      // Bottom bar: pill + blur + dua cluster tab dengan gap tetap di tengah
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            0,
            16,
            bottomInset > 0 ? bottomInset : 12,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: _TabCluster(
                          spacing: tabSpacing,
                          children: [
                            TabButton(
                              icon: "assets/img/home_tab.png",
                              selectIcon: "assets/img/home_tab_select.png",
                              isActive: _selected == 0,
                              onTap: () => setState(() => _selected = 0),
                            ),
                            TabButton(
                              icon: "assets/img/activity_tab.png",
                              selectIcon: "assets/img/activity_tab_select.png",
                              isActive: _selected == 1,
                              onTap: () => setState(() => _selected = 1),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: centerGap),

                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: _TabCluster(
                          spacing: tabSpacing,
                          children: [
                            TabButton(
                              icon: "assets/img/camera_tab.png",
                              selectIcon: "assets/img/camera_tab_select.png",
                              isActive: _selected == 2,
                              onTap: () => setState(() => _selected = 2),
                            ),
                            TabButton(
                              icon: "assets/img/profile_tab.png",
                              selectIcon: "assets/img/profile_tab_select.png",
                              isActive: _selected == 3,
                              onTap: () => setState(() => _selected = 3),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabCluster extends StatelessWidget {
  const _TabCluster({
    required this.children,
    required this.spacing,
  });

  final List<Widget> children;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(width: spacing),
          children[i],
        ],
      ],
    );
  }
}
