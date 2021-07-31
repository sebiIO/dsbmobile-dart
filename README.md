# dsbmobile-dart

Implementation of the DSBmobile mobile API in Dart.

## How to use

```dart
import 'package:dsbmobile/dsbmobile.dart';

void main(List<String> args) async {
  final api = DSBApi('username', 'password');
  
  await api.login();
  
  // do something with the response
  print((await api.getTimetables()).toString());
}
```
