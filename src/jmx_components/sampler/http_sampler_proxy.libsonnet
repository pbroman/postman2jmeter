local body_raw = import 'fragments/body_raw.libsonnet';
local request_param = import 'fragments/request_param.libsonnet';
local create_headers = import 'helpers/create_headers.libsonnet';
local header_manager = import '../config_elements/header_manager.libsonnet';
local basic_auth_manager = import '../config_elements/basic_auth_manager.libsonnet';

function(name, request, parent_auth_config)
local auth_config = parent_auth_config + (if std.objectHas(request, 'auth') then { auth: request.auth } else {});
[
  [
    "HTTPSamplerProxy",
    {
      "guiclass": "HttpTestSampleGui",
      "testclass": "HTTPSamplerProxy",
      "testname": name,
      "enabled": "true"
    },

    [
      "boolProp",
      {
        "name": "HTTPSampler.postBodyRaw"
      },
      std.toString( std.objectHas(request, 'body') && request.body.mode == 'raw' )
    ],
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
      ]
      +
        if std.objectHas(request, 'body') then (
            if request.body.mode == 'raw' then [body_raw(request.body.raw)]
            else if request.body.mode == 'urlencoded' then [request_param(param.key, param.value) for param in request.body.urlencoded]
            else error 'Error in http sampler: unknown body mode: ' + request.body.mode
          )
          else if std.objectHas(request.url, 'query') then [request_param(param.key, param.value) for param in request.url.query] else [],
    ],
    [
      "stringProp",
      {
        "name": "HTTPSampler.domain"
      },
      std.join('', request.url.host)
    ],
    [
      "stringProp",
      {
        "name": "HTTPSampler.port"
      },
      if std.objectHas(request.url, 'port') then request.url.port else ''
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
      '/' + if std.objectHas(request.url, 'path') then std.join('/', request.url.path) else ''
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
      std.toString( std.objectHas(request, 'body') && request.body.mode == 'urlencoded' )
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
  ],
  [ "hashTree", ]
  + create_headers(request)
  + if auth_config.auth.type == 'basic'
          then basic_auth_manager(request.url.host[0], auth_config.auth.basic)
          else []
]