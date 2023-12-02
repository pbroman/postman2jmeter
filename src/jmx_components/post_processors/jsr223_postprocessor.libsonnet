function(language, script)
[
  [
    "JSR223PostProcessor",
    {
      "guiclass": "TestBeanGUI",
      "testclass": "JSR223PostProcessor",
      "testname": "JSR223 PostProcessor",
      "enabled": "true"
    },
    [
      "stringProp",
      {
        "name": "scriptLanguage"
      },
      language
    ],
    [
      "stringProp",
      {
        "name": "parameters"
      }
    ],
    [
      "stringProp",
      {
        "name": "filename"
      }
    ],
    [
      "stringProp",
      {
        "name": "cacheKey"
      },
      "true"
    ],
    [
      "stringProp",
      {
        "name": "script"
      },
      script
    ],
  ],
  [
    "hashTree"
  ],
]