import 'package:ui/ui.dart';

bool useFocusNodeHasFocus(FocusNode focusNode) {
  final hasFocus = useState(focusNode.hasFocus);
  $useListenerEffect(focusNode, () => hasFocus.value = focusNode.hasFocus, callImmediately: true);

  return hasFocus.value;
}

void useOnDispose(VoidCallback callback) {
  useEffect(() => callback, const []);
}
