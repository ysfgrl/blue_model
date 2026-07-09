
import 'dart:collection';

import 'package:blue_model/errors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../model/base.dart';
import '../repository/repository.dart';
import '../model/error.dart';
import '../model/list_response.dart';
import '../model/list_request.dart';
import '../model/filter.dart';
part 'list_event.dart';
part 'list_state.dart';



typedef ListShortFunc<LType extends BaseModel>  = int Function(LType a, LType b);


class ListBloc<LType extends BaseModel> extends Bloc<ListBlocEvent, ListState<LType>> {
  final ListRepoGetter<LType> getRepo;
  final RepoGetByIdGetter<LType>? getByIdRepo;
  final ListShortFunc<LType>? short;
  late final ScrollController scroll;
  late final TextEditingController searchController;
  ListBloc({
        required this.getRepo,
        this.getByIdRepo,
        Map<String, FilterModel> filters = const {},
        Map<String, dynamic> sort = const {},
        List<LType>? selected,
        List<LType>? fixedTop,
        ListPaginationType paginationType = ListPaginationType.pagination,
        ListViewType viewType = ListViewType.dataTable,
        ListSelectMode selectMode = ListSelectMode.multi,
        int? pageSize,
        this.short,
      })
      : super(ListState<LType>(
        paginationType: paginationType,
        viewType: viewType,
        filters: filters,
        selected: selected ?? <LType>[],
        fixedTop: fixedTop ?? <LType>[],
        pageSize: pageSize ?? 10,
        sort: sort,
        selectMode: selectMode
        )) {

    scroll = ScrollController();
    searchController = TextEditingController();
    on<ListGetListEvent>(_getList);
    on<ListSetListEvent<LType>>(_setList);
    on<ListUpdateItemEvent<LType>>(_updateItem);
    on<ListUpdateIndexEvent>(_updateIndex);
    on<ListAppendListEvent<LType>>(_appendList);
    on<ListAddListEvent<LType>>(_addListItem);
    on<ListAddsListEvent<LType>>(_addsListItem);
    on<ListRemoveListEvent<LType>>(_removeListItem);
    on<ListSetMessageEvent>(_setApiError);
    on<ListNextPageEvent>(_nextPage);
    on<ListPreviousPageEvent>(_previousPage);
    on<ListRefreshPageEvent>(_refresh);
    on<ListSetPageSizeEvent>(_setPageSize);
    on<ListSetFilterEvent>(_setFilterText);
    on<ListSearchValueEvent>(_setSearchValue);
    on<ListSetFilterModelEvent>(_setFilterModel);
    on<ListRemoveFilterEvent>(_removeFilter);
    on<ListSetPaginationTypeEvent>(_setPaginationType);
    on<ListSetViewTypeEvent>(_setViewType);
    on<ListSetFilterPanelStatus>(_setFilterPanel);
    on<ListSetFilterResetEvent>(_setFilterReset);
    on<ListAddSelectedEvent<LType>>(_addSelected);
    on<ListSetSelectedEvent<LType>>(_setSelected);
    on<ListRemoveSelectedEvent<LType>>(_removeSelected);
    on<ListClearSelectedEvent>(_clearSelected);
    on<ListSetSelectModeEvent>(_setSelectMode);
  }

  void _setSelectMode(ListSetSelectModeEvent event, Emitter<ListState<LType>> emitter) async{

    if(state.selectMode == event.mode){
      return;
    }
    if(event.mode == ListSelectMode.single && state.selected.length > 1){
      emitter(state.copyWidth(
        selectMode: event.mode,
        selected: <LType>[state.selected.first]
      ));
      return;
    }
    emitter(state.copyWidth(
        selectMode: event.mode,
    ));
  }

  void _clearSelected(ListClearSelectedEvent event, Emitter<ListState<LType>> emitter) async{

    if(state.selected.isNotEmpty){
      emitter(state.copyWidth(
          selected: <LType>[]
      ));
    }

  }

  void _removeSelected(ListRemoveSelectedEvent<LType> event, Emitter<ListState<LType>> emitter) async{
    final selected = List<LType>.from(state.selected);
    if(selected.contains(event.selected)){
      selected.remove(event.selected);
      emitter(state.copyWidth(
          selected: selected
      ));
    }

  }

