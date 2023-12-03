function(ref_names, json_path, match_num)
[
  "JSONPostProcessor",
  {
    "guiclass": "JSONPostProcessorGui",
    "testclass": "JSONPostProcessor",
    "testname": "JSON Extractor",
    "enabled": "true"
  },
  [
    "stringProp",
    {
      "name": "JSONPostProcessor.referenceNames"
    },
    ref_names
  ],
  [
    "stringProp",
    {
      "name": "JSONPostProcessor.jsonPathExprs"
    },
    json_path
  ],
  [
    "stringProp",
    {
      "name": "JSONPostProcessor.match_numbers"
    },
    match_num
  ],
]
