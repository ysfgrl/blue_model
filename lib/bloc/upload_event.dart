part of 'upload_bloc.dart';

abstract base class UploadBlocEvent extends Equatable{
  const UploadBlocEvent();
}


final class UploadSetMediaEvent extends UploadBlocEvent{
  final PlatformFile? media;
  final bool autoUpload;
  const UploadSetMediaEvent(this.media, this.autoUpload);
  @override
  List<Object?> get props => [media, autoUpload];
}
final class UploadSetInit extends UploadBlocEvent{
  final String? url;
  const UploadSetInit(this.url);
  @override
  List<Object?> get props => [url];
}
final class UploadResetEvent extends UploadBlocEvent{
  const UploadResetEvent();
  @override
  List<Object?> get props => [];
}
final class UploadStartEvent extends UploadBlocEvent{
  const UploadStartEvent();
  @override
  List<Object?> get props => [];
}
final class UploadFinishEvent extends UploadBlocEvent{
  final String url;
  const UploadFinishEvent(this.url);
  @override
  List<Object?> get props => [url];
}
final class UploadSetProgressEvent extends UploadBlocEvent{
  final double percent;
  const UploadSetProgressEvent(this.percent);
  @override
  List<Object?> get props => [percent];
}