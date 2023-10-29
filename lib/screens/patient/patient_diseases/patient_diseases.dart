import 'package:flutter/material.dart';
import 'package:halyk_health/models/psychiatric_disease.dart';
import 'package:halyk_health/providers/patient.dart';
import 'package:provider/provider.dart';

class PatientDiseases extends StatefulWidget {
  const PatientDiseases({Key? key}) : super(key: key);

  @override
  State<PatientDiseases> createState() => _PatientDiseasesState();
}

class _PatientDiseasesState extends State<PatientDiseases> {
  var searchController = TextEditingController();

  List<PsychiatricDisease>? list;
  late List<PsychiatricDisease> diseasesList;

  @override
  Widget build(BuildContext context) {
    diseasesList = Provider.of<Patient>(context).diseases;
    list ??= diseasesList;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (val) => filter(val),
            controller: searchController,
            decoration: InputDecoration(
                labelText: "Search",
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemBuilder: (ctx, index) {
                var data = list?[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              data!.disease,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text('Symptoms : ${data.symptom}'),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Description: ${data.description}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: list?.length),
        ),
      ],
    );
  }

  void filter(String val) {
    setState(() {
      list = diseasesList
          .where((element) => element.symptom.contains(val))
          .toList();
    });
  }
}
