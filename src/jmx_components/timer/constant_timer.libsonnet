function(name, property, default, comment)
[
  [
    "ConstantTimer",
    {
      "guiclass": "ConstantTimerGui",
      "testclass": "ConstantTimer",
      "testname": name,
      "enabled": "true"
    },
    [
      "stringProp",
      {
        "name": "TestPlan.comments"
      },
      comment
    ],
    [
      "stringProp",
      {
        "name": "ConstantTimer.delay"
      },
      '${__P(' + property + ', ' + default + ')}'
    ],
  ],
  [
    "hashTree"
  ],
]