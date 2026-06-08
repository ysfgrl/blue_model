
import 'dart:io';

import 'package:blue_model/blue_model.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';


enum FilePreviewAlign{
  left,
  top,
  bottom,
}


class FormBuilderFile extends StatelessWidget{
  final String name;
  final bool autoUpload;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final List<String>? allowedExt;
  final String? initialValue;
  final UploadBloc uploadBloc;
  final InputDecoration decoration;
  final void Function(UploadBlocMsg msg)? msgListener;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode autovalidateMode;
  final bool imagePreview;
  final bool withData;
  final FilePreviewAlign previewAlign;
  final BoxConstraints previewConstraints;
  final GlobalKey<FormFieldState<String?>> inputKey = GlobalKey();
  FormBuilderFile({
    super.key,
    required this.name,
    required this.uploadBloc,
    this.onChanged,
    this.onSaved,
    this.initialValue,
    this.allowedExt,
    this.autoUpload = false,
    this.decoration = const InputDecoration(labelText: "form.input.file",),
    this.previewAlign = FilePreviewAlign.left,
    this.msgListener,
    this.imagePreview = false,
    this.previewConstraints = const BoxConstraints(
      maxHeight: 40,
      maxWidth: 40
    ),
    this.validator,
    this.withData = true,
    this.autovalidateMode = AutovalidateMode.disabled,
  });
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UploadBloc, UploadState>(
      bloc: uploadBloc,
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if(previewAlign == FilePreviewAlign.top)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ConstrainedBox(
                      constraints: previewConstraints,
                      child: preview(),
                    ),
                    SizedBox(height: 10,)
                  ],
                ),
              ),
            FormBuilderTextField(
              key: inputKey,
              onChanged: (value) {
                if(onChanged!= null) onChanged!(value);
              },
              onSaved: (value){
                if(onSaved!= null) onSaved!(value);
              },
              name: name,
              onReset: () {

              },
              initialValue: initialValue,
              validator: validator,
              autovalidateMode: autovalidateMode,
              decoration: decoration.copyWith(
                  prefixIcon: previewAlign == FilePreviewAlign.left ? Padding(
                    padding: EdgeInsets.all(5),
                    child: ConstrainedBox(
                      constraints: previewConstraints,
                      child: preview(),
                    ),
                  ): null,
                  suffixIcon: state.uState == BlocUploadState.uploading ?
                  const CircularProgressIndicator() :IconButton(onPressed: () async {
                    try{
                      FilePickerResult? picked = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: allowedExt?? [".png"],
                        withData: withData,
                      );
                      uploadBloc.add(UploadSetMediaEvent(picked?.files.first, autoUpload));
                    } on Exception catch(ex){
                      debugPrint(ex.toString());
                    }
                  }, icon: const Icon(Icons.image_search))
              ),
            )
          ],
        );
      },
      listener: (BuildContext context, UploadState state) {
        //debugPrint("set url ${state.url}");
        inputKey.currentState?.didChange(state.url);
      },
      buildWhen: (previous, current) => true,
    );
  }
  Widget preview(){
    if(uploadBloc.state.media == null){
      return const Icon(
        CommunityMaterialIcons.file,
        size: 42,
      );
    }
    if(withData){
      return Image.memory(
        uploadBloc.state.media!.bytes!,
        fit: BoxFit.fill,
        errorBuilder: (context, error, stackTrace) => Icon(
          _iconData(uploadBloc.state.media!.extension!),
          size: 42,
        ),
      );
    }else{
      return Image.file(
        File(uploadBloc.state.media!.path!),
        fit: BoxFit.fill,
        errorBuilder: (context, error, stackTrace) => Icon(
          _iconData(uploadBloc.state.media!.extension!),
          size: 42,
        ),
      );
    }
  }



  IconData _iconData(String fileExtension) {
    final lowerCaseFileExt = fileExtension.toLowerCase();
    if (_imageFileExts.contains(lowerCaseFileExt)) return Icons.image;
    switch (lowerCaseFileExt) {
      case 'doc':
      case 'docx':
        return CommunityMaterialIcons.file_word;
      case 'log':
        return CommunityMaterialIcons.script_text;
      case 'pdf':
        return CommunityMaterialIcons.file_pdf;
      case 'txt':
        return CommunityMaterialIcons.script_text;
      case 'json':
        return CommunityMaterialIcons.script_text;
      case 'xls':
      case 'xlsx':
        return CommunityMaterialIcons.file_excel;
      default:
        return Icons.insert_drive_file;
    }
  }
}

const _imageFileExts = [
  'gif',
  'jpg',
  'jpeg',
  'png',
  'webp',
  'bmp',
  'dib',
  'wbmp',
];
