function obj = getSchema
prefix = getenv('DB_PREFIX_TEST');
persistent schemaObject
if isempty(schemaObject)
    schemaObject = dj.Schema(dj.conn, 'ephys_rec', [prefix 'ephys_rec']);
end
obj = schemaObject;
end
