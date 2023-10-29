import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:halyk_health/models/user.dart' as model;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  Auth() {
    init();
  }

  Future<void> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var isLoggedIn=prefs.getBool('isLoggedIn');
    if (isLoggedIn != null && isLoggedIn) {
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
  }

  model.User? currentUser;

  bool _loggedIn = false;

  bool get loggedIn => _loggedIn;

  Future<void> register(
      Map<String, dynamic> data) async {
    try {
      if (await checkIfUserExists(data["phoneNumber"],data['role'])) {
        throw Exception('User already exists');
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('phoneNumber', data['phoneNumber']);
      await prefs.setString('password', data['password']);
      await prefs.setString('role', data['role']);
      await prefs.setBool('isLoggedIn', true);
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

  Future<bool> checkIfUserExists(String phoneNumber,String role) async {
    try {
      var collectionRef = FirebaseFirestore.instance.collection('users');
      var doc = await collectionRef.doc(phoneNumber).get();
      if(doc.exists){
        if(doc.get('role') == role){
          return true;
        }
        return false;
      }
      return false;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> login(String phoneNumber, String password, String role) async {
    try {
      if (await checkIfUserExists(phoneNumber,role)) {
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
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('phoneNumber', phoneNumber);
            await prefs.setString('password', password);
            await prefs.setString('role', role);
            await prefs.setBool('isLoggedIn', true);
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

  Future<void> getCurrentUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(prefs.getString('phoneNumber'))
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('phoneNumber');
    await prefs.remove('password');
    await prefs.remove('role');
    await prefs.setBool('isLoggedIn', false);
    currentUser = null;
    notifyListeners();
  }
}
