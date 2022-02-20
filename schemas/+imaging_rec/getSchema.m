function obj = getSchema
prefix = getenv('DB_PREFIX_TEST');
persistent schemaObject
if isempty(schemaObject)
    schemaObject = dj.Schema(dj.conn, 'imaging_rec', [prefix 'imaging_rec']);
end
obj = schemaObject;
end
