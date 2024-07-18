import 'package:file_management/domain/helpers/helper.dart';
import 'package:file_management/presentation/blocs/bloc.dart';
import 'package:file_management/presentation/helpers/helper.dart';
import 'package:file_management/presentation/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';

// Vista para el local

class LocalPage extends StatelessWidget {

  final LocalFileBloc localFileBloc;
  
  const LocalPage({ 
    super.key, 
    required this.localFileBloc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<LocalFileBloc, LocalFileState>(
          builder: (context, stateLocalFile) {
            return AppBarWidget(
              title: 'Local',
              // Historial de archivos
              history: (localFileBloc.directory == null) ? '' : stateLocalFile.pathHistory.last.substring(localFileBloc.directory!.path.length).trim(),

              // Crear nueva carpeta
              onPressedNewFolder: () {

                // Verifica si tiene los permisos antes de continuar
                if (localFileBloc.permission!.isDenied || localFileBloc.permission!.isPermanentlyDenied){
                  final scaffold = ScaffoldMessenger.of(context);
                  scaffold.showSnackBar(
                    const SnackBar(
                      content: Text('No tiene permiso para hacer esto'),
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }

                final tecFolderName = TextEditingController();
                final formKey = GlobalKey<FormState>();

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        dialogTheme: DialogTheme(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        )
                      ),
                      child: Form(
                        key: formKey,
                        child: NewFolderDialogWidget(
                          tecFolderName: tecFolderName, 
                          formKey: formKey, 
                          // Validaciones del input
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) return 'Este campo es obligatorio';
                            if (!isValidString(value)) return 'No deben existir caracteres como /,. en el nombre';
                            bool exist = localFileBloc.state.files.any((dato) => dato.fileName == value);
                            if (exist) return 'Ya existe una carpeta con ese nombre';
                            return null;
                          },
                          onPressedAccept: () async {
                              
                            if (formKey.currentState!.validate()){
                              EasyLoading.show(status: 'Cargando');
                          
                              final navigator = Navigator.of(context);
                              final resp = await localFileBloc.createFolder(tecFolderName.value.text);
                              if (resp){
                                navigator.pop();
                              }else{
                                // TODO: Error aqui
                              }
                              EasyLoading.dismiss();
                          
                            }
                          
                          },
                        ),
                      ),
                    );
                  },
                );
              },
              // Funcion de cargar archivos
              onPressedUploadFile: () async {

                // Primero verificar que todos los permisos sean correctos
                if (localFileBloc.permission!.isDenied || localFileBloc.permission!.isPermanentlyDenied){
                  final scaffold = ScaffoldMessenger.of(context);
                  scaffold.showSnackBar(
                    const SnackBar(
                      content: Text('No tiene permiso para hacer esto'),
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }
                final navigator = Navigator.of(context);
                EasyLoading.show(status: 'Cargando');
                final pickedFiles = await openFileExplorer(context);
                EasyLoading.dismiss();
                // Si ha seleccionado uno o mas archivos seguir con esto
                if (pickedFiles.isNotEmpty){
                    showImagesCarousel(
                    // ignore: use_build_context_synchronously
                    context: context,
                    files: pickedFiles,
                    onPressedAccept: () async {
                      EasyLoading.show(status: 'Cargando');
                      final status = await localFileBloc.moveFilesToAppDirectory(pickedFiles);
                      if (status){
                        navigator.pop();
                      }else{
                        // TODO: Error aqui
                      }
                      EasyLoading.dismiss();
                    },
                  );
                }
              },
            );
          },
        ),

        // -------------------------
        // Lista de archivos
        // -------------------------

