import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mubit/core/providers/date_provider.dart';
import 'package:mubit/core/theme/app_theme.dart';

class DateSlider extends ConsumerStatefulWidget {
  const DateSlider({super.key});

  @override
  ConsumerState<DateSlider> createState() => _DateSliderState();
}

class _DateSliderState extends ConsumerState<DateSlider> {
  late ScrollController _scrollController;
  final double itemWidth = 72.0; // 60 width + 12 margin
  String _currentMonth = '';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    
    // Auto-scroll to "Today" (index 20) after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToToday();
      _updateMonthLabel();
    });
  }

  void _onScroll() {
    _updateMonthLabel();
  }

  void _updateMonthLabel() {
    if (!_scrollController.hasClients) return;
    
    final today = DateTime.now();
    final startDate = today.subtract(const Duration(days: 20));
    
    // Determine the date at the center of the viewport
    final centerOffset = _scrollController.offset + (MediaQuery.of(context).size.width / 2);
    final centerIndex = (centerOffset / itemWidth).floor();
    
    // Clamp index to valid bounds
    final clampedIndex = centerIndex.clamp(0, 40);
    final date = startDate.add(Duration(days: clampedIndex));
    final monthStr = DateFormat('MMMM yyyy').format(date);
    
    if (_currentMonth != monthStr) {
      setState(() {
        _currentMonth = monthStr;
      });
    }
  }

  void _scrollToToday() {
    if (_scrollController.hasClients) {
      // Index 20 is today (starts from -20 days)
      final screenWidth = MediaQuery.of(context).size.width;
      final offset = (20 * itemWidth) - (screenWidth / 2) + (itemWidth / 2);
      
      _scrollController.animateTo(
        offset,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);
    final today = DateTime.now();

    // Create a list of 41 days (20 before today, today, 20 after today)
    final startDate = today.subtract(const Duration(days: 20));
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Centered
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.primaryGreen.withValues(alpha: 0.05),
                  ),
                ),
                child: Text(
                  _currentMonth,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryGreen,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 90,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: 41, // 20 + 1 + 20
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              final date = startDate.add(Duration(days: index));
              final isSelected = DateUtils.isSameDay(date, selectedDate);
              final isToday = DateUtils.isSameDay(date, today);

              return GestureDetector(
                onTap: () => ref.read(selectedDateProvider.notifier).state = date,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 60,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryGreen : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: isSelected 
                      ? null 
                      : Border.all(color: Colors.grey.withValues(alpha: 0.1)),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppTheme.primaryGreen.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('E').format(date).toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white70 : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        date.day.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                      if (isToday)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : AppTheme.primaryGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
