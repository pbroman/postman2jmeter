local test_plan = import 'jmx_templates/test_plan.libsonnet';

local user_defined_variable = import 'jmx_templates/config_elements/fragments/user_defined_variable.libsonnet';
local cookie_manager = import 'jmx_templates/config_elements/cookie_manager.libsonnet';
local basic_auth_manager = import 'jmx_templates/config_elements/basic_auth_manager.libsonnet';

local summary_report = import 'jmx_templates/listeners/summary_report.libsonnet';
local view_results_tree = import 'jmx_templates/listeners/view_results_tree.libsonnet';


{
  _config:: {},
  'jmx':
  [
    "jmeterTestPlan",
    {
      "version": "1.2",
      "properties": "5.0",
      "jmeter": "5.4.3"
    },
    [ "hashTree" ]
    + test_plan($._config)
  ]
}