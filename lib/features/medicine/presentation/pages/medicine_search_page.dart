// lib/features/medicine/presentation/pages/medicine_search_page.dart

import 'package:emotcare_apps/app/ui/appbar_widget.dart';
import 'package:emotcare_apps/features/medicine/domain/entities/medicine.dart'; // <-- Import Entity
import 'package:emotcare_apps/features/medicine/presentation/cubit/medicine/medicine_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart'; // <-- Import GoRouter

class MedicineSearchPage extends StatefulWidget {
  const MedicineSearchPage({super.key});

  @override
  State<MedicineSearchPage> createState() => _MedicineSearchPageState();
}

class _MedicineSearchPageState extends State<MedicineSearchPage> {
  final TextEditingController _searchController = TextEditingController();

  // Hapus dummy data (allItems)

  @override
  void initState() {
    super.initState();
    // Tambahkan listener untuk memanggil cubit saat user mengetik
    _searchController.addListener(_onSearchChanged);

    // --- PERBAIKAN: Panggil data saat halaman dimuat ---
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MedicineCubit>().fetchInitialMedicines();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    // Panggil cubit untuk mencari (Cubit akan menangani jeda/debounce)
    context.read<MedicineCubit>().searchMedicines(_searchController.text);
  }

  void _clearSearch() {
    _searchController.clear();
    // Panggil cubit dengan query kosong untuk reset
    // context.read<MedicineCubit>().searchMedicines(''); // Ini sudah otomatis ditangani listener
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarWidget(context),
      body: Column(
        children: [
          // 1. Kotak Pencarian
          _buildSearchBar(),

          // 2. Daftar Hasil (Sekarang menggunakan BlocBuilder)
          Expanded(
            child: BlocBuilder<MedicineCubit, MedicineState>(
              builder: (context, state) {
                // Saat Loading
                if (state is MedicineLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                // Saat Error
                if (state is MedicineError) {
                  return Center(child: Text(state.message));
                }
                // Saat Data Ditemukan
                if (state is MedicineLoaded) {
                  if (state.medicines.isEmpty) {
                    return const Center(child: Text('Obat tidak ditemukan.'));
                  }
                  return _buildResultsList(state.medicines);
                }
                // Tampilan awal (Initial)
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Widget untuk membuat kotak pencarian
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Cari obat...', // Tambahkan hint
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
          suffixIcon: IconButton(
            icon: Icon(Icons.close, color: Colors.grey.shade600),
            onPressed: _clearSearch,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2.0,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 10.0),
        ),
      ),
    );
  }

  /// Widget untuk membuat daftar hasil (bisa di-scroll)
  Widget _buildResultsList(List<Medicine> medicines) {
    return ListView.builder(
      itemCount: medicines.length,
      itemBuilder: (context, index) {
        final item = medicines[index];
        // Panggil widget terpisah untuk setiap item
        return _buildListItem(item: item);
      },
    );
  }

  /// Widget untuk satu baris item di daftar
  Widget _buildListItem({required Medicine item}) {
    // --- PERBAIKAN: Dibungkus dengan InkWell ---
    return InkWell(
      onTap: () {
        context.pushNamed('add_medicine', extra: item);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.type, // <-- Gunakan data dari entity
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  item.name, // <-- Gunakan data dari entity
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(color: Colors.grey.shade300, height: 1),
          ),
        ],
      ),
    );
  }
}
