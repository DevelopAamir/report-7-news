import '../services/localstorage_service.dart';

class SearchHistoryRepository{

  final String _storageKey = 'search_histories';
  final LocalStorageService _storageService = LocalStorageService();

  Future<void> addToSearchHistories(String term) async {
    try{
      List<String> _list = await getSearchHistories();
      if(!_list.contains(term)){
        _list.add(term);
        await saveSearchHistories(_list);
      }
    }catch(e){
      print(e);
    }
  }

  Future<void> saveSearchHistories(List<String> terms) async {
    try{
      await _storageService.saveToStorage<List<String>>(_storageKey, terms);
    }catch(e){
      print(e);
    }
  }

  Future<List<String>> getSearchHistories() async {
    try{
      final _histories = await _storageService.getFromStorage(_storageKey);
      return (_histories != null) ? List<String>.from((_histories as List).map((item) => item.toString())).reversed.toList() : [];
    }catch(e){
      print(e);
      return [];
    }
  }

  Future<bool> clearSearchHistories() async {
    try{
      await _storageService.remove(_storageKey);
      return true;
    }catch(e){
      print(e);
      return false;
    }
  }

}