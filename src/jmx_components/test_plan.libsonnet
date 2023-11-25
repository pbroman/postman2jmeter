local user_defined_variable = import 'config_elements/fragments/user_defined_variable.libsonnet';

local cookie_manager = import 'config_elements/cookie_manager.libsonnet';
local basic_auth_manager = import 'config_elements/basic_auth_manager.libsonnet';

local summary_report = import 'listeners/summary_report.libsonnet';
local view_results_tree = import 'listeners/view_results_tree.libsonnet';

local thread_group = import 'threads/thread_group.libsonnet';

local get_element_with_key(array, key) = std.filter((function(x) x.key == key), array);

function(_config)
[
  [
    "TestPlan",
    {
      "guiclass": "TestPlanGui",
      "testclass": "TestPlan",
      "testname": _config.collection.info.name,
      "enabled": "true"
    },
    [
      "stringProp",
      {
        "name": "TestPlan.comments"
      }
    ],
    [
      "boolProp",
      {
        "name": "TestPlan.functional_mode"
      },
      "false"
    ],
    [
      "boolProp",
      {
        "name": "TestPlan.tearDown_on_shutdown"
      },
      "true"
    ],
    [
      "boolProp",
      {
        "name": "TestPlan.serialize_threadgroups"
      },
      "false"
    ],
    [
      "elementProp",
      {
        "name": "TestPlan.user_defined_variables",
        "elementType": "Arguments",
        "guiclass": "ArgumentsPanel",
        "testclass": "Arguments",
        "testname": "User Defined Variables",
        "enabled": "true"
      },
      [
        "collectionProp",
        {
          "name": "Arguments.arguments"
        }
      ],
    ],
    [
      "stringProp",
      {
        "name": "TestPlan.user_define_classpath"
      }
    ],
  ],
  [
    "hashTree",
    [
      "Arguments",
      {
        "guiclass": "ArgumentsPanel",
        "testclass": "Arguments",
        "testname": "User Defined Variables",
        "enabled": "true"
      },
      [
        "collectionProp",
        {
          "name": "Arguments.arguments"
        },
      ]
      + [user_defined_variable(var.key, var.value) for var in _config.env.values]
      + if std.objectHas(_config.collection, 'variable')
          then [user_defined_variable(var.key, var.value) for var in _config.collection.variable]
          else [],
    ],
    [ "hashTree" ],
  ]
  + cookie_manager()
  // Add AuthManager conditionally
  + (if std.objectHas(_config.collection, 'auth') && std.objectHas(_config.collection.auth, 'basic')
                                  // FIXME better filter
      then basic_auth_manager('', get_element_with_key(_config.collection.auth.basic, 'username')[0].value, get_element_with_key(_config.collection.auth.basic, 'password')[0].value)
      else [])
  + thread_group(_config.collection.item)
  + summary_report()
  + view_results_tree()
]