  void _addSelected(ListAddSelectedEvent<LType> event, Emitter<ListState<LType>> emitter) async{
    if(state.selectMode == ListSelectMode.single){
      emitter(state.copyWidth(
          selected: <LType>[event.selected]
      ));
      return;
    }

    final selected = List<LType>.from(state.selected);
    if(!selected.contains(event.selected)){
      selected.add(event.selected);
      emitter(state.copyWidth(
          selected: selected
      ));
    }
  }

  void _setSelected(ListSetSelectedEvent<LType> event, Emitter<ListState<LType>> emitter) async{
    if(state.selectMode == ListSelectMode.single){
      emitter(state.copyWidth(
          selected: event.selected.isEmpty ? <LType>[] : <LType>[event.selected.first]
      ));
      return;
    }
    emitter(state.copyWidth(
        selected: event.selected
    ));
  }

  void _addListItem(ListAddListEvent<LType> event, Emitter<ListState<LType>> emitter) async{
    final newList = List<LType>.from(state.list);
    if(!newList.contains(event.item)){
      newList.add(event.item);
    }else{
      var index = newList.indexOf(event.item);
      if(index>= 0) {
        newList[index] = event.item;
      }
    }
    emitter(state.copyWidth(
        refresh: !state.refresh,
        list: newList
    ));
  }
  void _addsListItem(ListAddsListEvent<LType> event, Emitter<ListState<LType>> emitter) async{
    final newList = List<LType>.from(state.list);
    for (var value in event.list) {
      if(!newList.contains(value)){
        newList.add(value);
      }
    }
    emitter(state.copyWidth(
        list: newList
    ));
  }
  void _removeListItem(ListRemoveListEvent<LType> event, Emitter<ListState<LType>> emitter) async{

    final newList = List<LType>.from(state.list);
    if(newList.contains(event.item)){
      newList.remove(event.item);
      emitter(state.copyWidth(
          list: newList
      ));
    }

  }

  void _setPaginationType(ListSetPaginationTypeEvent event, Emitter<ListState<LType>> emitter) async{
    emitter(state.copyWidth(
        paginationType: event.paginationType
    ));
  }

  void _setViewType(ListSetViewTypeEvent event, Emitter<ListState<LType>> emitter) async{
    emitter(state.copyWidth(
        viewType: event.viewType
    ));
  }
  void _setFilterPanel(ListSetFilterPanelStatus event, Emitter<ListState<LType>> emitter) async{
    emitter(state.copyWidth(
        isOpenFilter: event.status
    ));
  }

  void _getList(ListGetListEvent event, Emitter<ListState<LType>> emitter) async{
    emitter(state.copyWidth(
        listState: ListBlocDataState.loading,
    ));
    var res = await getRepo().list(ListRequest.create(
      pageSize: state.pageSize,
      page: state.page,
      filters: state.filters,
      sort: state.sort,
    ));
    if(res?.error != null){
      add(ListSetMessageEvent(res!.error!));
      return;
    }
    if(res?.content != null){
      if(state.paginationType == ListPaginationType.pagination){
       // debugPrint("ListSetListEvent ${LType.toString()}");
        add(ListSetListEvent(res!.content!));
      }else{
        //debugPrint("ListAppendListEvent ${LType.toString()}");
        add(ListAppendListEvent(res!.content!));
      }
    }else{
      add(ListSetMessageEvent(LocalErrors.nFResponseErr));
      return;
    }

  }
  void _setList(ListSetListEvent<LType> event, Emitter<ListState<LType>> emitter) async{

    final newList = List<LType>.from(event.listResponse.list);
    for (var value in state.fixedTop) {
      newList.insert(0, value);
    }
    if(short!= null) {
      newList.sort(short);
    }
    emitter(state.copyWidth(
      listState: ListBlocDataState.loaded,
      list: newList,
      total: event.listResponse.total,
      page: event.listResponse.page,
    ));
    // debugPrint("new list ${newList}");
  }
  void _updateIndex(ListUpdateIndexEvent event, Emitter<ListState<LType>> emitter) async{
    if(event.index < state.list.length){
      add(ListUpdateItemEvent<LType>(state.list[event.index]));
    }
  }
  void _updateItem(ListUpdateItemEvent<LType> event, Emitter<ListState<LType>> emitter) async{

    if(getByIdRepo == null) return;
    var res = await getByIdRepo!().getById(event.item.toJson()["id"]);
    if(res?.error==null && res?.content!=null){
      add(ListAddListEvent<LType>(res!.content!));
    }
  }

