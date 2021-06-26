import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:virtual_store/models/user.dart';
import 'package:virtual_store/models/user_manager.dart';

class AdminUserManager extends ChangeNotifier {
  final Firestore firestore = Firestore.instance;

  List<User> users = [];
  void updateUser(UserManager userManager) {
    if (userManager.adminEnable) {
      _listenToUsers();
    } else {
      users.clear();
      notifyListeners();
    }
  }

  void _listenToUsers() {
    firestore.collection('users').getDocuments().then((snapshot) {
      users = snapshot.documents.map((d) => User.fromDocument(d)).toList();
      users
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      notifyListeners();
    });
  }

  List<String> get names => users.map((e) => e.name).toList();
}
