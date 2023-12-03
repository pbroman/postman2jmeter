local jsonml = import 'jmx_root_template.libsonnet';

local config_wrapper = import 'config/config_wrapper.libsonnet';
local default_config = import 'config/default_config.libsonnet';

local collection = import 'workdir/postman_collection.json';
local coll_config = config_wrapper('collection', collection);
local env = import 'workdir/postman_environment.json';
local env_config = config_wrapper('env', env);

local config = coll_config + env_config + default_config;

std.manifestXmlJsonml((jsonml + config).jmx )

