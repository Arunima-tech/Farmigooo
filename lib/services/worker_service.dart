import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/worker_model.dart';

class WorkerService {
  static final _db = FirebaseFirestore.instance;
  static final _workersRef = _db.collection('workers');

  static void addWorkerProfile(WorkerModel worker) {
    _workersRef.add(worker.toMap()).then((_) {}, onError: (_) {});
  }

  static Stream<List<WorkerModel>> streamAvailableWorkers() {
    return _workersRef
        .where('available', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => WorkerModel.fromMap(doc.id, doc.data()))
            .toList());
  }

  // Simpler than land/machinery: farmer just "contacts" a worker directly,
  // no accept/reject flow needed for the MVP.
  static void requestWorker(String workerId, String farmerId) {
    _db.collection('worker_requests').add({
      'workerId': workerId,
      'farmerId': farmerId,
      'status': 'pending',
      'createdAt': DateTime.now().toIso8601String(),
    }).then((_) {}, onError: (_) {});
  }
}
