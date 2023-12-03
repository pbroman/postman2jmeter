/*
 * Assertion checking if a response status matches a given value
 */
function(status)
local trimmed_status = std.stripChars(status, " ");
[
  [
    "ResponseAssertion",
    {
      "guiclass": "AssertionGui",
      "testclass": "ResponseAssertion",
      "testname": "Status Response Assertion " + trimmed_status,
      "enabled": "true"
    },
    [
      "collectionProp",
      {
        "name": "Asserion.test_strings"
      },
      [
        "stringProp",
        {
          "name": "51512"
        },
        trimmed_status
      ],
    ],
    [
      "stringProp",
      {
        "name": "Assertion.custom_message"
      }
    ],
    [
      "stringProp",
      {
        "name": "Assertion.test_field"
      },
      "Assertion.response_code"
    ],
    [
      "boolProp",
      {
        "name": "Assertion.assume_success"
      },
      "true"
    ],
    [
      "intProp",
      {
        "name": "Assertion.test_type"
      },
      "1"
    ],
  ],
  [
    "hashTree"
  ]
]