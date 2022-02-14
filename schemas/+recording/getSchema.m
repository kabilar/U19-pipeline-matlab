function obj = getSchema
prefix = getenv('DB_PREFIX_TEST');
persistent schemaObject
if isempty(schemaObject)
    schemaObject = dj.Schema(dj.conn, 'recording', [prefix 'recording']);
end
obj = schemaObject;
end
