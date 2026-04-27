import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

class NoteService {
  final CollectionReference _notesCollection =
      FirebaseFirestore.instance.collection('notes');

  /// Stream semua notes, diurutkan berdasarkan createdAt descending
  Stream<List<Note>> getNotes() {
    return _notesCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList();
    });
  }

  /// Tambah note baru ke Firestore
  Future<void> addNote(Note note) async {
    await _notesCollection.add(note.toMap());
  }

  /// Update note yang sudah ada
  Future<void> updateNote(String id, Note note) async {
    await _notesCollection.doc(id).update(note.toMap());
  }

  /// Hapus note berdasarkan ID
  Future<void> deleteNote(String id) async {
    await _notesCollection.doc(id).delete();
  }
}
