
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import '../repository/repository.dart';
part 'upload_state.dart';
part 'upload_event.dart';

typedef UploadRepoGetter = UploadRepo Function();
class UploadBloc extends Bloc<UploadBlocEvent, UploadState> {
  final UploadRepoGetter getRepo;

  UploadBloc({required this.getRepo,
    required String key,
    required String fieldName,
  }) :
        super(UploadState(key: key, fieldName: fieldName))
  {
    on<UploadSetInit>(_setInit);
    on<UploadResetEvent>(_setReset);
    on<UploadSetMediaEvent>(_setMedia);
    on<UploadStartEvent>(_upload);
    on<UploadSetProgressEvent>(_setPercent);
    on<UploadFinishEvent>(_finishUpload);
  }

  void _setInit(UploadSetInit event, Emitter<UploadState> emitter) async {
    emitter(state.copyWidth(
        uState: BlocUploadState.init,
        url: event.url
    ));
  }

  void _setReset(UploadResetEvent event, Emitter<UploadState> emitter) async {
    emitter(state.setInit());
  }
  void _setMedia(UploadSetMediaEvent event, Emitter<UploadState> emitter) async {
    emitter(state.setMedia(
        newMedia: event.media
    ));
    if(event.autoUpload){
      add(const UploadStartEvent());
    }
  }
  void _upload(UploadStartEvent event, Emitter<UploadState> emitter) async {
    emitter(state.copyWidth(
        uState: BlocUploadState.uploading
    ));
    if(state.media == null){
      add(UploadSetInit(state.url));
      return;
    }
    var res = await getRepo().upload(
        name: state.media!.name,
        file: state.media!.bytes!,
        fieldName: state.fieldName,
        uploadProgress: (sentBytes, totalBytes) {
          add(UploadSetProgressEvent((sentBytes/totalBytes)));
        },
    );

    if(res?.error != null){
      emitter(state.copyWidth(
          message: UploadBlocMsg(res!.error!.code, level: UploadBlocMsgLevel.error),
      ));
    }else if(res?.content != null){
      add(UploadFinishEvent(res!.content!.value));
    }
  }
  void _setPercent(UploadSetProgressEvent event, Emitter<UploadState> emitter) {
    emitter(state.copyWidth(
        uState: BlocUploadState.uploading,
        percent: event.percent
    ));
  }
  void _finishUpload(UploadFinishEvent event, Emitter<UploadState> emitter){
    emitter(state.copyWidth(
        uState: BlocUploadState.uploaded,
        url: event.url,
    ));
    emitter(state.copyWidth(
        message: const UploadBlocMsg("local.fus", level: UploadBlocMsgLevel.success),
    ));
  }


  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UploadBloc && other.state.key == state.key;
  }

  @override
  int get hashCode => state.key.hashCode;
}
