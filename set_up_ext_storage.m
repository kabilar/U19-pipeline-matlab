function set_up_ext_storage()
%Set up dj configuration for our external storage tables

%Get ext_storage_path based on OS
if ispc
    ext_storage_path = '\\cup.pni.princeton.edu\u19_dj\external_dj_blobs\';
elseif u19_dj_utils.is_this_spock

    ext_storage_path = '/mnt/cup/u19_dj/external_dj_blobs/';

elseif isunix
    ext_storage_path = '/Volumes/u19_dj/external_dj_blobs/';
end

%Configure dj dictionary
u19_storage = struct('protocol', 'file',...
    'location', ext_storage_path);
dj.config('stores.extstorage', u19_storage)

%Get current directory and u19 directory
this_dir = pwd;
u19_path = mfilename('fullpath');
u19_path = fileparts(u19_path);

%Save local configuration on proper path
cd(u19_path);
dj.config.saveLocal()
cd(this_dir);

end

