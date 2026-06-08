
part of 'blue_list.dart';
class BlueListAction{
  final Icon icon;
  final Widget child;
  final dynamic value;
  final void Function()? onSelect;
  BlueListAction({
    required this.icon,
    required this.child,
    required this.value,
    this.onSelect
  });
  BlueListAction.create({
    this.icon = const Icon(Icons.add),
    required this.child,
    this.value = "create",
    this.onSelect
  });
  BlueListAction.close({
    this.icon = const Icon(Icons.close),
    required this.child,
    this.value = "close",
    this.onSelect
  });
  BlueListAction.delete({
    this.icon = const Icon(Icons.delete_forever, color: Colors.red,),
    required this.child,
    this.value = "delete",
    this.onSelect
  });
  BlueListAction.edit({
    this.icon = const Icon(Icons.edit_calendar, color: Colors.blue,),
    required this.child,
    this.value = "edit",
    this.onSelect
  });

  BlueListAction.refresh({
    this.icon = const Icon(Icons.refresh),
    required this.child,
    this.value = "refresh",
    this.onSelect
  });
}