  void _appendList(ListAppendListEvent<LType> event, Emitter<ListState<LType>> emitter) async{
    final newList = List<LType>.from(state.list);
    for (var value in event.listResponse.list) {
      if(!newList.contains(value)){
        newList.add(value);
      }
    }
    if(short!= null) {
      newList.sort(short);
    }
    emitter(state.copyWidth(
      listState: ListBlocDataState.loaded,
      list: newList,
      total: event.listResponse.total,
      page: event.listResponse.page,
    ));
  }

  void _setApiError(ListSetMessageEvent event, Emitter<ListState<LType>> emitter){
    emitter(state.copyWidth(
      listState: ListBlocDataState.error,
      message: event.msg
    ));
  }
  void _setPageSize(ListSetPageSizeEvent event, Emitter<ListState<LType>> emitter) async{
    emitter(state.copyWidth(
      pageSize: event.pageSize
    ));
    add(const ListGetListEvent());
  }

  void _refresh(ListRefreshPageEvent event, Emitter<ListState<LType>> emitter) async{
    if(state.paginationType == ListPaginationType.infinity){
      emitter(state.copyWidth(
          page: 1,
          pageSize: state.pageSize,
          list: [],
      ));
    }
    add(const ListGetListEvent());
  }
  void _previousPage(ListPreviousPageEvent event, Emitter<ListState<LType>> emitter) async{
    emitter(state.copyWidth(
        page: state.page <= 1 ? state.page : state.page -1,
        pageSize: state.pageSize
    ));
    add(const ListGetListEvent());
  }
  void _nextPage(ListNextPageEvent event, Emitter<ListState<LType>> emitter) async{
    emitter(state.copyWidth(
        page: state.page+1,
        pageSize: state.pageSize
    ));
    add(const ListGetListEvent());
  }
  void _setFilterReset(ListSetFilterResetEvent event, Emitter<ListState<LType>> emitter) async{
    final newFilters = state.filters;
    newFilters.forEach((key, value) {
      newFilters[key]!.value = null;
    },);
    emitter(state.copyWidth(
        filters: newFilters,
        page: 1,
    ));
    add(const ListRefreshPageEvent());
  }
  void _setFilterText(ListSetFilterEvent event, Emitter<ListState<LType>> emitter) async{
    final newFilters = state.filters;
    if(!newFilters.containsKey(event.key)){
      newFilters[event.key] = FilterModel.contains(
          value: event.value,
          type: FilterValueType.string
      );
    }
    newFilters[event.key]!.value = event.value;
    emitter(state.copyWidth(
        filters: newFilters,
        page: 1
    ));
    add(const ListRefreshPageEvent());
  }

  void _setSearchValue(ListSearchValueEvent event, Emitter<ListState<LType>> emitter) async{
    final newFilters = state.filters;

    if(!newFilters.containsKey("keyword") && searchController.text.isNotEmpty){
      newFilters["keyword"] = FilterModel.contains(
          value: searchController.text,
          type: FilterValueType.string
      );
    }else if(newFilters.containsKey("keyword") && searchController.text.isEmpty){
      newFilters.remove("keyword");
    }else if(newFilters.containsKey("keyword") && searchController.text.isNotEmpty){
      newFilters["keyword"]!.value = searchController.text;
    }
    emitter(state.copyWidth(
        filters: newFilters,
        page: 1
    ));
    add(const ListRefreshPageEvent());
  }

  void _setFilterModel(ListSetFilterModelEvent event, Emitter<ListState<LType>> emitter) async{
    final newFilters = state.filters;
    if(!newFilters.containsKey(event.key)){
      newFilters[event.key] = event.value;
    }
    newFilters[event.key]!.value = event.value.value;
    emitter(state.copyWidth(
        filters: newFilters,
        page: 1
    ));
    add(const ListRefreshPageEvent());
  }
  void _removeFilter(ListRemoveFilterEvent event, Emitter<ListState<LType>> emitter) async{
    final newFilters = state.filters;
    if(!newFilters.containsKey(event.key)){
      add(const ListRefreshPageEvent());
      return;
    }
    newFilters.remove(event.key);
    emitter(state.copyWidth(
        filters: newFilters,
        page: 1
    ));
    add(const ListRefreshPageEvent());
  }

}
