import 'package:flutter/material.dart';
import 'package:g45_flutter/services/analytics_service.dart';
import 'package:g45_flutter/viewmodels/tutor_viewmodel.dart';
import 'package:g45_flutter/widgets/tutor/tutor_card.dart';
import 'package:provider/provider.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final ScrollController _scrollController = ScrollController();

  String searchQuery = "";
  String? selectedFaculty;
  String selectedSort = "";
  String normalize(String text) {
    return text
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ñ', 'n');
  }

  final facultadesMock = [
    "Física",
    "Psicología",
    "Biología",
    "Ingeniería de Sistemas y Computación",
    "Matemáticas",
  ];

  //una vez abre el page corre todo esto
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<TutorViewModel>(context, listen: false).loadTutors();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        Provider.of<TutorViewModel>(context, listen: false).loadMoreTutors();
      }
    });
  }

  //Evitar leaks del scroll controller
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final vm = Provider.of<TutorViewModel>(
      context,
    );

    if (vm.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    final filteredTutors = vm.tutors.where((tutor) {
      final name = normalize(tutor.name ?? "");
      final major = normalize(tutor.major ?? "");
      final query = normalize(searchQuery);

      final matchesSearch = name.contains(query) || major.contains(query);

      final matchesFaculty =
          selectedFaculty == null || tutor.major == selectedFaculty;

      return matchesSearch && matchesFaculty;
    }).toList();

    filteredTutors.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));

    if (selectedSort == "rating") {
      filteredTutors.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
    } else if (selectedSort == "price") {
      filteredTutors.sort(
        (a, b) => (a.sessionPrice ?? 0).compareTo(b.sessionPrice ?? 0),
      );
    }

    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
                        color: colorScheme.onSurface),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                style: TextStyle(color: colorScheme.onSurface),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Buscar por materia o tutor',
                  hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
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
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                //Botones de ordenar por
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (selectedSort == "rating") {
                            selectedSort = "";
                          } else {
                            selectedSort = "rating";
                            AnalyticsService.instance.logEvent('filter_applied', {
                              'filter_name': 'mejor_rating',
                            });
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedSort == "rating"
                            ? colorScheme.primary
                            : colorScheme.primary.withOpacity(0.2),
                        foregroundColor: selectedSort == "rating"
                            ? colorScheme.onPrimary
                            : colorScheme.primary,
                      ),
                      child: Text("Mejor Ratings"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (selectedSort == "price") {
                            selectedSort = "";
                          } else {
                            selectedSort = "price";
                            AnalyticsService.instance.logEvent('filter_applied', {
                              'filter_name': 'precio',
                            });
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedSort == "price"
                            ? colorScheme.primary
                            : colorScheme.primary.withOpacity(0.2),
                        foregroundColor: selectedSort == "price"
                            ? colorScheme.onPrimary
                            : colorScheme.primary,
                      ),
                      child: Text("Precio"),
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
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                //Botones de filtro de Facultad [mapeados]
                SizedBox(
                  height: 45,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: facultadesMock.length,
                    itemBuilder: (context, index) {
                      final facultad = facultadesMock[index];

                      final isSelected = selectedFaculty == facultad;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (selectedFaculty == facultad) {
                                selectedFaculty = null;
                              } else {
                                selectedFaculty = facultad;
                                AnalyticsService.instance.logEvent(
                                  'filter_applied',
                                  {'filter_name': facultad},
                                );
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected
                                ? colorScheme.primary
                                : colorScheme.primary.withOpacity(0.2),
                            foregroundColor: isSelected
                                ? colorScheme.onPrimary
                                : colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 16),
                          ),
                          child: Text(facultad),
                        ),
                      );
                    },
                  ),
                ),

                //Feed de tutores (mapeados)
                ListView.builder(
                  shrinkWrap: true, //tomar espacio necesario
                  physics: NeverScrollableScrollPhysics(), // no mover scroll
                  itemCount: filteredTutors.length,
                  itemBuilder: (context, index) {
                    final tutors = filteredTutors;

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TutorCard(tutor: tutors[index]),
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
