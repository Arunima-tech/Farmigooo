import 'dart:convert';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ListingCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;
  final String? photoBase64;

  const ListingCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.onTap,
    this.icon = Icons.landscape_outlined,
    this.accentColor = AppColors.mossGreen,
    this.photoBase64,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              if (photoBase64 != null && photoBase64!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    base64Decode(photoBase64!),
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: accentColor, size: 24),
                ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                price,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: accentColor,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
