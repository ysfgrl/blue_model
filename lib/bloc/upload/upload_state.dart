part of 'upload_bloc.dart';


enum BlocUploadState{
  init,
  selected,
  uploading,
  uploaded,
  error,
}


enum UploadBlocMsgLevel{
  error,
  success,
  info
}
class UploadBlocMsg{
  final UploadBlocMsgLevel level;
  final String msg;
  const UploadBlocMsg(this.msg, {this.level = UploadBlocMsgLevel.info});
}


class UploadState extends Equatable {

  final BlocUploadState uState;
  final String? url;
  final String key;
  final String fieldName;
  final double percent;
  final UploadBlocMsg? message;
  final PlatformFile? media;
  final bool refresh;
  const UploadState({
    this.url,
    required this.key,
    required this.fieldName,
    this.uState = BlocUploadState.init,
    this.message,
    this.media,
    this.percent = 0,
    this.refresh = false
  });
  @override
  List<Object?> get props => [uState,media, message, percent, url, refresh];

  UploadState copyWidth({
    BlocUploadState? uState,
    UploadBlocMsg? message,
    String? url,
    double? percent
  }){
    debugPrint("copyWidth;");
    return UploadState(
        uState: uState ?? this.uState,
      url: url ?? this.url,
      key: key,
      fieldName: fieldName,
      message: message,
      media: uState == BlocUploadState.init ? null: media,
      percent: percent ?? this.percent
    );
  }

  UploadState setMedia({
    PlatformFile? newMedia,
  }){
    debugPrint("setMedia;");
    return UploadState(
        uState: BlocUploadState.selected,
        url: this.url,
        key: key,
        fieldName: fieldName,
        media: newMedia,
        message: message,
        percent: 0
    );
  }
  UploadState setInit(){
    debugPrint("setInit;");
    return UploadState(
        uState: BlocUploadState.init,
        url: url,
        key: key,
        fieldName: fieldName,
        media: null,
        message: null,
        percent: 0,
        refresh: !refresh
    );
  }

  Widget preview(){
    if(media == null){
      return const Icon(
        Icons.not_interested,
        size: 42,
      );
    }
    return Image.memory(
      media!.bytes!,
      fit: BoxFit.fill,
      errorBuilder: (context, error, stackTrace) => Icon(
        Icons.not_interested,
        size: 42,
      ),
    );

  }
}
