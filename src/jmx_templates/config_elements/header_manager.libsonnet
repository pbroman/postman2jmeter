local header = import 'fragments/header.libsonnet';

function(headers)
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
    ]
    + [header(h.key, h.value) for h in headers],
  ],
  [ "hashTree" ],
]