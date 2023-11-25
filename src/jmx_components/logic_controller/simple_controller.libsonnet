local simple_controller = import 'simple_controller.libsonnet';
local http_sampler_proxy = import '../sampler/http_sampler_proxy.libsonnet';

function(item_object)
[
  [
    "GenericController",
    {
      "guiclass": "LogicControllerGui",
      "testclass": "GenericController",
      "testname": item_object.name,
      "enabled": "true"
    }
  ],
  [ "hashTree", ]
  + std.flattenArrays([ if std.objectHas(item, 'item') then simple_controller(item) else http_sampler_proxy(item.name, item.request) for item in item_object.item ])
]