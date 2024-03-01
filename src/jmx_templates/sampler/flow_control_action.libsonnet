function(pause_ms)
[
  [
    "TestAction",
    {
      "guiclass": "TestActionGui",
      "testclass": "TestAction",
      "testname": "Flow Control Action",
      "enabled": "true"
    },
    [
      "intProp",
      {
        "name": "ActionProcessor.action"
      },
      "1"
    ],
    [
      "intProp",
      {
        "name": "ActionProcessor.target"
      },
      "0"
    ],
    [
      "stringProp",
      {
        "name": "ActionProcessor.duration"
      },
      pause_ms
    ],
  ],
  [
    "hashTree"
  ],
]