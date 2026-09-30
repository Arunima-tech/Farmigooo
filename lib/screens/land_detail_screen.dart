import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/land_model.dart';
import '../services/land_service.dart';
import '../theme/app_theme.dart';

class LandDetailScreen extends StatefulWidget {
  final LandModel land;
  const LandDetailScreen({super.key, required this.land});

  @override
  State<LandDetailScreen> createState() => _LandDetailScreenState();
}

class _LandDetailScreenState extends State<LandDetailScreen> {
  bool _sending = false;
  bool _requested = false;

  final String demoFarmerId = 'demo_farmer_456';

  void _sendRequest() {
    setState(() => _sending = true);
    LandService.sendRequest(widget.land.id, demoFarmerId);
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      setState(() {
        _sending = false;
        _requested = true;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Request sent to the landowner!')));
    });
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.mossGreen),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: AppColors.soilTextMuted)),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.soilText),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final land = widget.land;

    return Scaffold(
      backgroundColor: AppColors.linen,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: AppColors.mossGreen,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: land.photoBase64 != null
                  ? Image.memory(base64Decode(land.photoBase64!), fit: BoxFit.cover)
                  : Container(
                      color: AppColors.mossGreen.withValues(alpha: 0.85),
                      child: const Center(
                        child: Icon(Icons.landscape_outlined, size: 72, color: Colors.white70),
                      ),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${land.area} acres in ${land.location}',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 6),
                  Text(
                    '₹${land.price.toStringAsFixed(0)} / year',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.harvestGold,
                        ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.cardSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.mossGreen.withValues(alpha: 0.08)),
                    ),
                    child: Column(
                      children: [
                        _infoRow(Icons.grass, 'Soil type', land.soilType),
                        const Divider(height: 1),
                        _infoRow(Icons.eco_outlined, 'Suitable crops', land.crops),
                        const Divider(height: 1),
                        _infoRow(Icons.place_outlined, 'Location', land.location),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        decoration: BoxDecoration(
          color: AppColors.linen,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, -4))],
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (_sending || _requested) ? null : _sendRequest,
            style: ElevatedButton.styleFrom(
              backgroundColor: _requested ? AppColors.mossGreen.withValues(alpha: 0.4) : AppColors.mossGreen,
            ),
            child: _sending
                ? const SizedBox(
                    height: 20, width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Text(_requested ? 'Request Sent' : 'Send Request'),
          ),
        ),
      ),
    );
  }
}
