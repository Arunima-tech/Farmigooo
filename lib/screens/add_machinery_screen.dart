import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/machinery_model.dart';
import '../services/machinery_service.dart';
import '../services/image_helper.dart';
import '../theme/app_theme.dart';

class AddMachineryScreen extends StatefulWidget {
  const AddMachineryScreen({super.key});

  @override
  State<AddMachineryScreen> createState() => _AddMachineryScreenState();
}

class _AddMachineryScreenState extends State<AddMachineryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _typeController = TextEditingController();
  final _locationController = TextEditingController();
  final _rateController = TextEditingController();
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

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final item = MachineryModel(
      id: '',
      ownerId: demoOwnerId,
      type: _typeController.text.trim(),
      location: _locationController.text.trim(),
      dailyRate: double.parse(_rateController.text.trim()),
      available: true,
      createdAt: DateTime.now(),
      photoBase64: _photoBase64,
    );

    MachineryService.addMachinery(item);

    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Machinery added!')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Machinery')),
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
                    color: AppColors.machineryAccent.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: AppColors.machineryAccent.withValues(alpha: 0.2)),
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
                                    color: AppColors.machineryAccent, size: 32),
                                const SizedBox(height: 8),
                                Text('Add a photo of the machinery',
                                    style: Theme.of(context).textTheme.bodyMedium),
                              ],
                            ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _typeController,
                decoration:
                    const InputDecoration(labelText: 'Type (Tractor, Tiller, etc.)'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _rateController,
                decoration: const InputDecoration(labelText: 'Daily rate (₹)'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const CircularProgressIndicator()
                    : const Text('Save Machinery'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
