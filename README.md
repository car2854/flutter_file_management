# file_management

Un proyecto de flutter para gestionar archivos tanto localmente como en la nube.

# Instalacion

```bash
$ flutter pub get
```

# librerias instaladas

# Configuración 

para cambiar entre servidores, ya sea `localhost` o `Render`, ir a: `lib/config/enviroment_config.dart`.

Ahí verás el siguiente código:
```
class EnviromentConfig {
  // static const String baseUrl = 'http://192.168.0.3:3000/api';
  static const String baseUrl = 'https://nestjs-file-managementj.onrender.com/api';
}
```
Deben actualizar esta configuración a la dirección donde se debe realizar la petición. Recuerda que, si estás trabajando en local, debes usar la IP correcta.

## 1. bloc, flutter_bloc
Manejo de estados.

## 2. equatable
Herramienta util para comparar objetos de manera eficiente.

## 3. path_provider
Para acceder a los directorios tipicos donde las aplicaciones pueden almacenar archivos de manera persistente en el dispositivo.

## 4. permission_handler
Facilita la solicitud y gestión de permisos de manera sencilla.

## 5. file_picker
Permite seleccionar archivos desde el almacenamiento del dispositivo.

## 6. carousel_slider
Facilita la creación de carruseles de imágenes o widgets deslizables horizontalmente.

## 7. open_filex
Facilita la apertura de archivos como PDF en el dispositivo utilizando las aplicaciones nativas

## 7. url_launcher
