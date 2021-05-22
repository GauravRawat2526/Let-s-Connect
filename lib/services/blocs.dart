
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class Blocs{
  final _userName= BehaviorSubject<String>();//use to store the latest value
  final _aboutUser = BehaviorSubject<String>();
  final _fullName = BehaviorSubject<String>();
  static final _firestore = FirebaseFirestore.instance;
  
  //Get
  Stream<String> get userName=>_userName.stream.transform(validateUserName); //to access the variable
  Stream<String> get aboutUser=>_aboutUser.stream.transform(validateAboutUser);
  Stream<String> get fullName =>_fullName.stream.transform(validateFullName);
  Stream<bool> get userValid => Rx.combineLatest3(userName, aboutUser, fullName, (userName, aboutUser, fullName) => true);
  Stream<bool> get changeValid => Rx.combineLatest2(aboutUser, fullName, (aboutUser, fullName) => true);
  //Stream<bool> get invalidName =>Rx.combineLatest( fullName, (fullName) => null);
  
  //Set
  Function(String) get changeUserName => _userName.sink.add;
  Function(String) get changeAboutUser => _aboutUser.sink.add;
  Function(String) get changeFullName => _fullName.sink.add;
  
  dispose(){
    _userName.close();
    _aboutUser.close();
    _fullName.close();
  }

  //Transformers

  final validateUserName = StreamTransformer<String,String>.fromHandlers(
    handleData: (userName,sink) async {
      final documentSnapshot = await _firestore
                      .collection('users')
                      .doc(userName)
                      .get();
      if(userName.length<5){
        sink.addError("UserName must be at least 5 character");
      }
      else if(userName.isEmpty){
        sink.addError("User can't be empty"); 
      }
      else if (documentSnapshot.exists) {
        sink.addError("UserName is already Exists"); 
      } 
      else{
        sink.add(userName);
      }
    }
  );

  final validateAboutUser = StreamTransformer<String,String>.fromHandlers(
    handleData: (aboutUser,sink) {
      if(aboutUser.isEmpty){
        sink.addError("about is Required");
      }
      else{
        sink.add(aboutUser);
      }
    }
  );

  final validateFullName = StreamTransformer<String,String>.fromHandlers(
    handleData: (fullName,sink){
      if(fullName.isEmpty){
        sink.addError("Name is Required");
      }
      else{
        sink.add(fullName);
      }
    }
  );
}