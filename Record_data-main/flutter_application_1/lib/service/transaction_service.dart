import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addTransaction({
    required double amount,
    required DateTime date,
    required String type, // "income" or "expense"
    required String note,
  }) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).collection('transactions').add({
        'amount': amount,
        'date': date,
        'type': type,
        'note': note,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Stream<QuerySnapshot> getTransactions() {
    final user = _auth.currentUser;
    if (user != null) {
      return _firestore.collection('users').doc(user.uid).collection('transactions').snapshots();
    } else {
      throw FirebaseAuthException(message: 'No user signed in', code: 'USER_NOT_SIGNED_IN');
    }
  }

  Future<double> getTotalAmount(String type) async {
  final user = _auth.currentUser;
  if (user != null) {
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .where('type', isEqualTo: type)
        .get();
    
    double total = 0;
    for (var doc in snapshot.docs) {
      total += doc['amount'];
    }
    return total;
  } else {
    throw FirebaseAuthException(message: 'No user signed in', code: 'USER_NOT_SIGNED_IN');
  }
 }
}
