local body_raw = import 'fragments/body_raw.libsonnet';
local request_param = import 'fragments/request_param.libsonnet';

function(name, request)
[
  "HTTPSamplerProxy",
  {
    "guiclass": "HttpTestSampleGui",
    "testclass": "HTTPSamplerProxy",
    "testname": name,
    "enabled": "true"
  },
  if std.objectHas(request, 'body') && std.objectHas(request.body, 'raw')
       then [ "boolProp", { "name": "HTTPSampler.postBodyRaw" }, "true" ],
  [
    "elementProp",
    {
      "name": "HTTPsampler.Arguments",
      "elementType": "Arguments"
    },
    [
      "collectionProp",
      {
        "name": "Arguments.arguments"
      },
      if std.objectHas(request, 'body') then (
        if request.body.mode == 'raw' then body_raw(request.body.raw)
        else if request.body.mode == 'urlencoded' then [request_param(param.key, param.value) for param in request.body.urlencoded]
        else error 'Error in http sampler: unknown body mode: ' + request.body.mode
      )
      else if std.objectHas(request.url, 'query') then [request_param(param.key, param.value) for param in request.url.query],
    ],
  ],
  [
    "stringProp",
    {
      "name": "HTTPSampler.domain"
    },
    request.url.host
  ],
  [
    "stringProp",
    {
      "name": "HTTPSampler.port"
    },
    request.url.port
  ],
  [
    "stringProp",
    {
      "name": "HTTPSampler.protocol"
    }
  ],
  [
    "stringProp",
    {
      "name": "HTTPSampler.contentEncoding"
    }
  ],
  [
    "stringProp",
    {
      "name": "HTTPSampler.path"
    },
    '/' + std.join('/', request.url.path)
  ],
  [
    "stringProp",
    {
      "name": "HTTPSampler.method"
    },
    request.method
  ],
  [
    "boolProp",
    {
      "name": "HTTPSampler.follow_redirects"
    },
    "false"
  ],
  [
    "boolProp",
    {
      "name": "HTTPSampler.auto_redirects"
    },
    "false"
  ],
  [
    "boolProp",
    {
      "name": "HTTPSampler.use_keepalive"
    },
    "true"
  ],
  [
    "boolProp",
    {
      "name": "HTTPSampler.DO_MULTIPART_POST"
    },
    std.objectHas(request, 'body') && std.objectHas(request.body, 'urlencoded')
  ],
  [
    "stringProp",
    {
      "name": "HTTPSampler.embedded_url_re"
    }
  ],
  [
    "stringProp",
    {
      "name": "HTTPSampler.connect_timeout"
    }
  ],
  [
    "stringProp",
    {
      "name": "HTTPSampler.response_timeout"
    }
  ],
]
