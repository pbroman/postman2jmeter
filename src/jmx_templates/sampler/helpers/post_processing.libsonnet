local post_processor = import '../../post_processors/jsr223_postprocessor.libsonnet';
local status_response_assertion = import '../../assertions/status_response_assertion.libsonnet';

local interesting_code = [
  'pm.response.json',
  'JSON.parse',
  'pm.response.headers.get',
  'pm.environment.set',
  'pm.collectionVariables.set',
  'postman.setEnvironmentVariable'
];

local json_slurper = 'import groovy.json.JsonSlurper\n\ndef jsonSlurper = new JsonSlurper();\n';
local headers_parser =
"def headers = prev.getResponseHeaders().split('\\n').inject([:]) { out, header ->
    if (header.contains(':')) {
        header.split(':').with {
            out[it[0].trim()] = it[1].trim()
        }
    }
    out
}\n\n";

function(script)

local jmeter_lines = std.filter(
  function(line) std.length(std.findSubstr('jmeter_keep', line)) > 0,
  script.exec
);
local status_response_lines = std.filter(
  function(line) std.length(std.findSubstr('jmeter_status:', line)) > 0,
  script.exec
);

if std.length(status_response_lines) > 0
  then status_response_assertion(std.split(status_response_lines[0], 'jmeter_status:')[1])
  else []
+
if std.length(jmeter_lines) > 0
  then post_processor('groovy', json_slurper + headers_parser + std.join('\n', jmeter_lines))
  else []