        Expanded(
          child: FutureBuilder(
              future: localFileBloc.loadFolders(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicatorWidget();
                } else if (snapshot.hasData) {
                  return BlocBuilder<LocalFileBloc, LocalFileState>(
                    builder: (context, stateLocalFile) {
                      if (snapshot.data != ''){
                        return Center(child: Text(snapshot.data!),);
                      }
                      return ListView.builder(
                        itemCount: stateLocalFile.files.length,
                        itemBuilder: (context, index) {

                          return (stateLocalFile.files[index].format != 'back') 
                          ? DismissibleWidget(
                            // Desplaza para su eliminacion
                            confirmDismiss: (direction) async {
                            return await deleteDialog(
                                context: context,
                                message: '¿Estás seguro que quieres eliminar ${stateLocalFile.files[index].name}?',
                                onPressedAccept: () async {
                                  EasyLoading.show(status: 'Eliminando');

                                  final navigator = Navigator.of(context);
                                  final status = (stateLocalFile.files[index].format == 'folder') 
                                    ? await localFileBloc.deleteFolder(folderPath: stateLocalFile.files[index].publicUrl)
                                    : await localFileBloc.deleteFile(filePath: stateLocalFile.files[index].publicUrl);
                                  
                                  if (status){
                                    EasyLoading.dismiss();
                                    navigator.pop(true);
                                  }else{
                                    // TODO: Error
                                  }

                                  EasyLoading.dismiss();
                                },
                              );
                            },
                            // Opciones normales de una ListTile
                            widget: ListTileWidget(
                              leadingFormat: stateLocalFile.files[index].format,
                              leadingPath: stateLocalFile.files[index].publicUrl,
                              title: stateLocalFile.files[index].name,
                              isLocal: true,
                              onTap: () async {
                                print(stateLocalFile.files[index].format);
                                if (['pdf', 'docx'].contains(stateLocalFile.files[index].format)){
                                  OpenFilex.open(stateLocalFile.files[index].publicUrl);
                                }else if (stateLocalFile.files[index].format == 'folder'){
                                  localFileBloc.add(OnSetPathHistory( [...stateLocalFile.pathHistory, stateLocalFile.files[index].publicUrl] ));
                                  await localFileBloc.stream.first;
                                  await localFileBloc.loadFolders();
                                }else if (stateLocalFile.files[index].format == 'back'){
                                  localFileBloc.add(OnSetPathHistory(stateLocalFile.pathHistory.sublist(0 ,stateLocalFile.pathHistory.length - 1)));
                                  await localFileBloc.stream.first;
                                  await localFileBloc.loadFolders();
                                }else{
                                showDialog(
                                    context: context, 
                                    builder: (BuildContext context) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          dialogTheme: DialogTheme(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(2),
                                            ),
                                          )
                                        ),
                                        child: ImageModal(
                                          imagePath: stateLocalFile.files[index].publicUrl,
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                                
                            ),
                          )
                          // Esto solo es para el back. ya que el back no debe eliminarse
                          : ListTileWidget(
                              leadingFormat: stateLocalFile.files[index].format,
                              leadingPath: stateLocalFile.files[index].publicUrl,
                              isLocal: true,
                              title: stateLocalFile.files[index].name,
                              onTap: () async {

                                if (stateLocalFile.files[index].format == 'image'){
                                 showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          dialogTheme: DialogTheme(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(2),
                                            ),
                                          )
                                        ),
                                        child: ImageModal(
                                          imagePath: stateLocalFile.files[index].publicUrl,
                                        ),
                                      );
                                    },
                                  );
                                }else if (stateLocalFile.files[index].format == 'folder'){
                                  localFileBloc.add(OnSetPathHistory([...stateLocalFile.pathHistory, stateLocalFile.files[index].publicUrl]));
                                  await localFileBloc.stream.first;
                                  await localFileBloc.loadFolders();
                                }else if (stateLocalFile.files[index].format == 'back'){
                                  localFileBloc.add(OnSetPathHistory(stateLocalFile.pathHistory.sublist(0 ,stateLocalFile.pathHistory.length - 1)));
                                  await localFileBloc.stream.first;
                                  await localFileBloc.loadFolders();
                                }
                              },
                          );
                        },
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text('Error'),
                  );
                }
              }),
        ),
      ],
    );
  }
}