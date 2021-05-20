function [header,parsedInfo] = parse_tif_header_mesoscope(tifFn,skipBehavSync)

% [header,parsedInfo] = parseMesoscopeTifHeader(tifFn,skipBehavSync)
% parses tif headers saved by scan image in multi-ROI mode
% INPUT: tiffn is string with file name; skipBehavSync boolean to skip I2C
% data
% OUTPUT: header is the unprocessed header string, parsedInfo is matalb
% data structure

%% 
if nargin < 2; skipBehavSync = false; end

%% hole header
header                      = imfinfo(tifFn);

%% general image info
scopeStr                    = header(1).Software;
parsedInfo.Filename         = header(1).Filename;
parsedInfo.Width            = header(1).Width;
parsedInfo.Height           = header(1).Height;
parsedInfo.AcqTime          = cell2mat(regexp(header(1).ImageDescription,'(?<=epoch = )\[.+?]','match'));
parsedInfo.frameRate        = str2double(cell2mat(regexp(scopeStr,'(?<=SI.hRoiManager.scanVolumeRate = )\d+.\d+','match')));
parsedInfo.interROIlag_sec  = str2double(cell2mat(regexp(scopeStr,'(?<=SI.hScan2D.flytoTimePerScanfield = )\d+.\d+','match')));
%% time stamps and sync
if ~skipBehavSync
  parsedInfo.Timing.Frame_ts_sec = zeros(numel(header),1);
  parsedInfo.Timing.BehavFrames  = cell(numel(header),1);

  for iF = 1:numel(header)
    parsedInfo.Timing.Frame_ts_sec(iF)   = str2double(cell2mat(regexp(header(iF).ImageDescription,'(?<=frameTimestamps_sec = )\d+.\d+','match')));
    thisdata                             = cell2mat(regexp(header(iF).ImageDescription,'(?<=I2CData = ){.+}','match'));
    if isempty(thisdata)
      parsedInfo.Timing.BehavFrames{iF}  = {};
    else
      try
        parsedInfo.Timing.BehavFrames{iF}  = eval(thisdata);
      catch
        parsedInfo.Timing.BehavFrames{iF}  = nan;
      end
%       % transform commas into spaces for sue anns code compatibility
%       commaidx                  = regexp(thisdata,',');
%       thisdata(commaidx(2:end)) = ' ';
%       hidx                      = regexp(header(iF).ImageDescription,'I2CData = {.+}');
%       header(iF).ImageDescription(hidx:hidx+numel(thisdata)) ...
%                                 = sprintf('%s\n',thisdata);
    end
  end
end


%% ROI info
ROIinfo          = header(1).Artist;
ROImarks         = strfind(ROIinfo,'"scanimage.mroi.Roi"');
parsedInfo.nROIs = numel(ROImarks);

for iROI = 1:numel(ROImarks)
  if iROI ~= numel(ROImarks)
    thisROI = ROIinfo(ROImarks(iROI):ROImarks(iROI+1)-1);
  else
    thisROI = ROIinfo(ROImarks(iROI):end);
  end
  
  thisname                                 = cell2mat(regexp(thisROI,'(?<="name": ")\w+\d*','match'));
 if isempty(thisname); thisname = ''; end
  parsedInfo.ROI(iROI).name                = thisname;
  parsedInfo.ROI(iROI).Zs                  = str2double(cell2mat(regexp(thisROI,'(?<="zs": )(|-)\d+','match')));
%   try 
%     parsedInfo.ROI(iROI).Zs                = mesoscopeParams.zFactor .* str2double(cell2mat(regexp(cell2mat(regexp(thisROI,'"zs": (\d|.\d.+)','match')),'(\d|.\d.+)','match'))); 
%   catch
%     temp                                   = regexp(thisROI,'"zs": \[.+\]\n','match');
%     idx                                    = regexp(temp,',\n');
%     temp                                   = temp{1}(1:idx{1}(1)-1);
%     parsedInfo.ROI(iROI).Zs                = eval(cell2mat(regexp(temp,'\[.+\]','match')));
%   end
resolutionFactor                           = mesoscopeParams.xySizeFactor * str2double(cell2mat(regexp(scopeStr,'(?<=SI.objectiveResolution = )\d+.\d+','match')));
  parsedInfo.ROI(iROI).centerXY            = resolutionFactor .* str2num(cell2mat(regexp(thisROI,'(?<="centerXY": )\[.+?]','match')));
  parsedInfo.ROI(iROI).sizeXY              = resolutionFactor .* str2num(cell2mat(regexp(thisROI,'(?<="sizeXY": )\[.+?]','match')));
  parsedInfo.ROI(iROI).rotationDegrees     = str2double(cell2mat(regexp(thisROI,'(?<="rotationDegrees":) (\d+|\d+.\d.+)','match')));
  parsedInfo.ROI(iROI).pixelResolutionXY   = str2num(cell2mat(regexp(thisROI,'(?<="pixelResolutionXY": )\[.+?]','match')));
  parsedInfo.ROI(iROI).discretePlaneMode   = logical(str2double(cell2mat(regexp(thisROI,'(?<="discretePlaneMode":) \d','match'))));
  if ~isempty(regexp(thisROI,'(?<="powers":) \d+','match'))
  parsedInfo.ROI(iROI).Power_percent              = str2double(cell2mat((regexp(thisROI,'(?<="powers":) \d+','match'))));
  end
