import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mubit/core/providers/date_provider.dart';
import 'package:mubit/core/services/location_service.dart';
import 'package:mubit/core/services/shared_prefs_service.dart';
import 'package:mubit/core/theme/app_theme.dart';

import 'package:mubit/features/habit_tracker/ui/widgets/app_drawer.dart';
import 'package:mubit/features/habit_tracker/ui/widgets/dashboard_header.dart';
import 'package:mubit/features/habit_tracker/ui/widgets/date_slider.dart';
import 'package:mubit/features/habit_tracker/ui/widgets/habit_list_view.dart';
import 'package:mubit/features/prayer_times/providers/prayer_provider.dart';
import 'package:mubit/features/settings/ui/notifications_screen.dart';


class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLocating = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _updateLocation() async {
    // Show Options Dialog
    final option = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Lokasi', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('Pilih metode pencarian lokasi:'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'manual'),
              child: const Text('Cari Manual'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, 'gps'),
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryGreen),
              child: const Text('Gunakan GPS', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (option == 'gps') {
      await _fetchGpsLocation();
    } else if (option == 'manual') {
      await _showManualLocationDialog();
    }
  }

  Future<void> _showManualLocationDialog() async {
    final controller = TextEditingController();
    final cityName = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cari Kota', style: TextStyle(fontWeight: FontWeight.bold)),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Masukkan nama kota (misal: Jakarta)',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: (value) => Navigator.pop(context, value),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text),
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryGreen),
              child: const Text('Cari', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (cityName != null && cityName.trim().isNotEmpty) {
      setState(() => _isLocating = true);
      try {
        await ref.read(locationServiceProvider).saveManualLocation(cityName.trim());
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lokasi berhasil diatur ke $cityName')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal mencari lokasi: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _isLocating = false);
      }
    }
  }

  Future<void> _fetchGpsLocation() async {
    setState(() => _isLocating = true);
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Izin Lokasi Ditolak Permanen. Buka Pengaturan untuk menyalakannya.'),
              action: SnackBarAction(
                label: 'Pengaturan',
                onPressed: () => Geolocator.openAppSettings(),
              ),
            ),
          );
        }
        return;
      }

      await ref.read(locationServiceProvider).determineAndSaveLocation();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lokasi berhasil diperbarui dengan GPS')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil lokasi: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cityName = ref.watch(sharedPrefsServiceProvider).cityName ?? 'Lokasi Belum Set';
    final displayCityName = _isLocating ? 'Mencari Lokasi...' : cityName;
    final selectedDate = ref.watch(selectedDateProvider);
    final prayerTimesAsync = ref.watch(dailyPrayerTimesProvider);
    
    // Show progress if locatng OR if prayer times are being recalculated
    final showProgress = _isLocating || prayerTimesAsync.isLoading;

    return Scaffold(
      drawer: const AppDrawer(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 75,
              toolbarHeight: 75,
              floating: true,
              pinned: true,
              backgroundColor: AppTheme.backgroundWhite,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: Center(
                child: IconButton(
                  icon: const Icon(Icons.menu_rounded),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              title: InkWell(
                onTap: _isLocating ? null : _updateLocation,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Larger hitbox
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            AppTheme.primaryGreen,
                            AppTheme.primaryGreen.withValues(alpha: 0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: Text(
                          'Mubit',
                          style: GoogleFonts.philosopher(
                            fontWeight: FontWeight.bold,
                            fontSize: 20, // Slightly larger
                            color: Colors.white, // Required for ShaderMask
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isLocating ? Icons.hourglass_top_rounded : Icons.location_on_outlined, 
                            size: 14, // Enlarged
                            color: AppTheme.primaryGreen
                          ),
                          const SizedBox(width: 4),
                          Text(
                            displayCityName, 
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 12, // Enlarged
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                        );
                      },
                      icon: const Icon(Icons.notifications_none_rounded, size: 24),
                    ),
                  ),
                ),
              ],
            ),
            if (showProgress)
              const SliverToBoxAdapter(
                child: LinearProgressIndicator(
                  minHeight: 2,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGreen),
                ),
              ),
            SliverToBoxAdapter(
              child: Transform.translate(
                offset: const Offset(0, -8), // Adjusted for taller AppBar
                child: Column(
                  children: [
                    const DashboardHeader(),
                    const DateSlider(),
                  const SizedBox(height: 8), // Snug spacing
                  TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.label,
                    dividerColor: Colors.transparent,
                    indicatorColor: AppTheme.primaryGreen,
                    labelColor: AppTheme.primaryGreen,
                    unselectedLabelColor: Colors.grey,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    tabs: const [
                      Tab(text: 'Shalat'),
                      Tab(text: 'Puasa'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ];
      },
        body: TabBarView(
          controller: _tabController,
          children: [
            HabitListView(
              date: selectedDate, 
              category: 'Shalat',
              onSetLocation: _updateLocation,
            ),
            HabitListView(
              date: selectedDate, 
              category: 'Puasa',
            ),
          ],
        ),
      ),
    );
  }
}
