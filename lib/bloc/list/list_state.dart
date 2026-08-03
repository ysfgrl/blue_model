part of 'list_bloc.dart';


enum ListBlocDataState{
  init,
  loading,
  loaded,
  error,
}

enum ListPaginationType{
  infinity,
  pagination
}

enum ListViewType{
  dataTable,
  listView,
  sliverGrid
}

enum ListSelectMode{
  single,
  multi,
}


final class ListState<LType extends BaseModel> extends Equatable{
  final ListBlocDataState listState;
  final ListPaginationType paginationType;
  final ListViewType viewType;
  final List<LType> list;
  final List<LType> fixedTop;
  final List<LType> selected;
  final int page;
  final int pageSize;
  final int total;
  final ResponseError? message;
  final bool isOpenFilter;
  final Map<String, FilterModel> filters;
  final Map<String, dynamic> sort;
  final bool refresh;
  final ListSelectMode selectMode;

  const ListState({
    this.listState = ListBlocDataState.init,
    this.paginationType = ListPaginationType.pagination,
    this.viewType = ListViewType.dataTable,
    this.list = const [],
    this.selected = const [],
    this.fixedTop = const [],
    this.page = 1,
    this.pageSize = 10,
    this.total = 0,
    this.message,
    this.filters = const {},
    this.sort = const {},
    this.isOpenFilter = false,
    this.refresh = false,
    this.selectMode = ListSelectMode.multi
  }) ;

  @override
  List<Object?> get props => [
    listState, list, selected,refresh,
    page, pageSize, total, message, filters,sort,
    viewType, paginationType, isOpenFilter, selectMode];

  ListState<LType> copyWidth({
    ListBlocDataState? listState,
    ListViewType? viewType,
    bool? isOpenFilter,
    ListPaginationType? paginationType,
    List<LType>? list,
    List<LType>? selected,
    List<LType>? fixedTop,
    int? page,
    int? pageSize,
    int? total,
    ResponseError? message,
    String? errMsg,
    String? successMsg,
    bool? refresh,
    ListSelectMode? selectMode,
    Map<String, FilterModel>? filters,
    Map<String, dynamic>? sort
  }){
    return ListState<LType>(
      isOpenFilter: isOpenFilter ?? this.isOpenFilter,
      listState: listState ?? this.listState,
      viewType: viewType ?? this.viewType,
      paginationType: paginationType?? this.paginationType,
      list: list ?? this.list,
      selected: selected ?? this.selected,
      fixedTop: fixedTop ?? this.fixedTop,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      total: total ?? this.total,
      filters: filters ?? this.filters,
      sort: sort ?? this.sort,
      message: message,
      refresh: refresh ?? this.refresh,
      selectMode: selectMode ?? this.selectMode,
    );
  }

}