end
%% microscope info
if isempty(regexp(thisROI,'(?<="powers":) \d+','match'))
parsedInfo.Scope.Power_percent         = str2double(cell2mat(regexp(scopeStr,'(?<=SI.hBeams.powers = )\d+','match')));
else
parsedInfo.Scope.Power_percent         = 'discrete powers per ROI';   
end
parsedInfo.Scope.Channels              = str2double(cell2mat(regexp(scopeStr,'(?<=SI.hChannels.channelSave = )\d+','match')));
parsedInfo.Scope.cfgFilename           = cell2mat(regexp(scopeStr,'(?<=SI.hConfigurationSaver.cfgFilename = \'').+cfg','match'));
parsedInfo.Scope.usrFilename           = cell2mat(regexp(scopeStr,'(?<=SI.hConfigurationSaver.usrFilename = \'').+usr','match'));
parsedInfo.Scope.fastZ_lag             = str2double(cell2mat(regexp(scopeStr,'(?<=SI.hFastZ.actuatorLag = )\d+.\d+','match')));
% flyback between multiple z's
parsedInfo.Scope.fastZ_flybackTime     = str2double(cell2mat(regexp(scopeStr,'(?<=SI.hFastZ.flybackTime = )\d+.\d+','match')));
parsedInfo.Scope.linePeriod            = str2double(cell2mat(regexp(scopeStr,'(?<=SI.hRoiManager.linePeriod = )\d+.\d+e-[0-9]+','match')));
parsedInfo.Scope.scanFramePeriod       = str2double(cell2mat(regexp(scopeStr,'(?<=SI.hRoiManager.scanFramePeriod = )\d+.\d+','match')));
parsedInfo.Scope.scanFrameRate         = str2double(cell2mat(regexp(scopeStr,'(?<=SI.hRoiManager.scanFrameRate = )\d+.\d+','match')));
parsedInfo.Scope.scanVolumeRate        = str2double(cell2mat(regexp(scopeStr,'(?<=SI.hRoiManager.scanVolumeRate = )\d+.\d+','match')));
parsedInfo.Scope.flybackTimePerFrame   = str2double(cell2mat(regexp(scopeStr,'(?<=SI.hScan2D.flybackTimePerFrame = )\d+.\d+','match')));
parsedInfo.Scope.flytoTimePerScanfield = str2double(cell2mat(regexp(scopeStr,'(?<=SI.hScan2D.flytoTimePerScanfield = )\d+.\d+','match')));
parsedInfo.Scope.fovCornerPoints       = resolutionFactor .* str2num(cell2mat(regexp(scopeStr,'(?<=SI.hScan2D.fovCornerPoints = )\[.+?]','match')));
parsedInfo.Scope.stacks_enabled        = cell2mat(regexp(scopeStr,'(?<=SI.hStackManager.enable = )\w+','match'));
if isempty(parsedInfo.Scope.stacks_enabled)
    parsedInfo.Scope.stacks_enabled = 0;
end
if strcmp(parsedInfo.Scope.stacks_enabled, 'true') 
    parsedInfo.Scope.stacks_enabled    = 1;
    parsedInfo.Scope.stackActuator     = cell2mat(regexp(scopeStr,'(?<=SI.hStackManager.stackActuator = \'')\w+','match'));
    parsedInfo.Scope.stackDefinition   = cell2mat(regexp(scopeStr,'(?<=SI.hStackManager.stackDefinition = \'')\w+','match'));   
end
parsedInfo.Scope.motionCorrection_enabled      = cell2mat(regexp(scopeStr,'(?<=SI.hMotionManager.enable = )\w+','match'));
if strcmp(parsedInfo.Scope.motionCorrection_enabled, 'true')
     parsedInfo.Scope.motionCorrection_enabled = 1;
     if strcmp(cell2mat(regexp(scopeStr,'(?<=SI.hMotionManager.correctionEnableZ = )\w+','match')), 'true')
     parsedInfo.Scope.motionCorMode    = 'automated';
     else
      parsedInfo.Scope.motionCorMode   = 'manual';   
     end
else
     parsedInfo.Scope.motionCorrection_enabled = 0;
end

%% remote focus (i.e. fast) Zs and depths
if ~isempty(cell2mat(regexp(scopeStr,'SI.hFastZ.numFramesPerVolume = [0-9]+','match')))
parsedInfo.nDepths          = str2double(cell2mat(regexp(scopeStr,'(?<=SI.hFastZ.numFramesPerVolume = )\d+','match')));
else
    if strcmp(parsedInfo.Scope.stacks_enabled, 'true') 
    parsedInfo.nDepths          = str2double(cell2mat(regexp(scopeStr,'(?<=SI.hStackManager.actualNumSlices = )\d+','match'))); 
    else
    parsedInfo.nDepths          = 1;    
    end
end
try
  %MDia: there is no userZs field in newer SI version (also not sure what's the purpose of all these try catches)   
  parsedInfo.Zs             = mesoscopeParams.zFactor .* eval(cell2mat(regexp(scopeStr,'(?<=SI.hFastZ.userZs = ).\[(.\d+.)+\]','match')));
catch
  try
    parsedInfo.Zs           = mesoscopeParams.zFactor .* eval(cell2mat(regexp(scopeStr,'(?<=SI.hFastZ.userZs = )\d+','match')));
  catch
   try
    parsedInfo.Zs           = str2num(cell2mat(regexp(scopeStr,'(?<=SI.hFastZ.userZs = )\[.+?]','match')));
   catch
      if strcmp(parsedInfo.Scope.stacks_enabled, 'true')  
      parsedInfo.Zs           = str2num(cell2mat(regexp(scopeStr,'(?<=SI.hStackManager.zs = )\[.+?]','match')));
       else
      parsedInfo.Zs           = str2double(cell2mat(regexp(scopeStr,'(?<=SI.hFastZ.position = )(|-)\d+','match')));
       end     
  end
  end
end
