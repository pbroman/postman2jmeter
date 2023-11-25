local simple_controller = import '../logic_controller/simple_controller.libsonnet';
local http_sampler_proxy = import '../sampler/http_sampler_proxy.libsonnet';

function(items)
[
  [
    "ThreadGroup",
    {
      "guiclass": "ThreadGroupGui",
      "testclass": "ThreadGroup",
      "testname": "ThreadGroup",
      "enabled": "true"
    },
    [
      "stringProp",
      {
        "name": "ThreadGroup.on_sample_error"
      },
      "continue"
    ],
    [
      "elementProp",
      {
        "name": "ThreadGroup.main_controller",
        "elementType": "LoopController",
        "guiclass": "LoopControlPanel",
        "testclass": "LoopController",
        "testname": "Loop Controller",
        "enabled": "true"
      },
      [
        "boolProp",
        {
          "name": "LoopController.continue_forever"
        },
        "false"
      ],
      [
        "stringProp",
        {
          "name": "LoopController.loops"
        },
        "${__P(loop_count, 1)}"
      ],
    ],
    [
      "stringProp",
      {
        "name": "ThreadGroup.num_threads"
      },
      "${__P(thread_count, 1)}"
    ],
    [
      "stringProp",
      {
        "name": "ThreadGroup.ramp_time"
      },
      "${__P(rampup, 1)}"
    ],
    [
      "boolProp",
      {
        "name": "ThreadGroup.scheduler"
      },
      "false"
    ],
    [
      "stringProp",
      {
        "name": "ThreadGroup.duration"
      }
    ],
    [
      "stringProp",
      {
        "name": "ThreadGroup.delay"
      }
    ],
    [
      "boolProp",
      {
        "name": "ThreadGroup.same_user_on_next_iteration"
      },
      "true"
    ],
  ],
  [ "hashTree", ]
  + std.flattenArrays([ if std.objectHas(item, 'item') then simple_controller(item) else http_sampler_proxy(item.name, item.request) for item in items ])
]