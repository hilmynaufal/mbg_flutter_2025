import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/sppg_list_controller.dart';
import 'widgets/sppg_list_card.dart';
import 'widgets/sppg_map_view.dart';

class SppgListView extends GetView<SppgListController> {
  const SppgListView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Daftar SPPG'),
          centerTitle: true,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
            tabs: const [
              Tab(icon: Icon(Icons.list), text: 'List'),
              Tab(icon: Icon(Icons.map), text: 'Peta'),
            ],
          ),
        ),
        body: Obx(
          () {
            // Loading state
            if (controller.isLoading.value && controller.allSppgList.isEmpty) {
              return Center(
                child: SpinKitFadingCircle(
                  color: AppColors.primary,
                  size: 50.0,
                ),
              );
            }

            // Error state
            if (controller.errorMessage.isNotEmpty &&
                controller.allSppgList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 80,
                      color: Colors.red[300],
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        controller.errorMessage.value,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: controller.fetchSppgList,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }

            // Empty state
            if (controller.allSppgList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 80,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Belum ada data SPPG',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }

            // Content
            return TabBarView(
              children: [
                _buildListTab(),
                _buildMapTab(),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Build List Tab
  Widget _buildListTab() {
    return Column(
      children: [
        // Filter and Search Section
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          child: Column(
            children: [
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Cari nama SPPG, desa...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: Obx(() => controller.searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => controller.setSearchQuery(''),
                        )
                      : const SizedBox.shrink()),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onChanged: controller.setSearchQuery,
              ),
              const SizedBox(height: 12),

              // Kecamatan Filter Dropdown
              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: controller.selectedKecamatan.value,
                        decoration: InputDecoration(
                          labelText: 'Filter Kecamatan',
                          prefixIcon: const Icon(Icons.location_on),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        items: controller.kecamatanList
                            .map(
                              (kec) => DropdownMenuItem(
                                value: kec,
                                child: Text(kec),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            controller.setKecamatanFilter(value);
                          }
                        },
                      ),
                    ),
                    if (controller.hasActiveFilters) ...[
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: controller.clearFilters,
                        icon: const Icon(Icons.filter_alt_off),
                        tooltip: 'Clear Filters',
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.red[50],
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),

        // Count Badge
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.primary.withValues(alpha: 0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Menampilkan ${controller.filteredCount} dari ${controller.totalCount} SPPG',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (controller.hasActiveFilters)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Filter Aktif',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // List Content
        Expanded(
          child: Obx(
            () {
              if (controller.filteredSppgList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 80,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Tidak ada SPPG yang sesuai',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: controller.clearFilters,
                        child: const Text('Reset Filter'),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshList,
                color: AppColors.primary,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.filteredSppgList.length,
                  itemBuilder: (context, index) {
                    final sppg = controller.filteredSppgList[index];
                    return SppgListCard(sppg: sppg);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Build Map Tab
  Widget _buildMapTab() {
    return Obx(
      () {
        if (controller.filteredSppgList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.map_outlined,
                  size: 80,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'Tidak ada lokasi SPPG untuk ditampilkan',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return SppgMapView(sppgList: controller.filteredSppgList);
      },
    );
  }
}
