import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:humanaty/models/models.dart';
import 'package:humanaty/util/logger.dart';

class DatabaseService {
  final log = getLogger('DatabaseService');
  final String uid;
  DatabaseService({this.uid});

  static Firestore _databaseRef = Firestore.instance;

  final CollectionReference userCollection = _databaseRef.collection('users');
  final CollectionReference eventCollection = _databaseRef.collection('events');
  final CollectionReference farmCollection = _databaseRef.collection('farmers');

  Stream<UserData> get userData => userCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  
  Stream<Profile> getProfile(String userID) => userCollection.document(userID).snapshots().map(_profileFromSnapshot);
  Stream<List<HumanatyEvent>> get myEvents => eventCollection.where('hostID', isEqualTo: '$uid').snapshots().map(_eventsFromSnapshot);
  Stream<HumanatyEvent> getEvent(String eventID) => eventCollection.document(eventID).snapshots().map(_eventFromSnapshot);
  
  //parameters will need to be added for filtering
  Stream<List<HumanatyEvent>> getEvents(){
    return eventCollection
        .where('hostID', isGreaterThan: '0')
        .snapshots()
        .map(_eventsFromSnapshot);
  }

  Stream<List<HumanatyFarm>> getFarms() => farmCollection.where('farmID', isGreaterThan: '0').snapshots().map(_farmsFromSnapshot);
  Stream<HumanatyFarm> getFarm(String farmID) => farmCollection.document(farmID).snapshots().map(_farmFromSnapshot);


  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      aboutMe: snapshot.data['aboutMe'],
      accessibilityAccommodations: snapshot.data['accessibilityAccommodations'],
      allergies: Allergy()
          .allergyMapFromList(snapshot.data['allergies'].cast<String>()),
      birthday: DateTime.parse(snapshot.data['birthday']),
      displayName: snapshot.data['displayName'],
      email: snapshot.data['email'],
      guestRating: snapshot.data['guestRating'].toDouble(),
      hostRating: snapshot.data['hostRating'].toDouble(),
      location: HumanatyLocation()
          .humanantyLocationFromMap(snapshot.data['location']),
      photoUrl: snapshot.data['photoUrl'],
      uid: uid,
    );
  }

  Profile _profileFromSnapshot(DocumentSnapshot snapshot) {
    Profile _profile;
    _profile = Profile(
      aboutMe: snapshot.data['aboutMe'],
      guestRating: snapshot.data['guestRating'].toDouble(),
      displayName: snapshot.data['displayName'],
      //final List<String> hostEventHistory
      hostRating: snapshot.data['hostRating'].toDouble(),
      //final List<String> hostUpcomingEvents
      photoUrl: snapshot.data['photoUrl'],
      userID: snapshot.data['uid']
    );
    return _profile;
  }

  Future<void> createUserDoc(String displayName, String email) async {
    String currentYMD = DateTime.now().toString();
    await userCollection.document(uid).setData({
      'aboutMe': 'Tell future guests about your qualifications',
      'accessibilityAccommodations': false,
      'allergies': [],
      'birthday': currentYMD.substring(0, currentYMD.indexOf(' ')),
      'displayName': displayName,
      'email': email,
      'guestRating': 5,
      'hostRating': 5,
      'photoUrl':
          'https://firebasestorage.googleapis.com/v0/b/humanaty-gatech.appspot.com/o/defaultProfilePic%2FdefaultProfilePic.jpg?alt=media&token=e87a7526-daf8-4466-b186-e8703b1da31b',
      'uid': uid
    });
    await updateUserLocation(HumanatyLocation());
  }

  Future<void> updateUserEmail(String email) async {
    await userCollection.document(uid).updateData({'email': email});
  }

  Future<void> updateUserBirthday(DateTime birthday) async {
    String _birthday = birthday.toString();
    await userCollection.document(uid).updateData(
        {'birthday': _birthday.substring(0, _birthday.indexOf(" "))});
  }

  Future<void> updateUserAboutMe(String aboutMe) async {
    await userCollection.document(uid).updateData({'aboutMe': aboutMe});
  }

  Future<void> updateUserAccess(bool accessibility) async {
    await userCollection
        .document(uid)
        .updateData({'accessibilityAccommodations': accessibility});
  }

  Future<void> updateUserAllergy(Map<String, bool> userAllergies) async {
    return await userCollection
        .document(uid)
        .updateData({'allergies': Allergy().allergyListFromMap(userAllergies)});
  }

  Future<void> updateUserPicture(String url) async {
    await userCollection.document(uid).updateData({'photoUrl': url});
  }

  Future<void> updateUserLocation(HumanatyLocation location) async {
    print(location.address);
    await userCollection.document(uid).updateData({
      'location': {
        'address': location.address,
        'city': location.city,
        'coordinates': location.geoPoint,
        'state': location.state,
        'zip': location.zip
      }
    });
  }

  Future<void> createEvent(bool accessibilityAccommodations, List eventAllergies, double costPerSeat,
      DateTime eventDate, String description, int eventCapacity, HumanatyLocation eventLocation, String eventMenu,
      String eventTitle) async {
    String _eventDate = eventDate.toString();
    DocumentReference _doc = eventCollection.document();
    await _doc.setData({
      'accessibilityAccommodations': false,
      'additionalInfo': '',
      'allergies': eventAllergies,
      'attendees': Map<dynamic, dynamic>(),
      'costPerSeat': costPerSeat,
      'date': _eventDate.substring(0, _eventDate.lastIndexOf(':')),
      'description': description,
      'eventID': _doc.documentID,
      'guestNum': eventCapacity,
      'hostID': this.uid,
      'location': {
        'address': eventLocation.address,
        'city': eventLocation.city,
        'coordinates': eventLocation.geoPoint,
        'state': eventLocation.state,
        'zip': eventLocation.zip
      },
      'meal': eventMenu,
      'seatsAvailable': eventCapacity,
      'title': eventTitle
    });
  }

  HumanatyEvent _eventFromSnapshot(DocumentSnapshot snapshot) {
    HumanatyEvent event;
    //print(snapshot.data['attendees']);
    try {
      event = HumanatyEvent(
        accessibilityAccommodations:
            snapshot.data['accessibilityAccommodations'],
        additionalInfo: snapshot.data['additionalInfo'],
        allergies: snapshot.data['allergies'].cast<String>(),
        attendees: _attendeesFromMap(snapshot.data['attendees']),
        costPerSeat: double.parse(snapshot.data['costPerSeat'].toString()),
        date: DateTime.parse(snapshot.data['date']),
        description: snapshot.data['description'],
        eventID: snapshot.data['eventID'],
        guestNum: snapshot.data['guestNum'],
        hostID: snapshot.data['hostID'],
        location: HumanatyLocation()
            .humanantyLocationFromMap(snapshot.data['location']),
        meal: snapshot.data['meal'],
        //photoGallery: doc.data['photoGallery'],
        seatsAvailable: snapshot.data['seatsAvailable'],
        title: snapshot.data['title']);
    } catch (error) {
      print(error.toString());
    }
    return event;
  }

  List<Attendee> _attendeesFromMap(Map map){
    List<Attendee> attendees = [];
    map.forEach((key, value) async {
      Profile profile;
      Stream<Profile> stream = this.getProfile(key);
      stream.listen((data) {
        profile = data;
        attendees.add(
          Attendee(
            profile: profile,
            guests: value['guests']
          )
        );
        
      });
    });    
    return attendees;
  }

  List<HumanatyEvent> _eventsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      HumanatyEvent event;
      try {
        event = HumanatyEvent(
          accessibilityAccommodations:
              doc.data['accessibilityAccommodations'],
          additionalInfo: doc.data['additionalInfo'],
          allergies: doc.data['allergies'],
          attendees: _attendeesFromMap(doc.data['attendees']),
          costPerSeat: double.parse(doc.data['costPerSeat'].toString()),
          date: DateTime.parse(doc.data['date']),
          description: doc.data['description'],
          eventID: doc.data['eventID'],
          guestNum: doc.data['guestNum'],
          hostID: doc.data['hostID'],
          location: HumanatyLocation()
              .humanantyLocationFromMap(doc.data['location']),
          meal: doc.data['meal'],
          //photoGallery: doc.data['photoGallery'],
          seatsAvailable: doc.data['seatsAvailable'],
          title: doc.data['title']);
      } catch (e) {
        print(e.toString());
        print(doc.data['title']);
      }
      return event;
    }).toList();
  }

  Future<void> updateEventMeal(String eventID, String meal)async{
    await eventCollection.document(eventID).updateData({'meal': meal});
  }

  Future<void> updateEventAllergens(String eventID, Map<String, bool> allergens)async{
    await eventCollection.document(eventID).updateData({'allergies': Allergy().allergyListFromMap(allergens)});
  }
  
  Future<void> addEventAttendees(String eventID, int guestNum, int seatsAvailable) async{  
    DocumentReference eventRef = eventCollection.document(eventID);
    await eventRef.setData({
      'attendees':{
        uid:{
          'guests': guestNum
        }
      }
    }, merge: true);

    await eventRef.setData({
      'seatsAvailable': (seatsAvailable - guestNum)
    }, merge: true);
  }

  HumanatyFarm _farmFromSnapshot(DocumentSnapshot snapshot){
    HumanatyFarm farm;
    try{
      farm = HumanatyFarm(
        contact: snapshot?.data['contact'] ?? '',
        farmID: snapshot.data['farmID'],
        location: HumanatyLocation().humanantyLocationFromMap(snapshot.data['location']),
        name: snapshot.data['name'],
        telephone: snapshot.data['telephone'],
        website: snapshot.data['website']
      );
    } catch(error){
      log.e('Failed to retrieve farm \n ${error.toString()}');
    }
    return farm;
  }

  List<HumanatyFarm> _farmsFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return HumanatyFarm(
        contact: doc.data['contact'],
        farmID: doc.data['farmID'],
        location: HumanatyLocation().humanantyLocationFromMap(doc.data['location']),
        name: doc.data['name'],
        telephone: doc.data['telephone'],
        website: doc.data['website']
      );
    }).toList();
  }

} //Database Service
