import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_management/data/models/model.dart';
import 'package:path_provider/path_provider.dart';

part 'local_file_event.dart';
part 'local_file_state.dart';

class LocalFileBloc extends Bloc<LocalFileEvent, LocalFileState> {

  Directory? directory;
  // List<String> pathHistory = [];

  LocalFileBloc() : super(const LocalFileState()) {

    on<LocalFileEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<OnSetFiles>((event, emit) => emit(state.copyWith(files: event.files)));
    on<OnSetPathHistory>((event, emit) => emit(state.copyWith(pathHistory: event.pathHistory)));
    
  }

  Future _getLocalPath() async {
    directory = await getApplicationDocumentsDirectory();
    final filesDirectory = Directory('${directory!.path}/files');

    if (!(await filesDirectory.exists())) {
      await filesDirectory.create(recursive: true);
    }
    directory = filesDirectory;
    add(OnSetPathHistory([filesDirectory.path]));
    await stream.first;
    // pathHistory.add(filesDirectory.path);
  }

  Future<bool> delete() async {

    return true;
  }

  Future<bool> loadFolders() async {
    List<FileModel> files = [];
    
    try {
      
      if (directory == null){
        await _getLocalPath();
      }
      print('VVer estop');
      print(state.pathHistory[0].length);
      print('--------------');

      final dir = Directory(state.pathHistory.last);


      List<FileSystemEntity> entities = dir.listSync();

      if (state.pathHistory.length != 1){
        files.add(FileModel(
          fileName: 'atras..', 
          name: 'atras..', 
          publicUrl: 'publicUrl', 
          format: 'back'
        ));
      }

      for (var entity in entities) {
        print(entity.path);
        print(entity.path);
        if ( entity is Directory || entity is File ) {
          print(entity.path);
          // print(state.directory);
          FileModel file = FileModel(
            fileName: entity.path.split('/').last, 
            name: entity.path.split('/').last, 
            publicUrl: entity.path, 
            format: (entity is Directory) ? 'folder' : 'image'
          );

          files.add(file);
          print(entity.path);
        }
      }

      add(OnSetFiles(files));
      return true;
    } catch (e) {
      print('Error al cargar las carpetas: $e');
      return false;
    }
  }

  Future<bool> createFolder(String folderName) async {
    // final path = await getLocalPath();

    final folderPath = '${state.pathHistory.last}/$folderName';

    // Verificar si la carpeta ya existe antes de crearla
    if (!Directory(folderPath).existsSync()) {
      
      Directory(folderPath).createSync(recursive: true);
      print('Carpeta creada en: $folderPath');

      FileModel file = FileModel(
        fileName: folderName, 
        name: folderName, 
        publicUrl: folderPath, 
        format: 'folder'
      );

      add(OnSetFiles([...state.files, file]));
      return true;
    } else {
      print('La carpeta ya existe en: $folderPath');
      return false;
    }
  }

  Future<bool> moveFilesToAppDirectory(List<File> files) async {
    try {
      for (File file in files) {
        String fileName = file.path.split('/').last;
        String newPath = '${state.pathHistory.last}/$fileName';
        add(OnSetFiles([...state.files, FileModel(
          fileName: fileName, 
          name: fileName, 
          publicUrl: newPath, 
          format: 'image'
        )]));
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteFolder({required String folderPath}) async {

    Directory dir = Directory(folderPath);

    print(folderPath);
    if (await dir.exists()) {
      try {
        await dir.delete(recursive: true);
        print('Carpeta eliminada: $folderPath');
        return true;
      } catch (e) {
        print('Error al eliminar la carpeta: $e');
        return false;
      }
    } else {
      print('La carpeta no existe.');
      return false;
    }
  }

  Future<bool> deleteFile({required String filePath}) async {
    File file = File(filePath);

    if (await file.exists()) {
      try {
        await file.delete();
        return true;
      } catch (e) {
        print(e);
        return false;
      }
    } else {
      return false;
    }
}

}
