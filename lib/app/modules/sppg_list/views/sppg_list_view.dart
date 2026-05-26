import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/sppg_list_controller.dart';
import 'widgets/sppg_list_card.dart';
import 'widgets/sppg_map_view.dart';

class SppgListView extends GetView<SppgListController> {
  const SppgListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildViewToggle(),
            Expanded(
              child: Obx(
                () {
                  if (controller.isLoading.value &&
                      controller.allSppgList.isEmpty) {
                    return Center(
                      child: SpinKitFadingCircle(
                        color: AppColors.primary,
                        size: 50.0,
                      ),
                    );
                  }

                  if (controller.errorMessage.isNotEmpty &&
                      controller.allSppgList.isEmpty) {
                    return _buildErrorState();
                  }

                  if (controller.allSppgList.isEmpty) {
                    return _buildEmptyState();
                  }

                  return IndexedStack(
                    index: controller.viewMode.value,
                    children: [
                      _buildMapTab(),
                      _buildListTab(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 20, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => Get.back(),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lokasi SPPG',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Daftar SPPG di Kabupaten Bandung',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggle() {
    return Obx(() => Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildToggleButton(
                  icon: Icons.map_outlined,
                  label: 'Peta',
                  isActive: controller.viewMode.value == 0,
                  onTap: () => controller.viewMode.value = 0,
                ),
              ),
              Expanded(
                child: _buildToggleButton(
                  icon: Icons.format_list_bulleted,
                  label: 'Daftar SPPG',
                  isActive: controller.viewMode.value == 1,
                  onTap: () => controller.viewMode.value = 1,
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildToggleButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? Colors.indigo : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? Colors.indigo : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: controller.fetchSppgList,
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Belum ada data SPPG',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildListTab() {
    return Column(
      children: [
        _buildSearchField(),
        _buildFilters(),
        Expanded(
          child: Obx(() {
            if (controller.filteredSppgList.isEmpty) {
              return _buildSearchEmptyState();
            }

            return RefreshIndicator(
              onRefresh: controller.refreshList,
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                itemCount: controller.filteredSppgList.length,
                itemBuilder: (context, index) {
                  final sppg = controller.filteredSppgList[index];
                  return SppgListCard(sppg: sppg);
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Row(
        children: [
          Expanded(
            child: Obx(() => _buildDropdownFilter(
                  value: controller.selectedKecamatan.value,
                  items: controller.kecamatanList,
                  label: 'Kecamatan',
                  onChanged: (val) => controller.setKecamatanFilter(val!),
                )),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Obx(() => _buildDropdownFilter(
                  value: controller.selectedDesa.value,
                  items: controller.desaList,
                  label: 'Desa',
                  onChanged: (val) => controller.setDesaFilter(val!),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownFilter({
    required String value,
    required List<String> items,
    required String label,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down,
              size: 20, color: Colors.indigo.shade300),
          style: const TextStyle(color: Colors.black87, fontSize: 13),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, maxLines: 1, overflow: TextOverflow.ellipsis),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: TextField(
        onChanged: controller.setSearchQuery,
        decoration: InputDecoration(
          hintText: 'Cari nama SPPG, desa...',
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          prefixIcon: const Icon(Icons.search, size: 20),
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }

  Widget _buildSearchEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[200]),
          const SizedBox(height: 16),
          Text(
            'Tidak ada SPPG yang sesuai',
            style: TextStyle(color: Colors.grey[400]),
          ),
          TextButton(
            onPressed: controller.clearFilters,
            child: const Text('Reset Filter'),
          ),
        ],
      ),
    );
  }

  Widget _buildMapTab() {
    return SppgMapView(sppgList: controller.filteredSppgList);
  }
}
