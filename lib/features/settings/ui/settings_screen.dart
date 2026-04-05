import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mubit/core/providers/settings_provider.dart';
import 'package:mubit/core/services/shared_prefs_service.dart';

import 'package:mubit/core/theme/app_theme.dart';
import 'package:mubit/core/services/notification_service.dart';
import 'package:mubit/features/prayer_times/services/prayer_time_service.dart';
import 'package:mubit/features/settings/ui/about_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final List<String> _calculationMethods = [
    'Kemenag',
    'MWL',
    'ISNA',
    'Umm Al-Qura',
  ];

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(sharedPrefsServiceProvider);
    final settings = ref.watch(prayerSettingsProvider);
    final prayerService = ref.watch(prayerTimeServiceProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundWhite,
        elevation: 0,
        title: Text(
          'Pengaturan',
          style: GoogleFonts.philosopher(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryGreen,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingsHeader('Umum'),
          
          const SizedBox(height: 16),
          _buildSettingsHeader('Habit & Target'),
          SwitchListTile(
            title: const Text('Sertakan Puasa dalam Target'),
            subtitle: const Text('Puasa wajib dicentang untuk mencapai habit 100%'),
            activeThumbColor: AppTheme.primaryGreen,
            value: prefs.includePuasaInTarget,
            onChanged: (val) async {
              await prefs.saveIncludePuasa(val);
              ref.invalidate(sharedPrefsServiceProvider);
            },
          ),
          
          const Divider(height: 32),
          _buildSettingsHeader('Metode Perhitungan'),
          Card(
            elevation: 0,
            color: Colors.grey.withValues(alpha: 0.05),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: settings.calculationMethod,
                  isExpanded: true,
                  items: _calculationMethods.map((m) {
                    return DropdownMenuItem(value: m, child: Text(m));
                  }).toList(),
                  onChanged: (val) async {
                    if (val != null) {
                      await ref.read(prayerSettingsProvider.notifier).updateCalculationMethod(val);
                      _reschedule(prayerService, prefs);
                    }
                  },
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          _buildSettingsHeader('Penyesuaian Hijriah'),
          const Text(
            'Sesuaikan tanggal Hijriah jika tidak sinkron dengan kalender lokal.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _OffsetButton(label: '-1', isSelected: true, onTap: () {}),
              const SizedBox(width: 8),
              _OffsetButton(label: '0', isSelected: false, onTap: () {}),
              const SizedBox(width: 8),
              _OffsetButton(label: '+1', onTap: () {}),
            ],
          ),
          
          const Divider(height: 48),
          _buildNavigationTile(
            context,
            'Tentang Mubit',
            'Versi, lisensi, dan kebijakan privasi',
            Icons.info_outline_rounded,
            const AboutScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildNavigationTile(BuildContext context, String title, String subtitle, IconData icon, Widget target) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryGreen.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppTheme.primaryGreen, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => target)),
    );
  }

  void _reschedule(PrayerTimeService prayerService, SharedPrefsService prefs) {
    NotificationService().schedulePrayerNotifications(
      prayerService: prayerService,
      prefs: prefs,
    );
  }
}

class _OffsetButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _OffsetButton({
    required this.label,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryGreen : Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
