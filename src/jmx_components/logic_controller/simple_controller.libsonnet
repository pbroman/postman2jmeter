local simple_controller = import 'simple_controller.libsonnet';
local http_sampler_proxy = import '../sampler/http_sampler_proxy.libsonnet';

function(item_object, parent_auth_config)
local auth_config = parent_auth_config + (if std.objectHas(item_object, 'auth') then { auth: item_object.auth } else {});

if std.objectHas(item_object, 'description') && std.length( std.findSubstr('jmeter_skip', item_object.description) ) > 0
then []
else
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
  + std.flattenArrays([
      if std.objectHas(item, 'item')
        then simple_controller(item, auth_config)
        else http_sampler_proxy(item, auth_config)
      for item in item_object.item
    ])
]