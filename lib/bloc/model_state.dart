part of 'model_bloc.dart';

enum BlocDataState{
  init,
  loading,
  sending,
  loaded,
}


class ModelState<DType extends BaseModel> extends Equatable {
  final BlocDataState infoState;
  final DType info;
  final ResponseError? message;
  final bool refresh;
  final Map<String, dynamic>? params;
  const ModelState({
    this.infoState = BlocDataState.init,
    required this.info,
    this.message,
    this.params,
    this.refresh = false,
  });
  @override
  List<Object?> get props => [refresh,infoState, info, message];

  ModelState<DType> copyWidth({
    BlocDataState? infoState,
    DType? info,
    String? id,
    ResponseError? message,
    bool? readyShow,
    bool? refresh,
  }){
    return ModelState<DType>(
      infoState: infoState ?? this.infoState,
      info: info ?? this.info,
      refresh: refresh ?? this.refresh,
      message: message,
      params: params
    );
  }
}
