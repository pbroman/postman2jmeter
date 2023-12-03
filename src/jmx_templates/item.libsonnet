local simple_controller = import 'logic_controller/simple_controller.libsonnet';

function(item)
[
  simple_controller(item.name),
  [
    "hashTree",
  ],
  if std.objectHas(item, 'item') then
]