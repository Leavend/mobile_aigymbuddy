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
    const centerGap = fabDiameter + 16; // FAB + margin kecil

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
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // CLUSTER KIRI (2 tab)
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

                    // GAP TETAP untuk FAB (tanpa Spacer biar jarak tidak melebar)
                    const SizedBox(width: centerGap),

                    // CLUSTER KANAN (2 tab)
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
