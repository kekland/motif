import 'package:shared/shared.dart';

class AlwaysNotifier<T> extends ChangeNotifier implements ValueListenable<T> {
  AlwaysNotifier(this._value);

  @override
  T get value => _value;
  T _value;
  set value(T newValue) {
    _value = newValue;
    notifyListeners();
  }
}
