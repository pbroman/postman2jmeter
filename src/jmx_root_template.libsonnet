local test_plan = import 'jmx_components/test_plan.libsonnet';

local user_defined_variable = import 'jmx_components/config_elements/fragments/user_defined_variable.libsonnet';
local cookie_manager = import 'jmx_components/config_elements/cookie_manager.libsonnet';
local basic_auth_manager = import 'jmx_components/config_elements/basic_auth_manager.libsonnet';

local summary_report = import 'jmx_components/listeners/summary_report.libsonnet';
local view_results_tree = import 'jmx_components/listeners/view_results_tree.libsonnet';


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
    // + cookie_manager()
    // + basic_auth_manager
    // TODO add elements here ... :-)
    //+ summary_report()
    //+ view_results_tree()
  ]
}