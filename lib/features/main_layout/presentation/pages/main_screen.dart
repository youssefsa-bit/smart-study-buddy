import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_buddy/core/constants/app_colors.dart';
import 'package:study_buddy/core/manager/theme_cubit.dart';
import 'package:study_buddy/features/history/presentation/pages/history_screen.dart';
import 'package:study_buddy/features/home/presentation/pages/home_screen.dart';
import 'package:study_buddy/features/upload/domain/entities/upload_action.dart';
import 'package:study_buddy/features/upload/presentation/pages/upload_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../history/presentation/manager/history_bloc.dart';
import '../../../history/presentation/manager/history_event.dart';
import '../../../profile/presentation/pages/profile_screen.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;
  UploadAction? _action;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _changeTab(int index, {UploadAction? uploadAction}) {
    if (index == _currentIndex) return;
    if (index == 0 || index == 2) {
      context.read<HistoryBloc>().add(LoadHistory());
    }
    setState(() {
      _currentIndex = index;
      _action = uploadAction;
    });
    _pageController.jumpToPage(index);
  }

  void _onPageChanged(int index) {
    if (index == 0 || index == 2) {
      context.read<HistoryBloc>().add(LoadHistory());
    }
    setState(() {
      _currentIndex = index;
      if (index != 1) {
        _action = null;
      }
    });
  }

  BottomNavigationBarItem _buildNavItem(
      IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.only(bottom: isSelected ? 8 : 4),
        child: Icon(
          icon,
          size: isSelected ? 28 : 24,
        ),
      ),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final List<Widget> screens = [
      HomeScreen(
        onNavigateToUpload: (({action}) => _changeTab(1, uploadAction: action)),
        onNavigateToHistory: () => _changeTab(2),
      ),
      UploadScreen(
        action: _action,
      ),
      HistoryScreen(),
      ProfileScreen(),
    ];
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) return;
        SystemNavigator.pop();
      },
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              physics: const BouncingScrollPhysics(),
              children:screens.map((screen) => KeepAlivePage(child: screen)).toList(),
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                border:
                    Border(top: BorderSide(color: AppColors.border, width: 1)),
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: BottomNavigationBar(
                  currentIndex: _currentIndex,
                  onTap: _changeTab,
                  backgroundColor: AppColors.surface,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: AppColors.primaryBlue,
                  unselectedItemColor: Colors.grey,
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  selectedFontSize: 12,
                  unselectedFontSize: 12,
                  elevation: 0,
                  items: [
                    _buildNavItem(Icons.home_rounded, loc.navHome, 0),
                    _buildNavItem(Icons.file_upload_outlined, loc.navUpload, 1),
                    _buildNavItem(Icons.history_rounded, loc.navHistory, 2),
                    _buildNavItem(
                        Icons.person_outline_rounded, loc.navProfile, 3),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
class KeepAlivePage extends StatefulWidget {
  final Widget child;
  const KeepAlivePage({super.key, required this.child});

  @override
  State<KeepAlivePage> createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<KeepAlivePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
