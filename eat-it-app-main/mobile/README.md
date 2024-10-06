# eatit_mobile_app

A new Flutter project.

## Getting Started

## How to

### Install flutter

[Инструкция как поставить flutter](https://docs.flutter.dev/get-started/install)

### Собрать сборку

Положить ключ из `папка_проекта/ключ/upload-keysote.jks` в `~/upload-keystore.jks`

~~~shell
flutter build apk
~~~

### Собрать прод сборку

#### Подпись приложения на android

Предварительно нужно положить `*.jks` файл и `key.properties` в папку `./android`. Они лежат в гуглопапке по пути `Deploy/android`. В файле `key.properties` нужно будет прописать путь до файла `*.jks`

Нудно задать переменную `--dart-define=baseUrl=<https://eatitserver.uk/api>`, например

#### Сборка apk

~~~shell
flutter build apk --dart-define=baseUrl=https://eatitserver.uk/api --release
~~~

#### Сборка appbundle

~~~shell
flutter build appbundle --dart-define=baseUrl=https://eatitserver.uk/api --release
~~~

### Кодогенерация

Запустить сборку кодогенерации

~~~shell
flutter pub run build_runner watch --delete-conflicting-outputs
~~~

## Libraries

* [easy_localization](https://pub.dev/packages/easy_localization) - Локализация
* [shared_preferences](https://pub.dev/packages/shared_preferences) - локальное хранилище
* [go_router](#) - router
* [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) - с кодогенерацией, хранилище данных
