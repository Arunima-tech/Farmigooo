import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/land_model.dart';
import '../models/land_request_model.dart';

class LandService {
  static final _db = FirebaseFirestore.instance;
  static final _landsRef = _db.collection('lands');
  static final _requestsRef = _db.collection('land_requests');

  // ---------- LANDS ----------

  static Future<void> addLand(LandModel land) async {
    await _landsRef.add(land.toMap());
  }

  static Stream<List<LandModel>> streamAvailableLands() {
    return _landsRef
        .where('available', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LandModel.fromMap(doc.id, doc.data()))
            .toList());
  }

  static Stream<List<LandModel>> streamMyLands(String ownerId) {
    return _landsRef
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LandModel.fromMap(doc.id, doc.data()))
            .toList());
  }

  static Future<void> setLandAvailability(String landId, bool available) async {
    await _landsRef.doc(landId).update({'available': available});
  }

  // ---------- REQUESTS ----------

  static Future<void> sendRequest(String landId, String farmerId) async {
    await _requestsRef.add({
      'landId': landId,
      'farmerId': farmerId,
      'status': 'pending',
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  static Stream<List<LandRequestModel>> streamRequestsForLand(String landId) {
    return _requestsRef
        .where('landId', isEqualTo: landId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LandRequestModel.fromMap(doc.id, doc.data()))
            .toList());
  }

  static Future<void> updateRequestStatus(String requestId, String status) async {
    await _requestsRef.doc(requestId).update({'status': status});
  }
}
