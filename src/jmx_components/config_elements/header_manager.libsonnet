function(key, value)
[
  [
    "HeaderManager",
    {
      "guiclass": "HeaderPanel",
      "testclass": "HeaderManager",
      "testname": "HTTP Header Manager",
      "enabled": "true"
    },
    [
      "collectionProp",
      {
        "name": "HeaderManager.headers"
      },
      [
        "elementProp",
        {
          "name": "",
          "elementType": "Header"
        },
        [
          "stringProp",
          {
            "name": "Header.name"
          },
          key
        ],
        [
          "stringProp",
          {
            "name": "Header.value"
          },
          value
        ],
      ],
    ],
  ],
  [ "hashTree" ],
]