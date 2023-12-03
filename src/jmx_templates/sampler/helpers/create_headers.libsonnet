local header_manager = import '../../config_elements/header_manager.libsonnet';

function(request)

local helper_object = { 'headers' : request.header +
  if std.objectHas(request, 'auth') && request.auth.type == 'bearer'
    then [{key:'Authorization', value: request.auth.bearer[0].value }]
    else []
};

local pruned = std.prune(helper_object);
if std.objectHas(pruned, 'headers') then header_manager(pruned.headers) else []
