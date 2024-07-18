part of 'cloud_file_bloc.dart';

class CloudFileState extends Equatable {

  final List<FileModel> files;
  final List<String> pathHistory;

  const CloudFileState({
    List<String>? pathHistory,
    List<FileModel>? files,
  }) : files = files ?? const[], pathHistory = pathHistory ?? const[''];
  
  CloudFileState copyWith({
    List<FileModel>? files,
    List<String>? pathHistory,
    bool? isLoading
  }) => CloudFileState(
    files: files ?? this.files,
    pathHistory: pathHistory ?? this.pathHistory,
  );

  @override
  List<Object?> get props => [files, pathHistory];
}