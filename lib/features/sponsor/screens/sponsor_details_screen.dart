import 'package:flutter/material.dart';
import 'package:hrms_app/core/constants/app_colors.dart';
import 'package:hrms_app/core/services/sponsor_service.dart';
import 'package:hrms_app/features/settings/providers/theme_provider.dart';
import 'package:hrms_app/features/sponsor/model/sponsor_model.dart';
import 'package:hrms_app/features/auth/controllers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmployeeSponsorViewScreen extends ConsumerStatefulWidget {
  const EmployeeSponsorViewScreen({super.key});

  @override
  ConsumerState<EmployeeSponsorViewScreen> createState() =>
      _EmployeeSponsorViewScreenState();
}

class _EmployeeSponsorViewScreenState
    extends ConsumerState<EmployeeSponsorViewScreen> {
  SponsorModel? sponsor;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadSponsorInfo();
  }

  Future<void> _loadSponsorInfo() async {
    final user = ref.read(loggedInUserProvider);
    if (user == null) return;

    try {
      final data = await SponsorService().fetchSponsor(user.email);
      setState(() {
        sponsor = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.read(themeModeProvider.notifier).state;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Sponsor Info'),
        backgroundColor: AppColors.brandColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text('Something Went Wrong!'))
          : sponsor == null
          ? const Center(child: Text('No sponsor data found.'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(sponsor!,themeMode),
            const SizedBox(height: 20),
            _buildDetailTile('Sponsor Name', sponsor!.name,themeMode),
            _buildDetailTile('Industry', sponsor!.industry,themeMode),
            _buildDetailTile('Contact Person', sponsor!.contactPerson,themeMode),
            // _buildDetailTile('Email', sponsor!.email),
            _buildDetailTile('Phone', sponsor!.phone,themeMode),
            _buildDetailTile('Address', sponsor!.address,themeMode),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(SponsorModel sponsor, themeMode) {
    return Column(
      children: [
        // if (sponsor.logoUrl != null && sponsor.logoUrl!.isNotEmpty)
        //   ClipRRect(
        //     borderRadius: BorderRadius.circular(12),
        //     child: Image.network(
        //       sponsor.logoUrl!,
        //       height: 80,
        //       width: 80,
        //       fit: BoxFit.cover,
        //     ),
        //   ),
        const SizedBox(height: 12),
        Text(
          'Sponsor Details',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: themeMode==ThemeMode.dark?Colors.white:AppColors.brandColor,),
        ),
      ],
    );
  }

  Widget _buildDetailTile(String label, String? value,themeMode) {
    return Card(
      color: themeMode==ThemeMode.dark?Colors.white12:AppColors.white,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.info_outline, color: themeMode==ThemeMode.dark?Colors.white12:AppColors.brandColor,),
        title: Text(label),
        subtitle: Text(value ?? 'N/A'),
      ),
    );
  }
}
