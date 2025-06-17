import 'package:flutter/material.dart';
import 'package:hrms_app/core/constants/app_colors.dart';

class SponsorDetailsScreen extends StatelessWidget {
  final String sponsorName;
  final String sponsorId;
  final String industry;
  final String contactPerson;
  final String email;
  final String phone;
  final String address;
  final String logoUrl;

  const SponsorDetailsScreen({
    super.key,
    required this.sponsorName,
    required this.sponsorId,
    required this.industry,
    required this.contactPerson,
    required this.email,
    required this.phone,
    required this.address,
    required this.logoUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.brandColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(sponsorName, style: const TextStyle(fontSize: 18)),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF003973), Color(0xFFE5E5BE)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(logoUrl),
                    onBackgroundImageError: (_, __) =>
                    const Icon(Icons.business, size: 45, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Sponsor Info"),
                  _infoCard([
                    _infoRow("Sponsor ID", sponsorId),
                    _infoRow("Industry", industry),
                    _infoRow("Contact Person", contactPerson),
                  ]),
                  const SizedBox(height: 24),
                  _sectionTitle("Contact Details"),
                  _infoCard([
                    _infoRow("Email", email),
                    _infoRow("Phone", phone),
                    _infoRow("Address", address),
                  ]),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.brandColor,
        ),
      ),
    );
  }

  Widget _infoCard(List<Widget> children) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          )
        ],
      ),
    );
  }
}
