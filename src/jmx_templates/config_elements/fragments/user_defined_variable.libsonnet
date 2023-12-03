function( key, value )
  [
    "elementProp",
    {
      "name": key,
      "elementType": "Argument"
    },
    [
      "stringProp",
      {
        "name": "Argument.name"
      },
      key
    ],
    [
      "stringProp",
      {
        "name": "Argument.value"
      },
      if std.isEmpty(value) then '${__P(' + key + ',"")}' else value
    ],
    [
      "stringProp",
      {
        "name": "Argument.metadata"
      },
      "="
    ],
  ]
