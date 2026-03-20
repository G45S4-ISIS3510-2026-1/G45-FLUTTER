import 'package:flutter/material.dart';
import 'package:g45_flutter/viewmodels/skills_viewmodel.dart';
import 'package:g45_flutter/widgets/tutor_card.dart';
import 'package:g45_flutter/data/mock/tutor_mock.dart';
import 'package:g45_flutter/data/mock/facultades_mock.dart';
import 'package:g45_flutter/viewmodels/tutor_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:g45_flutter/models/tutor_summary.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {

  @override
  //una vez abre el page corre todo esto
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<TutorViewModel>(context, listen: false).loadTutors();// llamado a backend para cargar todos los tutores los guarda en view model
      //Provider.of<SkillsViewModel>(context, listen: false).loadSkills(); //llamado a backend para cargar todos los skills los guarda en view model
    });
  }
  //Datos mockeados

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TutorViewModel>(context); //instancia de ViewModel donde vm.tutor es la lista de todos los TutorSummary
    //final skillsVM = Provider.of<SkillsViewModel>(context); //instancia de skillsViewModel donde skillsVM.skills lista de skills
    
    // si cualquiera de los dos no carga simbolo de carga
    if (vm.isLoading) {
      return Center(child: CircularProgressIndicator());
    } 
    // if (skillsVM.isLoading) {
    //   return Center(child: CircularProgressIndicator());
    // }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //titulo del catalogo y foto de usuario Cuando este
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Catálogo de Tutores',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          //barra de busqueda
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                onChanged: (value) {
                  //  implementar la lógica de búsqueda
                },
                decoration: InputDecoration(
                  hintText: 'Buscar por materia o tutor',
                ),
              ),
            ),
          ),
          //Fitros
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                //label de ordenar por
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Ordenar por',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                //Botones de ordenar por
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Mejor Ratings"),
                    ),
                    ElevatedButton(onPressed: () {}, child: Text("Precio")),
                    ElevatedButton(onPressed: () {}, child: Text("Proximidad")),
                  ],
                ),

                //label de Facultad
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Facultades',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                //Botones de filtro de Facultad [mapeados]
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: facultades.map((facultad) {
                    //for i con el map pero fluter necesita una lista tonces se pasa a lista [MOCKEADO]
                    return ElevatedButton(
                      onPressed: () {},
                      child: Text(facultad),
                    );
                  }).toList(),
                ),
                //Feed de tutores (mapeados)
                ListView.builder(
                  shrinkWrap: true, //tomar espacio necesario
                  physics: NeverScrollableScrollPhysics(), // no mover scroll
                  itemCount: vm.tutors.length, //basicamente un for in range
                  itemBuilder: (context, index) {
                    // call back: context donde esta en el arbol y index ej tutor 1 2 3
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TutorCard(
                        tutor: vm.tutors[index],// recorro la lista de tutores en vm.tutors donde List<TutorSummary>
                      ), // toca decirle que parametro-> tutor:
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
