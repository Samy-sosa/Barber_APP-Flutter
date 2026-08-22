import 'package:flutter/material.dart';
import '../../models/barbershop/barbershop_response.dart';
import '../../services/barbershop_service.dart';

class BarbershopListScreen extends StatefulWidget {
  const BarbershopListScreen({super.key});

  @override
  State<BarbershopListScreen> createState() => _BarbershopListScreenState();
}

class _BarbershopListScreenState extends State<BarbershopListScreen> {
  final BarbershopService _service = BarbershopService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Barberías Disponibles')),
      body: FutureBuilder<List<BarbershopResponse>>(
        future: _service.getBarbershops(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final list = snapshot.data ?? [];
          if (list.isEmpty) {
            return const Center(child: Text('No hay barberías registradas.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.store)),
                  title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${item.municipality} • ${item.address ?? "Sin dirección"}'),
                  trailing: const Icon(Icons.chevron_right),
                ),
              );
            },
          );
        },
      ),
    );
  }
}