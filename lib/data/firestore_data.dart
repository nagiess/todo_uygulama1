import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_uygulama/model/tasks_model.dart';
import 'package:uuid/uuid.dart';

class FirestoreDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> createUser(String email) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          "id": user.uid,
          "email": email,
        });
        return true;
      } else {
        throw Exception("Kullanıcı kimliği bulunamadı.");
      }
    } catch (e) {
      print("CreateUser Hatası:$e");
      return false;
    }
  }

  Future<bool> addTask(String subtitle, String title, int image) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        var uuid = Uuid().v4();
        DateTime data = DateTime.now();
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('tasks')
            .doc(uuid)
            .set({
          "id": uuid,
          "title": title,
          "subtitle": subtitle,
          "image": image,
          "isDone": false,
          "time": '${data.hour}:${data.minute}',
        });
        return true;
      } else {
        throw Exception("Kullanıcı kimliği bulunamadı.");
      }
    } catch (e) {
      print("AddTask Hatası:$e");
      return false;
    }
  }

  List getTasks(AsyncSnapshot snapshot) {
    try {
      final tasksList = snapshot.data.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Task(
          data['id'],
          data['title'],
          data['subtitle'],
          data['time'],
          data['image'],
        );
      }).toList();
      return tasksList;
    } catch (e) {
      return [];
    }
  }

  Stream<QuerySnapshot> stream(bool isDone) {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('tasks')
        .where('isDone', isEqualTo: isDone)
        .snapshots();
  }

  Future<bool> isdone(String uuid, bool isDone) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('tasks')
          .doc(uuid)
          .update({'isDone': isDone});
      return true;
    } catch (e) {
      print(e);
      return true;
    }
  }

  Future<bool> UpdateTask(
      String uuid, int image, String title, String subtitle) async {
    try {
      DateTime data = DateTime.now();
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('tasks')
          .doc(uuid)
          .update({
        'title': title,
        'subtitle': subtitle,
        'image': image,
        'time': '${data.hour}:${data.minute}',
      });
      return true;
    } catch (e) {
      print(e);
      return true;
    }
  }

  Future<bool> DeleteTask(String uuid) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('tasks')
          .doc(uuid)
          .delete();
      return true;
    } catch (e) {
      print(e);
      return true;
    }
  }
}
