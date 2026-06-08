part of 'model_bloc.dart';

abstract base class ModelBlocEvent extends Equatable{
  const ModelBlocEvent();
}

final class ModelSetDetailEvent<DType extends BaseModel> extends ModelBlocEvent{
  final DType detail;
  const ModelSetDetailEvent(this.detail);
  @override
  List<Object?> get props => [detail];
}


final class ModelGetDetailEvent extends ModelBlocEvent{
  const ModelGetDetailEvent();
  @override
  List<Object?> get props => [];
}

final class ModelSaveEvent extends ModelBlocEvent{
  const ModelSaveEvent();
  @override
  List<Object?> get props => [];
}
final class ModelSetFieldEvent extends ModelBlocEvent{
  final String key;
  const ModelSetFieldEvent(this.key);
  @override
  List<Object?> get props => [key];
}
final class ModelSetLocalFieldEvent extends ModelBlocEvent{
  final String key;
  final dynamic value;
  const ModelSetLocalFieldEvent(this.key,this.value);
  @override
  List<Object?> get props => [key, value];
}