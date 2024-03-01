local body_raw = import 'fragments/body_raw.libsonnet';
local request_param = import 'fragments/request_param.libsonnet';
local create_headers = import 'helpers/create_headers.libsonnet';
local basic_auth_manager = import '../config_elements/basic_auth_manager.libsonnet';
local post_processing = import 'helpers/post_processing.libsonnet';
local flow_control_action = import 'flow_control_action.libsonnet';

function(item, parent_config)
local request = item.request;
local config = parent_config
  + (if std.objectHas(request, 'auth') then { auth: request.auth } else {})
  + (if std.objectHas(item, 'protocolProfileBehavior') then { protocolProfileBehavior+: item.protocolProfileBehavior } else {});

if std.objectHas(request, 'description') && std.length( std.findSubstr('jmeter_skip', request.description) ) > 0
then []
else
if std.objectHas(request, 'description') && std.length( std.findSubstr('jmeter_sleep', request.description) ) > 0
then flow_control_action(std.split(request.description, 'jmeter_sleep:')[1])
else
[
  [
    "HTTPSamplerProxy",
    {
      "guiclass": "HttpTestSampleGui",
      "testclass": "HTTPSamplerProxy",
      "testname": item.name,
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
          // Query params have been replaced by complete url in path
          //else if std.objectHas(request, 'url') && std.objectHas(request.url, 'query') then [request_param(param.key, param.value) for param in request.url.query] else [],
          else []
    ],
    [
      "stringProp",
      {
        "name": "HTTPSampler.domain"
      },
    ],
    [
      "stringProp",
      {
        "name": "HTTPSampler.port"
      },
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
      if std.objectHas(request, 'url') then
        std.strReplace(std.strReplace(request.url.raw, '"', '%22'), '&', '&amp;') // FIXME hacky url/xml encoding!
        else ''
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
      std.toString(config.protocolProfileBehavior.followRedirects)
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
      "false"
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
  + (if config.auth.type == 'basic' && std.objectHas(request, 'url')
          then basic_auth_manager( request.url, config.auth.basic)
          else [])
  + if std.objectHas(item, 'event') && std.objectHas(item.event[0], 'script')
          then post_processing(item.event[0].script)
          else []
]