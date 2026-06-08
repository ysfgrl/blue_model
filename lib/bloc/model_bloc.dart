import 'package:blue_model/blue_model.dart';
import 'package:blue_model/errors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'upload_bloc.dart';
import '../model/base.dart';
import '../repository/repository.dart';
import '../model/error.dart';
part 'model_event.dart';
part 'model_state.dart';

typedef IdGetter = String? Function();

class ModelBloc<DType extends BaseModel> extends Bloc<ModelBlocEvent, ModelState<DType>> {
  final List<UploadBloc> uploads;
  final RepoEditGetter? editGetter;
  final RepoCreateGetter? createGetter;
  final RepoSetFieldGetter? setFieldGetter;
  final RepoGetByIdGetter<DType>? getByIdGetter;
  final IdGetter getId;
  ModelBloc({
    required this.getId,
    required DType info,
    this.uploads = const [],
    Map<String, dynamic>? params,
    this.getByIdGetter,
    this.editGetter,
    this.createGetter,
    this.setFieldGetter,
  }) : super(ModelState(
        info: info,
        params: params,
        infoState: BlocDataState.init
      ))
  {
    on<ModelGetDetailEvent>(_getDetail);
    on<ModelSetDetailEvent<DType>>(_setDetail);
    on<ModelSaveEvent>(_save);
    on<ModelSetFieldEvent>(_setField);
    on<ModelSetLocalFieldEvent>(_setLocalField);
  }
  GlobalKey<FormBuilderState>? _formKey;
  GlobalKey<FormBuilderState> get formKey => _formKey ??= GlobalKey<FormBuilderState>();

  void _setField(ModelSetFieldEvent event, Emitter<ModelState<DType>> emitter) async {
    try {
      if (state.infoState != BlocDataState.loaded) {
        emitter(state.copyWidth(
          message: LocalErrors.modelNotLoadedErr,
        ));
        return;
      }

      emitter(state.copyWidth(
          infoState: BlocDataState.sending
      ));
      if(formKey.currentState==null){
        emitter(state.copyWidth(
            message:  LocalErrors.formKeyNfErr
        ));
        return;
      }
      dynamic value;
      var formField =  formKey.currentState?.fields[event.key];
      var uploadIndex = uploads.indexWhere((element) => element.state.key == event.key,);
      if(uploadIndex >= 0){
        uploads[uploadIndex].add(const UploadStartEvent());
        var uploadState = await uploads[uploadIndex].stream.firstWhere((element) =>
        element.uState == BlocUploadState.uploaded ||
            element.uState == BlocUploadState.error
        );
        if (uploadState.uState == BlocUploadState.uploaded) {
          value = uploadState.url;
        } else if (uploadState.message != null) {
          emitter(state.copyWidth(
              message: LocalErrors.fileUploadErr,
              infoState: BlocDataState.loaded
          ));
          return;
        }
      }else {
        if (formField?.validate() != true) {
          emitter(state.copyWidth(
              message: LocalErrors.formValidateErr,
              infoState: BlocDataState.loaded
          ));
          return;
        }
        formField?.save();
        value = formField?.value;
      }


      var id = getId();
      if (id == null) {
        emitter(state.copyWidth(
            message: LocalErrors.idRequireErr,
            infoState: BlocDataState.loaded
        ));
        return;
      }
      if(setFieldGetter == null){
        emitter(state.copyWidth(
            message: LocalErrors.repRequireErr,
            infoState: BlocDataState.loaded
        ));
        return;
      }
      var repo = setFieldGetter!();
      var res = await repo.setField(id, event.key, value);
      if (res?.error != null) {
        emitter(state.copyWidth(
            message: res!.error,
            infoState: BlocDataState.loaded
        ));
      } else if (res?.content?.isOk == true) {
        emitter(state.copyWidth(
            message: LocalErrors.modelSaveSuccessMsg,
        ));
        add(const ModelGetDetailEvent());
      }

    }catch(ex,stackTrace){
      debugPrint("local error: $ex");
      debugPrintStack(stackTrace: stackTrace);
      emitter(state.copyWidth(
        message: LocalErrors.unexpectedErr,
        infoState: BlocDataState.loaded,
      ));
    }
  }

