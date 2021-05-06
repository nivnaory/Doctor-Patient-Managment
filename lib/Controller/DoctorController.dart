import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homephiys/Controller/PaitentController.dart';
import 'package:homephiys/Entitys/Doctor.dart';
import 'package:homephiys/Entitys/WaitingPaitent.dart';

//this function  handel the connection to database

class DoctorController {
  final CollectionReference doctorCollection =
      Firestore.instance.collection("Doctors");
  PaitentController pController;
  DoctorController() {
    pController = PaitentController();
  }

  Future<bool> registerDoctor(
      String email, String password, String name) async {
    try {
      AuthResult auth = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      ///here save doc on database
      await doctorCollection
          .document(email)
          .setData({'email': email, 'name': name, 'isAvailable': false});

      return Future.value(true);
    } catch (e) {
      print(e);
      return Future.value(false);
    }
  }

  Future<bool> loginDoctor(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return Future.value(true);
    } catch (e) {
      print(e);
      return Future.value(false);
    }
  }

  Future<List<Doctor>> getAllDoctorFromDB() async {
    List<Doctor> alldoctors = [];
    try {
      /*
      doctorCollection.snapshots().listen((querySnapshot) {
        querySnapshot.documentChanges.forEach((element) {
          bool isAvailable = element.document['isAvailable'];
          Doctor newDoctor = new Doctor(element.document['email'],
              element.document['name'].toString(), isAvailable);

          alldoctors.add(newDoctor);
       
        });
      });
        */

      var snapshot = await doctorCollection.getDocuments();
      snapshot.documents.forEach((element) {
        bool isAvailable = element['isAvailable'];
        Doctor newDoctor = new Doctor(
            element['email'], element['name'].toString(), isAvailable);
        alldoctors.add(newDoctor);

        //get the paitentList but need to check of collection exsist!
        Future<List<WaitingPaitent>> futureWaitingPaitent =
            pController.getPaitnetWaitingList(element['email'].toString());
        futureWaitingPaitent.then((waitingPaitent) {
          print("im here niv naory");
          newDoctor.waitingPaitentList = waitingPaitent;
        });
      });

      //  return alldoctors;
      return Future.value(alldoctors);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Doctor> getDoctor(String email) async {
    try {
      Doctor newDoctor;
      await doctorCollection.document(email).get().then((doctor) {
        bool isAvailabel = doctor.data['isAvailable'];
        newDoctor = new Doctor(doctor.data['email'].toString(),
            doctor.data['name'].toString(), isAvailabel);

        //get the paitentList but need to check of collection exsist!
        Future<List<WaitingPaitent>> futureWaitingPaitent =
            pController.getPaitnetWaitingList(doctor.data['email'].toString());
        futureWaitingPaitent.then((waitingPaitent) {
          newDoctor.waitingPaitentList = waitingPaitent;
        });
      });
      return Future.value(newDoctor);
    } catch (e) {
      print(e);
      return Future.value(null);
    }
  }

  Future<bool> updateWaitingList(
      String doctorEmail, String paitentEmail, String paitentName) async {
    DateTime now = DateTime.now();
    try {
      Future<bool> isAllReadyExsist =
          checkIfPaitentNotAllReadyInWaitingList(doctorEmail, paitentEmail);
      isAllReadyExsist.then((value) async {
        if (value == false) {
          await doctorCollection
              .document(doctorEmail)
              .collection("paitents_waiting")
              .add({'paitent': paitentEmail, "time": now, "name": paitentName});
          return Future.value(true);
        }
      });

      return Future.value(false);
    } catch (e) {
      print(e);
      return Future.value(true);
    }
  }

  Future<bool> checkIfPaitentNotAllReadyInWaitingList(
      String doctorEmail, String paitentEmail) async {
    bool value = false;
    try {
      var snapshotWaitingPaitent = await doctorCollection
          .document(doctorEmail)
          .collection("paitents_waiting")
          .getDocuments();
      snapshotWaitingPaitent.documents.forEach((element) {
        print(element['paitent'].toString());
        if (element['paitent'].toString() == paitentEmail) {
          value = true;
        }
        print(value);
      });
      return Future.value(value);
    } catch (e) {
      print(e);
      return Future.value(value);
    }
  }

  Future<bool> removerPaitnetFromWaitingList(
      String doctorEmail, String paitentEmail) async {
    try {
      return Future.value(true);
    } catch (e) {
      print(e);
      return Future.value(false);
    }
  }

  Future<bool> updateDoctor(String doctorEmail, bool isAvailable) async {
    try {
      doctorCollection
          .document(doctorEmail)
          .updateData({"isAvailable": isAvailable});
      return Future.value(true);
    } catch (e) {
      print(e);
      return Future.value(false);
    }
  }
}

/*
Future<List<Doctor>> getDoctorsFromDB() async {
  final response = await http.get('http://10.0.2.2:5000/doctorList/'
      // 'http://192.168.1.28:5000/paitent/${username}'
      );
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON
    //
    //

    var a = Snapshot.fromJson(json.decode(response.body));

    List jsonDoctorsList = List.from(a.asList());
    print(jsonDoctorsList);
    List<Doctor> doctors = [];
    print(jsonDoctorsList.length);
    for (int i = 0; i < jsonDoctorsList.length; i++) {
      doctors.add(Doctor.fromJson(jsonDoctorsList[i]));
    }
    print(doctors.toString());
    return doctors;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Paitent');
  }
}
*/