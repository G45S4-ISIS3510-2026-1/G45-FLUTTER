import 'package:flutter/material.dart';
import 'package:g45_flutter/widgets/tutor_card.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  //variables y datos mockeados
  
  //Mocks:
    //Lista de facultades mockeada
    List<String> facultades = ["Ingeniería", "Ciencias", "Economía", "Artes"];
    //Lista de tutores mockeada
    List<Map<String, dynamic>> tutores = [
  {
    "name": "Camilo Rivas",
    "major": "Ingeniería",
    "price": "35k/h",
    "rating": "4.9",
    "tutoring_skills": ["Cálculo", "Python"],
    "image": "https://i.pravatar.cc/150?img=1"
  },
  {
    "name": "Ana Torres",
    "major": "Ciencias",
    "price": "30k/h",
    "rating": "4.7",
    "tutoring_skills": ["Química", "Biología"],
    "image": "https://i.pravatar.cc/150?img=2"
  }
];

  @override
  Widget build(BuildContext context) {
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
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
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
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Proximidad"),
                    ),
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
                  children: facultades.map((facultad) {//for i con el map pero fluter necesita una lista tonces se pasa a lista
                    return ElevatedButton(
                      onPressed: () {},
                      child: Text(facultad),
                    );
                  }).toList(),
                ),
                //Feed de tutores (mapeados)
                ListView.builder(
                  shrinkWrap: true,//tomar espacio necesario
                  physics: NeverScrollableScrollPhysics(),// no mover scroll
                  itemCount: tutores.length,//basicamente un for in range
                  itemBuilder: (context, index) {// call back: context donde esta en el arbol y index ej tutor 1 2 3 
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TutorCard(tutor: tutores[index]),// toca decirle que parametro-> tutor:
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
