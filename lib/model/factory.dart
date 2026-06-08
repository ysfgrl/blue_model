

import 'dart:convert';

import 'base.dart';
import 'list_request.dart';
import 'list_response.dart';
import 'error.dart';
import 'response.dart';
import 'package:flutter/cupertino.dart';

class ModelRegistry<T extends BaseModel>{
  ModelRegistry(this.constructor);
  T Function(Map<String, dynamic> js) constructor;
}

class ModelFactory{
  static final Map<String, ModelRegistry> _modelRegistry = {};

  static void register<MType extends BaseModel>(MType Function(Map<String, dynamic> js) constructor) {
    if(_modelRegistry.containsKey(MType.toString())){
      return;
    }
    _modelRegistry[MType.toString()] = ModelRegistry<MType>(constructor);
    _modelRegistry[ResponseModel<MType>().runtimeType.toString()] = ModelRegistry<ResponseModel<MType>>(ResponseModel.fromJson);
    _modelRegistry[ListResponse<MType>().runtimeType.toString()] = ModelRegistry<ListResponse<MType>>(ListResponse.fromJson);
    _modelRegistry[ResponseModel<ListResponse<MType>>().runtimeType.toString()] = ModelRegistry<ResponseModel<ListResponse<MType>>>(ResponseModel.fromJson);
  }

  static void unRegister<MType extends BaseModel>() {
    if(_modelRegistry.containsKey(MType.toString())){
      _modelRegistry.remove(MType.toString());
      _modelRegistry.remove(ResponseModel<MType>().runtimeType.toString());
      _modelRegistry.remove(ListResponse<MType>().runtimeType.toString());
      _modelRegistry.remove(ResponseModel<ListResponse<MType>>().runtimeType.toString());
    }
  }

  static void registerModels({List<void Function()>? models}){
      register<ResponseInt>(ResponseInt.fromJson);
      register<ResponseStr>(ResponseStr.fromJson);
      register<ResponseOk>(ResponseOk.fromJson);
      register<ListRequest>(ListRequest.fromJson);
      register<ResponseError>(ResponseError.fromJson);
  }

  static MMType? modelFactory<MMType extends BaseModel>(Map<String, dynamic>? js) {
    if(js == null) {
      return null;
    }
    String typeName = MMType.toString();
    if (!_modelRegistry.containsKey(typeName)) {
      throw UnimplementedError('Factory not implemented for type $typeName');
    }
    var instance = _modelRegistry[typeName]! as ModelRegistry<MMType>;
    return  instance.constructor(js);
  }

  static MMType? modelFromString<MMType extends BaseModel>(String? jsonStr) {
    if(jsonStr == null) {
      return null;
    }
    try{
      return modelFactory(json.decode(jsonStr));
    }on Exception catch(ex, stackTrace){
      debugPrintStack(stackTrace: stackTrace);
    }
    return null;
  }


  static List<MListType> modelListFactory<MListType extends BaseModel>(List<dynamic> js) {
    List<MListType> result = [];
    for(var item in js){
      final MListType? res = modelFactory<MListType>(item);
      if(res != null) {
        result.add(res);
      }
    }
    return result;
  }

  static Map<String, dynamic>? modelToJson(BaseModel? model) {
    return model?.toJson();
  }

}