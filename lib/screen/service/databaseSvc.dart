import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/UserModel.dart';

class DatabaseSvc{
  // FirebaseDatabase database = FirebaseDatabase.instance;

  DatabaseReference ref = FirebaseDatabase.instance.ref();

  void deleteDB(String userkey, FirebaseAuth authetication)
  {
    final UserKey =
    FirebaseDatabase.instance.ref().child("Join/" + userkey);
    UserKey.remove();

    User? user = authetication.currentUser;
    user?.delete();
  }
  void updateDB(String userkey, String NEWname, String NEWemail, String NEWpw, String NEWph_num) async {
    // A post entry.
    final userData = {
      "name": NEWname,
      "email": NEWemail,
      "pw": NEWpw,
      "ph_num": NEWph_num
    };

    final Map<String, Map> updates = {};
    updates['Join/'+userkey] = userData;

    return FirebaseDatabase.instance.ref().update(updates);
  }

  Future<void> writeDB(String userkey, String name, String email, String pw, String ph_num) async {

    DatabaseReference ref = FirebaseDatabase.instance.ref("Join/" + userkey);

    await ref.set({
      "name": name,
      "email": email,
      "pw": pw,
      "ph_num": ph_num
    });
  }

  void readDB(String userkey){
    DatabaseReference starCountRef =
    FirebaseDatabase.instance.ref("Join/" + userkey);
    starCountRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;

      if(data.isEmpty){
        print("no data");
        return;
      }

      final users=<UserModel>[];
      for(final key in data.keys){
        final uservalue = data[key];
        final user = UserModel.fromMap(uservalue);
        users.add(user);
      }

      print("users $users");
      // updateStarCount(data);
    });
  }

}