  void _setLocalField(ModelSetLocalFieldEvent event, Emitter<ModelState<DType>> emitter) async {

    var values = state.info.toJson();
    values[event.key] = event.value;
    DType? model = ModelFactory.modelFactory(values);
    if(model== null){
      emitter(state.copyWidth(
        message: LocalErrors.fieldNfErr
      ));
      return;
    }
    add(ModelSetDetailEvent<DType>(model));
  }

  void _save(ModelSaveEvent event, Emitter<ModelState<DType>> emitter) async {
    var id = getId();
    if(state.infoState != BlocDataState.loaded) {
      emitter(state.copyWidth(
        message: LocalErrors.modelNotLoadedErr
      ));
      return;
    }

    if(formKey.currentState==null){
      emitter(state.copyWidth(
          message:  LocalErrors.formKeyNfErr
      ));
      return;
    }
    try {
      if (!formKey.currentState!.saveAndValidate()) {
        emitter(state.copyWidth(
            message: LocalErrors.formValidateErr
        ));
        return;
      }

      emitter(state.copyWidth(
        infoState: BlocDataState.sending,
      ));
      Map<String, dynamic> modelJson = formKey.currentState!.value.map((key, value) {
          if (value.runtimeType == DateTime) {
            return MapEntry(key, DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(value));
          } else {
            return MapEntry(key, value);
          }
        },
      );

      for (var i = 0; i < uploads.length; i++) {
        if (uploads[i].state.media == null) {
          continue;
        }
        if (uploads[i].state.uState == BlocUploadState.init) {
          continue;
        }

        uploads[i].add(const UploadStartEvent());
        var uploadState = await uploads[i].stream.firstWhere((element) =>
        element.uState == BlocUploadState.uploaded ||
            element.uState == BlocUploadState.error
        );
        if (uploadState.uState == BlocUploadState.uploaded) {
          modelJson[uploadState.key] = uploadState.url;
        } else if (uploadState.message != null) {
          emitter(state.copyWidth(
              message: LocalErrors.fileUploadErr,
              infoState: BlocDataState.loaded
          ));
          return;
        }
      }
      ResponseModel<ResponseOk>? res;

      if (id != null) {
        if(editGetter != null){
          res = await editGetter!().edit(id, modelJson, params: state.params);
        }
      } else {
        if(createGetter != null){
          res = await createGetter!().create(modelJson, params: state.params);
        }
      }
      if (res?.error != null) {
        emitter(state.copyWidth(
            message: res!.error,
            infoState: BlocDataState.loaded
        ));
      } else if (res?.content != null && res?.content?.isOk == true) {
        emitter(state.copyWidth(
          message: LocalErrors.modelSaveSuccessMsg,
        ));
        add(const ModelGetDetailEvent());
      }
    } catch(ex, stackTrace){
      debugPrintStack(stackTrace: stackTrace);
      emitter(state.copyWidth(
        message: LocalErrors.unexpectedErr,
        infoState: BlocDataState.loaded,
      ));
    }
  }


  void _getDetail(ModelGetDetailEvent event, Emitter<ModelState> emitter) async{
    var id = getId();

    if(id != null) {
      emitter(state.copyWidth(
        infoState: BlocDataState.loading,
      ));
      ResponseModel<DType>? res;
      if(getByIdGetter != null){
        res = await getByIdGetter!().getById(id, params: state.params);
      }
      if (res?.error != null) {
        emitter(state.copyWidth(
            message: res!.error
        ));
        return;
      }
      if(res?.content != null) {
        add(ModelSetDetailEvent<DType>(res!.content!));
      }
    }else{
      add(ModelSetDetailEvent<DType>(state.info));
    }
  }

  void _setDetail(ModelSetDetailEvent<DType> event, Emitter<ModelState> emitter) async{

    emitter(state.copyWidth(
        infoState: BlocDataState.loaded,
        info: event.detail,
        refresh: !state.refresh
      ));
    for(var i=0; i< uploads.length; i++) {
      uploads[i].add(UploadSetInit(event.detail.toJson()[uploads[i].state.key]));
    }
    var id= getId();
    if(id != null) {
      _formKey?.currentState?.patchValue(event.detail.toJson());
    }else{
      _formKey?.currentState?.reset();
    }
  }

  @override
  Future<void> close() {
    super.close();
    for (var value in uploads) {
      value.close();
    }
    return Future.value();
  }
}
