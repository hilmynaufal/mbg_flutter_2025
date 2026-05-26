import 'dart:developer';

import 'package:get/get.dart';
import '../../../data/models/sppg_item_model.dart';
import '../../../data/models/sppg_detail_model.dart';
import '../../../data/models/sppg_mbg_item_model.dart';
import '../../../data/providers/form_provider.dart';

class SppgListController extends GetxController {
  final FormProvider _formProvider = FormProvider();

  // Observable states
  final RxList<SppgItemModel> allSppgList = <SppgItemModel>[].obs;
  final RxList<SppgItemModel> filteredSppgList = <SppgItemModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt viewMode = 1.obs; // 0 for Peta, 1 for List

  // Filter and search states
  final RxString selectedKecamatan = 'Semua'.obs;
  final RxString selectedDesa = 'Semua'.obs;
  final RxString searchQuery = ''.obs;
  final RxList<String> kecamatanList = <String>['Semua'].obs;
  final RxList<String> desaList = <String>['Semua'].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSppgList();
  }

  /// Fetch and merge SPPG data from two endpoints:
  /// Primary: /data/mbg---sppg (complete list, no photos/coordinates)
  /// Enrichment: /data/pendataan-profil-sppg-aktif-... (photos + coordinates)
  /// Items are matched by name (case-insensitive, trimmed).
  Future<void> fetchSppgList() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Start both requests in parallel
      final mbgFuture = _formProvider.getMbgSppgList();
      final enrichFuture = _formProvider.getSppgList();

      // Await primary source (required)
      final mbgResponse = await mbgFuture;
      if (!mbgResponse.isSuccess) {
        errorMessage.value = mbgResponse.message;
        return;
      }

      log('[SPPG] Primary endpoint: ${mbgResponse.total} total, ${mbgResponse.data.length} loaded');

      // Await enrichment source (optional — proceed without it on failure)
      final enrichmentMap = <String, SppgDetailModel>{};
      try {
        final enrichResponse = await enrichFuture;
        log('[SPPG] Enrichment endpoint: total=${enrichResponse.total}, loaded=${enrichResponse.data.length}, success=${enrichResponse.isSuccess}');
        if (enrichResponse.isSuccess) {
          for (final item in enrichResponse.data) {
            final key = item.detail.namaSppg.trim().toLowerCase();
            if (key.isNotEmpty) {
              enrichmentMap[key] = item.detail;
            }
          }
          log('[SPPG] Enrichment map built: ${enrichmentMap.length} entries');
          // Sample first 3 keys to verify format
          final sample = enrichmentMap.keys.take(3).toList();
          log('[SPPG] Enrichment sample keys: $sample');
        }
      } catch (e) {
        log('[SPPG] Enrichment data unavailable: $e');
      }

      // Merge: map each MBG item to SppgItemModel, injecting photo+coordinate if matched
      int matchedCount = 0;
      int unmatchedCount = 0;
      final mergedList = mbgResponse.data.map((mbg) {
        final key = mbg.detail.normalizedNama;
        final enrichment = enrichmentMap[key];
        if (enrichment != null) {
          matchedCount++;
        } else {
          unmatchedCount++;
          if (unmatchedCount <= 5) {
            log('[SPPG] No match for: "${mbg.detail.nama}" (key="$key")');
          }
        }
        return _convertToSppgItem(mbg, enrichment);
      }).toList();

      log('[SPPG] Merge result: $matchedCount matched, $unmatchedCount unmatched');

      allSppgList.value = mergedList;

      // Extract unique kecamatan for filter
      final kecamatanSet = <String>{};
      for (var sppg in mergedList) {
        if (sppg.detail.kecamatan.isNotEmpty) {
          kecamatanSet.add(sppg.detail.kecamatan);
        }
      }
      kecamatanList.value = ['Semua', ...kecamatanSet.toList()..sort()];

      updateDesaList();
      applyFilter();
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  /// Convert MBG item + optional enrichment into the unified SppgItemModel.
  /// Maps "Beroperasi" → "aktif" so isActive getter works correctly.
  SppgItemModel _convertToSppgItem(
      SppgMbgItemModel mbg, SppgDetailModel? enrichment) {
    final statusSppg =
        mbg.detail.status.toLowerCase() == 'beroperasi' ? 'aktif' : mbg.detail.status.toLowerCase();

    return SppgItemModel(
      id: mbg.id,
      status: mbg.status,
      departmentId: mbg.departmentId,
      departmentNama: mbg.departmentNama,
      asistantNama: mbg.asistantNama,
      createdBy: mbg.createdBy,
      createdAt: mbg.createdAt,
      updatedBy: mbg.updatedBy,
      updatedAt: mbg.updatedAt,
      detail: SppgDetailModel(
        tanggalLaporan: enrichment?.tanggalLaporan ?? mbg.createdAt,
        namaLengkap: enrichment?.namaLengkap ?? '',
        noHp: enrichment?.noHp ?? 0,
        namaSppg: mbg.detail.nama,
        namaMitraAtauYayasan: mbg.detail.yayasan,
        kecamatan: mbg.detail.kecamatan,
        desa: mbg.detail.desa,
        alamatLengkapLokasi: mbg.detail.alamat,
        titikLokasi: enrichment?.titikLokasi ?? '',
        namaKetuaSppg: mbg.detail.namaKaSppg,
        noWhatsappKetuaSppg: enrichment?.noWhatsappKetuaSppg ?? 0,
        status: mbg.detail.jenis,
        statusSppg: statusSppg,
        fotoSppgTampakDepan: enrichment?.fotoSppgTampakDepan ?? '',
        fotoSppgTampakDalam: enrichment?.fotoSppgTampakDalam ?? '',
        fotoSppgTampakDapur: enrichment?.fotoSppgTampakDapur ?? '',
        suplaiMakanan: enrichment?.suplaiMakanan ?? '',
        totalProduksi: enrichment?.totalProduksi ?? 0,
      ),
    );
  }

  /// Refresh list (pull to refresh)
  Future<void> refreshList() async {
    await fetchSppgList();
  }

  /// Apply filter and search
  void applyFilter() {
    var tempList = allSppgList.toList();

    // Filter by Kecamatan
    if (selectedKecamatan.value != 'Semua') {
      tempList = tempList
          .where((sppg) => sppg.detail.kecamatan == selectedKecamatan.value)
          .toList();
    }

    // Filter by Desa
    if (selectedDesa.value != 'Semua') {
      tempList = tempList
          .where((sppg) => sppg.detail.desa == selectedDesa.value)
          .toList();
    }

    // Search by nama SPPG
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      tempList = tempList
          .where((sppg) =>
              sppg.detail.namaSppg.toLowerCase().contains(query) ||
              sppg.detail.desa.toLowerCase().contains(query) ||
              sppg.detail.kecamatan.toLowerCase().contains(query))
          .toList();
    }

    // Items with photos first
    tempList.sort((a, b) {
      final aHasPhoto = a.detail.fotoSppgTampakDepan.isNotEmpty ? 0 : 1;
      final bHasPhoto = b.detail.fotoSppgTampakDepan.isNotEmpty ? 0 : 1;
      return aHasPhoto.compareTo(bHasPhoto);
    });

    filteredSppgList.value = tempList;
  }

  /// Set filter kecamatan
  void setKecamatanFilter(String kecamatan) {
    selectedKecamatan.value = kecamatan;
    selectedDesa.value = 'Semua';
    updateDesaList();
    applyFilter();
  }

  /// Set filter desa
  void setDesaFilter(String desa) {
    selectedDesa.value = desa;
    applyFilter();
  }

  void updateDesaList() {
    final desaSet = <String>{};
    var sourceList = allSppgList.toList();

    if (selectedKecamatan.value != 'Semua') {
      sourceList = sourceList
          .where((sppg) => sppg.detail.kecamatan == selectedKecamatan.value)
          .toList();
    }

    for (var sppg in sourceList) {
      if (sppg.detail.desa.isNotEmpty) {
        desaSet.add(sppg.detail.desa);
      }
    }
    desaList.value = ['Semua', ...desaSet.toList()..sort()];
  }

  /// Set search query
  void setSearchQuery(String query) {
    searchQuery.value = query;
    applyFilter();
  }

  /// Clear filters
  void clearFilters() {
    selectedKecamatan.value = 'Semua';
    selectedDesa.value = 'Semua';
    searchQuery.value = '';
    updateDesaList();
    applyFilter();
  }

  /// Get total count
  int get totalCount => allSppgList.length;

  /// Get filtered count
  int get filteredCount => filteredSppgList.length;

  /// Check if filters are active
  bool get hasActiveFilters =>
      selectedKecamatan.value != 'Semua' ||
      selectedDesa.value != 'Semua' ||
      searchQuery.value.isNotEmpty;
}
