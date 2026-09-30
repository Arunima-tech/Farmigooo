import 'package:flutter/material.dart';
import '../models/worker_model.dart';
import '../services/worker_service.dart';
import '../theme/app_theme.dart';
import '../widgets/listing_card.dart';
import 'add_worker_profile_screen.dart';
import 'worker_detail_screen.dart';

class BrowseWorkersScreen extends StatefulWidget {
  const BrowseWorkersScreen({super.key});

  @override
  State<BrowseWorkersScreen> createState() => _BrowseWorkersScreenState();
}

class _BrowseWorkersScreenState extends State<BrowseWorkersScreen> {
  String _searchQuery = '';
  String _priceFilter = 'All';

  final _priceOptions = const ['All', 'Under ₹10k', '₹10k–50k', 'Above ₹50k'];

  static final List<WorkerModel> _demoWorkers = [
    WorkerModel(
      id: 'demo_w1',
      userId: 'demo_worker_789',
      skills: 'Harvesting, Spraying',
      experience: '5 years',
      location: 'Palakkad',
      wage: 750,
      available: true,
      createdAt: DateTime.now(),
    ),
    WorkerModel(
      id: 'demo_w2',
      userId: 'demo_worker_789',
      skills: 'Tractor Driving, Tilling',
      experience: '3 years',
      location: 'Thrissur',
      wage: 900,
      available: true,
      createdAt: DateTime.now(),
    ),
  ];

  bool _matchesWageFilter(double wage) {
    switch (_priceFilter) {
      case 'Under ₹10k':
        return wage < 10000;
      case '₹10k–50k':
        return wage >= 10000 && wage <= 50000;
      case 'Above ₹50k':
        return wage > 50000;
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Available Workers')),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_worker_fab',
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddWorkerProfileScreen()),
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
                  selectedColor: AppColors.workerAccent.withValues(alpha: 0.18),
                  backgroundColor: AppColors.cardSurface,
                  labelStyle: TextStyle(
                    color: selected ? AppColors.soilText : AppColors.soilTextMuted,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                        color: AppColors.workerAccent.withValues(alpha: 0.15)),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: StreamBuilder<List<WorkerModel>>(
              stream: WorkerService.streamAvailableWorkers(),
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
                          color: AppColors.workerAccent.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  );
                }

                var workers = (snapshot.hasData && snapshot.data!.isNotEmpty)
                    ? snapshot.data!
                    : _demoWorkers;

                workers = workers
                    .where((w) => w.location.toLowerCase().contains(_searchQuery))
                    .where((w) => _matchesWageFilter(w.wage))
                    .toList();

                if (workers.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_outline,
                              size: 48,
                              color: AppColors.workerAccent
                                  .withValues(alpha: 0.4)),
                          const SizedBox(height: 12),
                          Text(
                            (snapshot.data ?? []).isEmpty
                                ? 'No workers listed yet'
                                : 'No workers match your search',
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            (snapshot.data ?? []).isEmpty
                                ? 'Tap + to add the first profile.'
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
                  itemCount: workers.length,
                  itemBuilder: (context, index) {
                    final w = workers[index];
                    return ListingCard(
                      title: '${w.skills} • ${w.location}',
                      subtitle: 'Experience: ${w.experience}',
                      price: '₹${w.wage.toStringAsFixed(0)} / day',
                      icon: Icons.person_outline,
                      accentColor: AppColors.workerAccent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WorkerDetailScreen(worker: w),
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
