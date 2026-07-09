part of 'list_bloc.dart';


abstract base class ListBlocEvent extends Equatable{
  const ListBlocEvent();
}
final class ListSetMessageEvent extends ListBlocEvent{
  final ResponseError msg;
  const ListSetMessageEvent(this.msg);
  @override
  List<Object?> get props => [msg];
}


final class ListGetListEvent extends ListBlocEvent{
  const ListGetListEvent();
  @override
  List<Object?> get props => [];
}

final class ListSetListEvent<ListType extends BaseModel> extends ListBlocEvent{
  final ListResponse<ListType> listResponse;
  const ListSetListEvent(this.listResponse);
  @override
  List<Object?> get props => [listResponse];
}
final class ListUpdateItemEvent<ListType extends BaseModel> extends ListBlocEvent{
  final ListType item;
  const ListUpdateItemEvent(this.item);
  @override
  List<Object?> get props => [item];
}
final class ListUpdateIndexEvent extends ListBlocEvent{
  final int index;
  const ListUpdateIndexEvent(this.index);
  @override
  List<Object?> get props => [index];
}
final class ListAppendListEvent<ListType extends BaseModel> extends ListBlocEvent{
  final ListResponse<ListType> listResponse;
  const ListAppendListEvent(this.listResponse);
  @override
  List<Object?> get props => [listResponse];
}
final class ListAddListEvent<ListType extends BaseModel> extends ListBlocEvent{
  final ListType item;
  const ListAddListEvent(this.item);
  @override
  List<Object?> get props => [item];
}
final class ListAddsListEvent<ListType extends BaseModel> extends ListBlocEvent{
  final List<ListType> list;
  const ListAddsListEvent(this.list);
  @override
  List<Object?> get props => [list];
}
final class ListRemoveListEvent<ListType extends BaseModel> extends ListBlocEvent{
  final ListType item;
  const ListRemoveListEvent(this.item);
  @override
  List<Object?> get props => [item];
}
final class ListSetSelectModeEvent extends ListBlocEvent{
  final ListSelectMode mode;
  const ListSetSelectModeEvent(this.mode);
  @override
  List<Object?> get props => [mode];
}

final class ListClearSelectedEvent extends ListBlocEvent{
  const ListClearSelectedEvent();
  @override
  List<Object?> get props => [];
}

final class ListAddSelectedEvent<ListType extends BaseModel> extends ListBlocEvent{
  final ListType selected;
  const ListAddSelectedEvent(this.selected);
  @override
  List<Object?> get props => [selected];
}

final class ListSetSelectedEvent<ListType extends BaseModel> extends ListBlocEvent{
  final List<ListType> selected;
  const ListSetSelectedEvent(this.selected);
  @override
  List<Object?> get props => [selected];
}

final class ListRemoveSelectedEvent<ListType extends BaseModel> extends ListBlocEvent{
  final ListType selected;
  const ListRemoveSelectedEvent(this.selected);
  @override
  List<Object?> get props => [selected];
}


final class ListNextPageEvent extends ListBlocEvent{
  const ListNextPageEvent();
  @override
  List<Object?> get props => [];
}
final class ListPreviousPageEvent extends ListBlocEvent{
  const ListPreviousPageEvent();
  @override
  List<Object?> get props => [];
}
final class ListRefreshPageEvent extends ListBlocEvent{
  const ListRefreshPageEvent();
  @override
  List<Object?> get props => [];
}
final class ListSetPageSizeEvent extends ListBlocEvent{
  final int pageSize;
  const ListSetPageSizeEvent(this.pageSize);
  @override
  List<Object?> get props => [pageSize];
}
final class ListSetViewTypeEvent extends ListBlocEvent{
  final ListViewType viewType;
  const ListSetViewTypeEvent(this.viewType);
  @override
  List<Object?> get props => [viewType];
}
final class ListSetFilterResetEvent extends ListBlocEvent{
  const ListSetFilterResetEvent();
  @override
  List<Object?> get props => [];
}
final class ListSetFilterPanelStatus extends ListBlocEvent{
  final bool status;
  const ListSetFilterPanelStatus(this.status);
  @override
  List<Object?> get props => [status];
}
final class ListSetPaginationTypeEvent extends ListBlocEvent{
  final ListPaginationType paginationType;
  const ListSetPaginationTypeEvent(this.paginationType);
  @override
  List<Object?> get props => [paginationType];
}
final class ListSetFilterEvent extends ListBlocEvent{
  final String key;
  final dynamic value;
  const ListSetFilterEvent(this.key, this.value);
  @override
  List<Object?> get props => [key, value];
}
final class ListSearchValueEvent extends ListBlocEvent{
  const ListSearchValueEvent();
  @override
  List<Object?> get props => [];
}
final class ListSetFilterModelEvent extends ListBlocEvent{
  final String key;
  final FilterModel value;
  const ListSetFilterModelEvent(this.key, this.value);
  @override
  List<Object?> get props => [key, value];
}
final class ListRemoveFilterEvent extends ListBlocEvent{
  final String key;
  const ListRemoveFilterEvent(this.key);
  @override
  List<Object?> get props => [key];
}