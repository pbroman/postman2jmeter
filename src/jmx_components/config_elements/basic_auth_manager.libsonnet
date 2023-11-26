local get_value_by_key(array, key) = std.filter((function(x) x.key == key), array)[0].value;

function(base_url, auth_array)
local username = get_value_by_key(auth_array, 'username');
local password = get_value_by_key(auth_array, 'password');
[
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
  ],
  [ "hashTree", ],
]