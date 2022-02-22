clear all

% Get database credentials
dj_config = jsondecode(fileread('dj_local_conf.json'));

if isfield(dj_config, 'custom')
   if isfield(dj_config.custom, 'database_prefix')
       db_prefix = dj_config.custom.database_prefix;
   end
end

setenv('DJ_HOST', dj_config.database_host)
setenv('DJ_USER', dj_config.database_user)
setenv('DJ_PASS', dj_config.database_password)
setenv('DB_PREFIX', db_prefix)

dj.conn(getenv('DJ_HOST'), getenv('DJ_USER'), getenv('DJ_PASSWORD'))
