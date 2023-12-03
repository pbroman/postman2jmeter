// Preprocessor removing Authorizazion header
function()
[
  "BeanShellPreProcessor",
  {
    "guiclass": "TestBeanGUI",
    "testclass": "BeanShellPreProcessor",
    "testname": "No Auth",
    "enabled": "true"
  },
  [
    "stringProp",
    {
      "name": "filename"
    }
  ],
  [
    "stringProp",
    {
      "name": "parameters"
    }
  ],
  [
    "boolProp",
    {
      "name": "resetInterpreter"
    },
    "false"
  ],
  [
    "stringProp",
    {
      "name": "script"
    },
    "import org.apache.jmeter.protocol.http.control.Header;\nsampler.getHeaderManager().removeHeaderNamed(\"Authorization\")"
  ]
]