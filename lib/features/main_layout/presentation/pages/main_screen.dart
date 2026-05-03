import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_buddy/core/constants/app_colors.dart';
import 'package:study_buddy/features/history/presentation/pages/history_screen.dart';
import 'package:study_buddy/features/home/presentation/pages/home_screen.dart';
import 'package:study_buddy/features/upload/presentation/pages/upload_screen.dart';
import '../../../profile/presentation/pages/profile_screen.dart';
import '../../../history/presentation/manager/history_bloc.dart';
import '../../../history/presentation/manager/history_event.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _changeTab(int index) {
    if (index == 0 || index == 2) {
      context.read<HistoryBloc>().add(LoadHistory());
    }
    setState(() {
      _currentIndex = index;
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
    final List<Widget> screens = [
      HomeScreen(
        onNavigateToUpload: () => _changeTab(1),
        onNavigateToHistory: () => _changeTab(2),
      ),
      UploadScreen(),
      HistoryScreen(),
      const ProfileScreen(),

    ];
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFF23303F), width: 1)),
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
              _buildNavItem(Icons.home_rounded, 'Home', 0),
              _buildNavItem(Icons.file_upload_outlined, 'Upload', 1),
              _buildNavItem(Icons.history_rounded, 'History', 2),
              _buildNavItem(Icons.person_outline_rounded, 'Profile', 3),
            ],
          ),
        ),
      ),
    );
  }
}
