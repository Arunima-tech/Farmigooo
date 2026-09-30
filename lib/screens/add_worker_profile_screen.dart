import 'package:flutter/material.dart';
import '../models/worker_model.dart';
import '../services/worker_service.dart';

class AddWorkerProfileScreen extends StatefulWidget {
  const AddWorkerProfileScreen({super.key});

  @override
  State<AddWorkerProfileScreen> createState() =>
      _AddWorkerProfileScreenState();
}

class _AddWorkerProfileScreenState extends State<AddWorkerProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _skillsController = TextEditingController();
  final _experienceController = TextEditingController();
  final _locationController = TextEditingController();
  final _wageController = TextEditingController();
  bool _saving = false;

  final String demoUserId = 'demo_worker_789';

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final worker = WorkerModel(
      id: '',
      userId: demoUserId,
      skills: _skillsController.text.trim(),
      experience: _experienceController.text.trim(),
      location: _locationController.text.trim(),
      wage: double.parse(_wageController.text.trim()),
      available: true,
      createdAt: DateTime.now(),
    );

    WorkerService.addWorkerProfile(worker);

    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Profile saved!')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Worker Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _skillsController,
                decoration: const InputDecoration(
                    labelText: 'Skills (comma separated)'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _experienceController,
                decoration: const InputDecoration(labelText: 'Experience'),
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _wageController,
                decoration:
                    const InputDecoration(labelText: 'Wage expectation (₹/day)'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const CircularProgressIndicator()
                    : const Text('Save Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
