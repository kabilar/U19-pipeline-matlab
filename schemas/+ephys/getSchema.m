function obj = getSchema
prefix = getenv('DB_PREFIX_TEST');
persistent schemaObject
if isempty(schemaObject)
    schemaObject = dj.Schema(dj.conn, 'ephys', [prefix 'ephys']);
end
obj = schemaObject;
end
