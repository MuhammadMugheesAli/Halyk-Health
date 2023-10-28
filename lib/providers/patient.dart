import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:halyk_health/models/user.dart';
import 'package:halyk_health/providers/auth.dart';
import 'package:provider/provider.dart';

import '../models/psychiatric_disease.dart';

class Patient with ChangeNotifier {
  Stream<QuerySnapshot<Map<String, dynamic>>>? clinics;
  Stream<QuerySnapshot<Map<String, dynamic>>>? freeClinics;
  Stream<QuerySnapshot<Map<String, dynamic>>>? paidClinics;
  List<User> allDoctors = [];
  Stream<QuerySnapshot<Map<String, dynamic>>>? appointments;
  Map<String, dynamic>? card;
  List<PsychiatricDisease> diseases = [
    PsychiatricDisease('Аутизм', 'Ограниченный зрительный контакт.',
        'Аутизм — это сложное расстройство нервного развития, характеризующееся проблемами социального взаимодействия, общения, а также повторяющимся или ограничительным поведением.'),
    PsychiatricDisease('Тревожность', 'Головокружение или ощущение дурноты',
        'Тревога — это нормальная человеческая эмоция, испытываемая в ответ на стресс или опасность. Однако когда тревога становится чрезмерной, постоянной и нарушает повседневную жизнь, ее можно классифицировать как тревожное расстройство.'),
    PsychiatricDisease(
        'Синдром Аспергера',
        "Затруднения в установлении и поддержании социальных контактов. Ограниченная способность понимания эмоций и невербальных выражений лица.Неуместное использование жестов, мимики или тон голоса в общении.",
        'Синдром Аспергера, также известный как аспергеровский синдром или аспергеровское расстройство, это одна из форм аутизма, которая была ранее классифицирована как отдельное расстройство в рамках диагностической системы DSM-IV.'),
    PsychiatricDisease(
        'Депрессия',
        'Постоянную печаль и беспокойство.Потерю интереса к ранее приятным делам и хобби.Потерю энергии и чувство усталости.Сонливость или бессонницу.Изменения в аппетите и весе.',
        'Депрессия - это психическое расстройство, которое характеризуется продолжительными периодами глубокой печали, утраты интереса к жизни, снижения энергии и самооценки, а также ряда физических и психологических симптомов.'),
    PsychiatricDisease(
        'Шизофрения',
        'Галлюцинации: ложные ощущения, такие как слышание голосов, видение вещей или ощущение прикосновения, которых на самом деле нет.Бред: неправильные убеждения, которые не соответствуют реальности.',
        'Шизофрения - это тяжелое психическое расстройство, которое влияет на способность мышления, восприятия, эмоций и поведения человека.'),
    PsychiatricDisease(
        'Расстройства личности',
        'Расстройство личности избегающего типа:Ощущение недостаточности и неуверенности в себе.Избегание близких отношений и социальных ситуаций из-за страха перед отвержением.Нежелание делиться личными чувствами и мыслями.',
        'Расстройства личности характеризуются устойчивыми и долгосрочными паттернами мышления, восприятия, поведения и взаимодействия с окружающими.'),
    PsychiatricDisease(
        'Посттравматическое стрессовое расстройство (ПТСР)',
        'Переживания и воспоминания:Повторные воспоминания о травматическом событии, которые могут включать в себя кошмары или навязчивые мысли.Внезапные и неосознанные воспоминания, которые вызывают душевную боль.',
        'Посттравматическое стрессовое расстройство (ПТСР) - это психологическое состояние, которое развивается в ответ на серьезную травму или событие, которое вызвало у человека интенсивный стресс и страх.'),
    PsychiatricDisease(
        'Биполярное аффективное расстройство (БАР)',
        'Маниакальная фаза:Повышенное настроение, эйфория.Увеличенная активность, беспокойство, недостаток сна.Депрессивная фаза:Глубокая печаль, усталость, потеря интереса к жизни.Снижение энергии и активности.',
        'Биполярное аффективное расстройство (БАР), также известное как маниакально-депрессивное расстройство, это психическое расстройство, которое характеризуется периодическими изменениями настроения, проявляющимися в двух противоположных фазах: маниакальной и депрессивной.'),
    PsychiatricDisease(
        'Соматоформные расстройства',
        'Расстройство соматических симптомов:Характеризуется одним или несколькими физическими симптомами, которые вызывают беспокойство или болезненные ощущения.',
        'Соматоформные расстройства - это группа психических расстройств, характеризующихся физическими симптомами или болями, которые не имеют органического физического объяснения.'),
    PsychiatricDisease(
        'синдром Сиэтла',
        'Симпатия к агрессору: Подразумевает, что жертва начинает испытывать симпатию, сострадание или даже положительные чувства к лицу, которое нарушило ее личное пространство или причинило вред.',
        'Этот синдром характеризуется странным и противоречивым психологическим явлением, при котором жертва похищения или насилия начинает развивать положительные чувства и симпатию к своему похитителю или агрессору.'),
  ];

  void fetchClinicsList() {
    clinics = FirebaseFirestore.instance.collection('clinics').snapshots();
    paidClinics = FirebaseFirestore.instance
        .collection('clinics')
        .where('Paid', isEqualTo: true)
        .snapshots();
    freeClinics = FirebaseFirestore.instance
        .collection('clinics')
        .where('Paid', isEqualTo: false)
        .snapshots();
  }

  Future<void> fetchAppointments(BuildContext context) async {
    appointments = FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).currentUser?.phoneNumber)
        .collection('appointments')
        .snapshots();
  }

  Future<void> fetchAllDoctors() async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('users');
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await collectionRef.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) {
      var data = doc.data() as Map?;
      if (data != null && data['role'] == 'doctor') {
        return data;
      }
    }).toList();
    if (allData.isNotEmpty) {
      if (allData.remove(null)) {
        allData.remove(null);
      }
      allDoctors = allData.map((data) {
        return User(data!['firstName'], data['secondName'], data['phoneNumber'],
            data['role'], data['password'], data['clinicName'], data['iin']);
      }).toList();
    }
  }

  Future<void> fetchMedicalCard(BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).currentUser?.phoneNumber)
        .get()
        .then((value) {
            card = value['medicalCard'];
        });
  }

  Future<void> setMedicalRecord(
      BuildContext context,
      String firstName,
      String secondName,
      String iinNumber,
      String pastCondition,
      String surgicalProcedure,
      String allergies,
      String familyHistory,
      String medication,
      String dosage,
      String prescribingPhysician) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).currentUser?.phoneNumber)
        .set({
      'medicalCard': {
        'firstName': firstName,
        'secondName': secondName,
        'iinNumber': iinNumber,
        'pastCondition': pastCondition,
        'surgicalProcedure': surgicalProcedure,
        'allergies': allergies,
        'familyHistory': familyHistory,
        'medication': medication,
        'dosage': dosage,
        'prescribingPhysician': prescribingPhysician,
      }
    },SetOptions(merge: true));
  }
}
