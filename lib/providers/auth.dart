import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:halyk_health/models/user.dart' as model;

class Auth with ChangeNotifier {
  Auth() {
    init();
  }

  void init() {
    FirebaseAuth.instance.userChanges().listen((user) async {
      if (user != null) {
        await getCurrentUser();
        if (currentUser != null) {
          _loggedIn = true;
        } else {
          _loggedIn = false;
        }
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }

  // List<User> _users=[];
  model.User? currentUser;

  bool _loggedIn = false;

  bool get loggedIn => _loggedIn;

  Future<void> register(
      Map<String, dynamic> data, PhoneAuthCredential credential) async {
    try {
      if (await checkIfUserExists(data["phoneNumber"])) {
        throw Exception('User already exists');
      }
      var auth = FirebaseAuth.instance;
      await auth.signInWithCredential(credential);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(data['phoneNumber'])
          .set(data)
          .onError((e, _) => throw Exception("Error writing document: $e"));
      currentUser = model.User(
          data['firstName'],
          data['secondName'],
          data['phoneNumber'],
          data['role'],
          data['password'],
          data['clinicName'],
          data['iinNumber']);
    } catch (exception) {
      throw Exception(exception);
    }
    notifyListeners();
  }

  Future<bool> checkIfUserExists(String phoneNumber) async {
    try {
      var collectionRef = FirebaseFirestore.instance.collection('users');
      var doc = await collectionRef.doc(phoneNumber).get();
      return doc.exists;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> login(String phoneNumber, String password, String role,
      PhoneAuthCredential credential) async {
    try {
      if (await checkIfUserExists(phoneNumber)) {
        var data =
            FirebaseFirestore.instance.collection('users').doc(phoneNumber);
        late model.User user;
        await data.get().then((value) {
          user = model.User(
              value['firstName'],
              value['secondName'],
              value['phoneNumber'],
              value['role'],
              value['password'],
              value['clinicName'],
              value['iinNumber']);
        });
        if (user.password == password) {
          if (user.role == role) {
            currentUser = user;
            await FirebaseAuth.instance.signInWithCredential(credential);
          } else {
            throw Exception("User doesn't exist");
          }
        } else {
          throw Exception("Incorrect Password");
        }
      } else {
        throw Exception("User doesn't exist");
      }
    } catch (e) {
      throw Exception(e);
    }
    notifyListeners();
  }

  Future<void> checkLoginCredentials(
      String phoneNumber, String password, String role) async {
    try {
      if (await checkIfUserExists(phoneNumber)) {
        var data =
            FirebaseFirestore.instance.collection('users').doc(phoneNumber);
        late model.User user;
        await data.get().then((value) {
          user = model.User(
              value['firstName'],
              value['secondName'],
              value['phoneNumber'],
              value['role'],
              value['password'],
              value['clinicName'],
              value['iinNumber']);
        });
        if (user?.password == password) {
          if (user?.role == role) {
          } else {
            throw Exception("User doesn't exist");
          }
        } else {
          throw Exception("Incorrect Password");
        }
      } else {
        throw Exception("User doesn't exist");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> getCurrentUser() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.phoneNumber?.replaceFirst('+92', '+7'))
        .get()
        .then((value) => currentUser = model.User(
            value['firstName'],
            value['secondName'],
            value['phoneNumber'],
            value['role'],
            value['password'],
            value['clinicName'],
            value['iinNumber']));
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    currentUser = null;
    notifyListeners();
  }
}
