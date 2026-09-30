import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/land_model.dart';
import '../services/land_service.dart';
import '../services/image_helper.dart';
import '../theme/app_theme.dart';

class AddLandScreen extends StatefulWidget {
  const AddLandScreen({super.key});

  @override
  State<AddLandScreen> createState() => _AddLandScreenState();
}

class _AddLandScreenState extends State<AddLandScreen> {
  final _formKey = GlobalKey<FormState>();

  final _locationController = TextEditingController();
  final _areaController = TextEditingController();
  final _soilController = TextEditingController();
  final _cropsController = TextEditingController();
  final _priceController = TextEditingController();

  bool _saving = false;
  bool _pickingImage = false;
  String? _photoBase64;

  final String demoOwnerId = 'demo_owner_123';

  Future<void> _pickPhoto() async {
    setState(() => _pickingImage = true);
    final result = await ImageHelper.pickAndEncodeImage();
    setState(() {
      _pickingImage = false;
      if (result != null) _photoBase64 = result;
    });
  }

  void _saveLand() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final land = LandModel(
      id: '',
      ownerId: demoOwnerId,
      location: _locationController.text.trim(),
      area: double.parse(_areaController.text.trim()),
      soilType: _soilController.text.trim(),
      crops: _cropsController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      available: true,
      createdAt: DateTime.now(),
      photoBase64: _photoBase64,
    );

    LandService.addLand(land).catchError((_) {});

    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Land added!')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Land')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Photo picker
              GestureDetector(
                onTap: _pickingImage ? null : _pickPhoto,
                child: Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.mossGreen.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.mossGreen.withValues(alpha: 0.2)),
                  ),
                  child: _pickingImage
                      ? const Center(child: CircularProgressIndicator())
                      : _photoBase64 != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.memory(
                                base64Decode(_photoBase64!),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 160,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add_a_photo_outlined,
                                    color: AppColors.mossGreen, size: 32),
                                const SizedBox(height: 8),
                                Text('Add a photo of the land',
                                    style: Theme.of(context).textTheme.bodyMedium),
                              ],
                            ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _areaController,
                decoration: const InputDecoration(labelText: 'Area (in acres)'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _soilController,
                decoration: const InputDecoration(labelText: 'Soil type'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _cropsController,
                decoration: const InputDecoration(
                    labelText: 'Suitable crops (comma separated)'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                decoration:
                    const InputDecoration(labelText: 'Price / rent (₹ per year)'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saving ? null : _saveLand,
                child: _saving
                    ? const CircularProgressIndicator()
                    : const Text('Save Land'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
