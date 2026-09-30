import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/machinery_model.dart';
import '../services/machinery_service.dart';
import '../theme/app_theme.dart';

class MachineryDetailScreen extends StatefulWidget {
  final MachineryModel item;
  const MachineryDetailScreen({super.key, required this.item});

  @override
  State<MachineryDetailScreen> createState() => _MachineryDetailScreenState();
}

class _MachineryDetailScreenState extends State<MachineryDetailScreen> {
  bool _sending = false;
  bool _requested = false;

  final String demoFarmerId = 'demo_farmer_456';

  void _sendRequest() {
    setState(() => _sending = true);
    MachineryService.sendRequest(widget.item.id, demoFarmerId);
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      setState(() {
        _sending = false;
        _requested = true;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Request sent to the owner!')));
    });
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.machineryAccent),
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
    final item = widget.item;

    return Scaffold(
      backgroundColor: AppColors.linen,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: AppColors.machineryAccent,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: item.photoBase64 != null
                  ? Image.memory(base64Decode(item.photoBase64!), fit: BoxFit.cover)
                  : Container(
                      color: AppColors.machineryAccent.withValues(alpha: 0.85),
                      child: const Center(
                        child: Icon(Icons.agriculture_outlined, size: 72, color: Colors.white70),
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
                  Text(item.type, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 6),
                  Text(
                    '₹${item.dailyRate.toStringAsFixed(0)} / day',
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
                      border: Border.all(color: AppColors.machineryAccent.withValues(alpha: 0.08)),
                    ),
                    child: Column(
                      children: [
                        _infoRow(Icons.place_outlined, 'Location', item.location),
                        const Divider(height: 1),
                        _infoRow(Icons.check_circle_outline, 'Status', 'Available now'),
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
              backgroundColor: _requested
                  ? AppColors.machineryAccent.withValues(alpha: 0.4)
                  : AppColors.machineryAccent,
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
