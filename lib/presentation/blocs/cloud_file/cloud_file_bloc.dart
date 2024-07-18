import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_management/data/datasources/remote/file_services.dart';
import 'package:file_management/data/models/model.dart';
import 'package:http/http.dart';

part 'cloud_file_event.dart';
part 'cloud_file_state.dart';

class CloudFileBloc extends Bloc<CloudFileEvent, CloudFileState> {

  // List<String> pathHistory = [''];

  CloudFileBloc() : super(const CloudFileState()) {
    on<CloudFileEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<OnSetFileResponse>((event, emit) {
      emit(state.copyWith(files: event.files));
    });

    on<OnSetPathHistoryCloud>((event, emit) {
      emit(state.copyWith(pathHistory: event.pathHistory));
    });
  }


  Future<bool> getFiles() async {


    try {
      print('Ver aqui------------');
      print(state.pathHistory.last);
      add(const OnSetFileResponse([]));
      Response response = await FileServices.getFiles(folderName: state.pathHistory.last);
      final fileResponse = fileResponseFromJson(response.body);
      add(OnSetFileResponse(fileResponse));
      return true;      
    } catch (e) {
      print(e);
      return false;
    }

  }

  Future<bool> updateFile({required List<String> paths}) async {

    try {
      final response = await FileServices.uploadFile(paths: paths, folderName: state.pathHistory.last);
      print(response.statusCode);
      if (response.statusCode == 201){
        String responseBody = await response.stream.bytesToString();
        final fileResponse = fileResponseFromJson(responseBody);
        add(OnSetFileResponse([...state.files, ...fileResponse]));
      }

      return true;
    } catch (e) {
      print(e);
      return false;
    }
    
  }

  Future<bool> deleteFile(String fileName) async {

    try {
      final response = await FileServices.deleteFile(fileName);
      print(response.body);
      if (response.statusCode == 200){

        for (var element in state.files) {
          print(element.fileName != fileName);
        }
        print(fileName);
        add(OnSetFileResponse(state.files.where((file) => file.name != fileName).toList()));
        return true;
      }else{
        print(response.body);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }

  }

  Future<bool> createFolder(String folderName) async {
    try {
      final response = await FileServices.createFolder('${state.pathHistory.last}$folderName');
      print('-----------------------------');
      print(response.statusCode);
      if (response.statusCode == 201){
        add(OnSetFileResponse([...state.files, FileModel(
          fileName: '${state.pathHistory.last}$folderName/',
          name: folderName, 
          publicUrl: folderName, 
          format: 'folder'
        )]));
        return true;
      }else{
        print(response.body);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
