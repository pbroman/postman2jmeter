local user_defined_variable = import 'config_elements/fragments/user_defined_variable.libsonnet';

local cookie_manager = import 'config_elements/cookie_manager.libsonnet';
local basic_auth_manager = import 'config_elements/basic_auth_manager.libsonnet';

local summary_report = import 'listeners/summary_report.libsonnet';
local view_results_tree = import 'listeners/view_results_tree.libsonnet';

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
  ]

  + cookie_manager()
  // TODO add thread group
  + summary_report()
  + view_results_tree()
]