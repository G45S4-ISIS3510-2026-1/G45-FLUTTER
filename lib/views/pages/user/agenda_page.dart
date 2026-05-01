import 'package:flutter/material.dart';
import 'package:g45_flutter/data/notifiers.dart';
import 'package:g45_flutter/models/session.dart';
import 'package:g45_flutter/viewmodels/agenda_viewmodel.dart';
import 'package:g45_flutter/viewmodels/auth.dart';
import 'package:g45_flutter/views/pages/reservation/reservation_detail_page.dart';
import 'package:g45_flutter/widgets/date_card_widget.dart';
import 'package:g45_flutter/widgets/gradient_background.dart';
import 'package:g45_flutter/widgets/session_card_widget.dart';
import 'package:provider/provider.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  late DateTime _selectedDate;
  late DateTime _weekStart;

  static const _months = [
    'Enero','Febrero','Marzo','Abril','Mayo','Junio',
    'Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre',
  ];

  static const _dayFull = [
    'Lunes','Martes','Miércoles','Jueves','Viernes','Sábado','Domingo',
  ];

  @override
  void initState() {
    super.initState();

    final today = DateTime.now();
    _selectedDate = DateTime(today.year, today.month, today.day);
    _weekStart = DateTime(
      today.year,
      today.month,
      today.day - (today.weekday - 1),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AgendaViewModel>(context, listen: false).loadAgenda();
    });

    selectedPageNotifier.addListener(onTabChanged);
  }

  void onTabChanged() {
    if (selectedPageNotifier.value == 2 && mounted) {
      Provider.of<AgendaViewModel>(context, listen: false).loadAgenda();
    }
  }

  @override
  void dispose() {
    selectedPageNotifier.removeListener(onTabChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final viewModel = Provider.of<AgendaViewModel>(context);
    final userId = AuthViewModel.instance.userCache?.id ?? '';

    final weekDays = List.generate(7, (i) {
      final d = _weekStart.add(Duration(days: i));
      return DateTime(d.year, d.month, d.day);
    });

    final filtered = viewModel.allSessions.where((s) {
      final d = s.scheduledAt;
      return d.year == _selectedDate.year &&
          d.month == _selectedDate.month &&
          d.day == _selectedDate.day;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          'Mi Agenda',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 🔹 HEADER MES
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 8, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_months[_selectedDate.month - 1]}, ${_selectedDate.year}',
                      style: TextStyle(
                        color: colors.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.chevron_left,
                              color: colors.onSurfaceVariant),
                          onPressed: () => setState(() =>
                              _weekStart = _weekStart.subtract(const Duration(days: 7))),
                        ),
                        IconButton(
                          icon: Icon(Icons.chevron_right,
                              color: colors.onSurfaceVariant),
                          onPressed: () => setState(() =>
                              _weekStart = _weekStart.add(const Duration(days: 7))),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 🔹 DÍAS
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: weekDays.map((date) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: DateCardWidget(
                        date: date,
                        selectedDate: _selectedDate,
                        onSelected: (d) =>
                            setState(() => _selectedDate = d),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 12),

              // 🔹 TEXTO FECHA + COUNT
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_dayFull[_selectedDate.weekday - 1]}, ${_selectedDate.day} de ${_months[_selectedDate.month - 1]}',
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                    if (!viewModel.isLoading)
                      Text(
                        '${filtered.length} SESIONES',
                        style: TextStyle(
                          color: colors.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              Expanded(
                child: _buildList(viewModel, filtered, userId),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(
      AgendaViewModel viewModel,
      List<Session> filtered,
      String userId,
      ) {
    final colors = Theme.of(context).colorScheme;

    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage != null) {
      return Center(
        child: Text(
          viewModel.errorMessage!,
          style: TextStyle(color: colors.error),
        ),
      );
    }

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              size: 64,
              color: colors.onSurfaceVariant.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay sesiones para este día',
              style: TextStyle(
                color: colors.onSurfaceVariant,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final session = filtered[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ReservationDetailPage(session: session),
              ),
            ),
            child: SessionCardWidget(
              session: session,
              isTutor: session.tutorId == userId,
            ),
          ),
        );
      },
    );
  }
}