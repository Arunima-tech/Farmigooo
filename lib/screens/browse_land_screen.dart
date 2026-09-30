import 'package:flutter/material.dart';
import '../services/land_service.dart';
import '../widgets/listing_card.dart';
import '../theme/app_theme.dart';
import 'add_land_screen.dart';
import 'land_detail_screen.dart';

class BrowseLandScreen extends StatefulWidget {
  const BrowseLandScreen({super.key});

  @override
  State<BrowseLandScreen> createState() => _BrowseLandScreenState();
}

class _BrowseLandScreenState extends State<BrowseLandScreen> {
  String _searchQuery = '';
  String _priceFilter = 'All';

  final _priceOptions = const ['All', 'Under ₹10k', '₹10k–50k', 'Above ₹50k'];

  bool _matchesPriceFilter(double price) {
    switch (_priceFilter) {
      case 'Under ₹10k':
        return price < 10000;
      case '₹10k–50k':
        return price >= 10000 && price <= 50000;
      case 'Above ₹50k':
        return price > 50000;
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Available Land')),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_land_fab',
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddLandScreen()),
          );
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by location',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.cardSurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _priceOptions.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final option = _priceOptions[index];
                final selected = option == _priceFilter;
                return ChoiceChip(
                  label: Text(option),
                  selected: selected,
                  onSelected: (_) => setState(() => _priceFilter = option),
                  selectedColor: AppColors.mossGreen.withValues(alpha: 0.18),
                  backgroundColor: AppColors.cardSurface,
                  labelStyle: TextStyle(
                    color: selected ? AppColors.mossGreenDark : AppColors.soilTextMuted,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: AppColors.mossGreen.withValues(alpha: 0.15)),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: StreamBuilder(
              stream: LandService.streamAvailableLands(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                    itemCount: 4,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Container(
                        height: 76,
                        decoration: BoxDecoration(
                          color: AppColors.mossGreen.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                var lands = snapshot.data ?? [];
                lands = lands
                    .where((l) => l.location.toLowerCase().contains(_searchQuery))
                    .where((l) => _matchesPriceFilter(l.price))
                    .toList();

                if (lands.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.landscape_outlined,
                              size: 48, color: AppColors.mossGreen.withValues(alpha: 0.4)),
                          const SizedBox(height: 12),
                          Text(
                            (snapshot.data ?? []).isEmpty
                                ? 'No land listed yet'
                                : 'No land matches your search',
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            (snapshot.data ?? []).isEmpty
                                ? 'Tap + to add the first listing.'
                                : 'Try a different location or price range.',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: lands.length,
                  itemBuilder: (context, index) {
                    final land = lands[index];
                    return ListingCard(
                      title: '${land.area} acres in ${land.location}',
                      subtitle: 'Soil: ${land.soilType} • Crops: ${land.crops}',
                      price: '₹${land.price.toStringAsFixed(0)} / year',
                      icon: Icons.landscape_outlined,
                      accentColor: AppColors.landAccent,
                      photoBase64: land.photoBase64,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LandDetailScreen(land: land),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
