function populate_ScanInfo_spock(key)

%Populate Scaninfo (from recording handler pipeline)
startup_u19_pipeline_matlab_spock

if nargin < 1
    populate(imaging_rec.ScanInfo);
else
    populate(imaging_rec.ScanInfo, key);
     
end

s = dj.conn;
s.close();

end