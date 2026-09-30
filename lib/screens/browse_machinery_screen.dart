import 'package:flutter/material.dart';
import '../models/machinery_model.dart';
import '../services/machinery_service.dart';
import '../theme/app_theme.dart';
import '../widgets/listing_card.dart';
import 'add_machinery_screen.dart';
import 'machinery_detail_screen.dart';

class BrowseMachineryScreen extends StatefulWidget {
  const BrowseMachineryScreen({super.key});

  @override
  State<BrowseMachineryScreen> createState() => _BrowseMachineryScreenState();
}

class _BrowseMachineryScreenState extends State<BrowseMachineryScreen> {
  String _searchQuery = '';
  String _priceFilter = 'All';

  final _priceOptions = const ['All', 'Under ₹10k', '₹10k–50k', 'Above ₹50k'];

  static final List<MachineryModel> _demoMachinery = [
    MachineryModel(
      id: 'demo_m1',
      ownerId: 'demo_owner_123',
      type: 'Tractor 45HP',
      location: 'Palakkad',
      dailyRate: 1500,
      available: true,
      createdAt: DateTime.now(),
    ),
    MachineryModel(
      id: 'demo_m2',
      ownerId: 'demo_owner_123',
      type: 'Power Tiller',
      location: 'Thrissur',
      dailyRate: 800,
      available: true,
      createdAt: DateTime.now(),
    ),
  ];

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
      appBar: AppBar(title: const Text('Available Machinery')),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_machinery_fab',
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddMachineryScreen()),
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
                  selectedColor: AppColors.machineryAccent.withValues(alpha: 0.18),
                  backgroundColor: AppColors.cardSurface,
                  labelStyle: TextStyle(
                    color: selected ? AppColors.soilText : AppColors.soilTextMuted,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                        color: AppColors.machineryAccent.withValues(alpha: 0.15)),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: StreamBuilder<List<MachineryModel>>(
              stream: MachineryService.streamAvailableMachinery(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                    itemCount: 4,
                    itemBuilder: (context, index) => Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Container(
                        height: 76,
                        decoration: BoxDecoration(
                          color: AppColors.machineryAccent.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  );
                }

                var items = (snapshot.hasData && snapshot.data!.isNotEmpty)
                    ? snapshot.data!
                    : _demoMachinery;

                items = items
                    .where((m) => m.location.toLowerCase().contains(_searchQuery))
                    .where((m) => _matchesPriceFilter(m.dailyRate))
                    .toList();

                if (items.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.agriculture_outlined,
                              size: 48,
                              color: AppColors.machineryAccent
                                  .withValues(alpha: 0.4)),
                          const SizedBox(height: 12),
                          Text(
                            (snapshot.data ?? []).isEmpty
                                ? 'No machinery listed yet'
                                : 'No machinery matches your search',
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
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListingCard(
                      title: '${item.type} in ${item.location}',
                      subtitle: 'Available now',
                      price: '₹${item.dailyRate.toStringAsFixed(0)} / day',
                      icon: Icons.agriculture_outlined,
                      accentColor: AppColors.machineryAccent,
                      photoBase64: item.photoBase64,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                MachineryDetailScreen(item: item),
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
