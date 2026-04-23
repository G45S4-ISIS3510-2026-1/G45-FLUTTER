import 'package:flutter/material.dart';
import 'package:g45_flutter/viewmodels/agenda_viewmodel.dart';
import 'package:g45_flutter/views/pages/reservation/reservation_detail_page.dart';
import 'package:g45_flutter/widgets/gradient_background.dart';
import 'package:g45_flutter/widgets/session_card_widget.dart';
import 'package:provider/provider.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AgendaViewModel>(context, listen: false).loadAgenda();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AgendaViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Mi Agenda', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).colorScheme.primary,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(text: 'Clases a tomar'),
            Tab(text: 'Clases a dictar'),
          ],
        ),
      ),
      body: GradientBackground(child: SafeArea(child: _buildBody(viewModel))),
    );
  }

  Widget _buildBody(AgendaViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage != null) {
      return Center(
        child: Text(
          viewModel.errorMessage!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    return TabBarView(
      controller: _tabController,
      children: [
        // Pestaña estudiante
        _buildSessionList(viewModel.studentSessions),
        // Pestaña tutor
        _buildSessionList(viewModel.tutorSessions),
      ],
    );
  }

  Widget _buildSessionList(List<dynamic> sessions) {
    if (sessions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              size: 64,
              color: Colors.grey.withAlpha(128),
            ),
            SizedBox(height: 16),
            Text(
              'No hay sesiones programadas',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReservationDetailPage(session: session),
                ),
              );
            },
            child: SessionCardWidget(session: session),
          ),
        );
      },
    );
  }
}
