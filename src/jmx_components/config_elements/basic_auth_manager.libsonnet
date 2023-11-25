function(base_url, username, password)
[
  "AuthManager",
  {
    "guiclass": "AuthPanel",
    "testclass": "AuthManager",
    "testname": "HTTP Authorization Manager",
    "enabled": "true"
  },
  [
    "collectionProp",
    {
      "name": "AuthManager.auth_list"
    },
    [
      "elementProp",
      {
        "name": "",
        "elementType": "Authorization"
      },
      [
        "stringProp",
        {
          "name": "Authorization.url"
        },
        base_url
      ],
      [
        "stringProp",
        {
          "name": "Authorization.username"
        },
        username
      ],
      [
        "stringProp",
        {
          "name": "Authorization.password"
        },
        password
      ],
      [
        "stringProp",
        {
          "name": "Authorization.domain"
        }
      ],
      [
        "stringProp",
        {
          "name": "Authorization.realm"
        }
      ],
    ],
  ],
  [
    "boolProp",
    {
      "name": "AuthManager.controlledByThreadGroup"
    },
    "false"
  ],
  [
    "boolProp",
    {
      "name": "AuthManager.clearEachIteration"
    },
    "true"
  ],
]