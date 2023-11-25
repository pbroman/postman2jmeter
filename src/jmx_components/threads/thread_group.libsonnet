function(name)
[
  "ThreadGroup",
  {
    "guiclass": "ThreadGroupGui",
    "testclass": "ThreadGroup",
    "testname": name,
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
]