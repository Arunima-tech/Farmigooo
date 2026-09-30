import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/machinery_model.dart';

class MachineryService {
  static final _db = FirebaseFirestore.instance;
  static final _machineryRef = _db.collection('machinery');
  static final _requestsRef = _db.collection('machinery_requests');

  static void addMachinery(MachineryModel item) {
    _machineryRef.add(item.toMap()).then((_) {}, onError: (_) {});
  }

  static Stream<List<MachineryModel>> streamAvailableMachinery() {
    return _machineryRef
        .where('available', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MachineryModel.fromMap(doc.id, doc.data()))
            .toList());
  }

  static void sendRequest(String machineryId, String farmerId) {
    _requestsRef.add({
      'machineryId': machineryId,
      'farmerId': farmerId,
      'status': 'pending',
      'createdAt': DateTime.now().toIso8601String(),
    }).then((_) {}, onError: (_) {});
  }

  static void setAvailability(String machineryId, bool available) {
    _machineryRef.doc(machineryId).update({'available': available}).catchError((_) {});
  }
}
