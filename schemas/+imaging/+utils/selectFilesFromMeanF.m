function [lastGoodFile,lastGoodFrame] = selectFilesFromMeanF(rec,FDecreaseThreshold)

% lastGoodFrame = selectFilesFromMeanF(rec,FDecreaseThreshold)
% estimate bleaching by loading only first frame in each file, for speed

if nargin < 1 || isempty(rec); rec = pwd; end
if nargin < 2; FDecreaseThreshold  = 15;  end

%% loop through tifs and calculate mean frame Fluorescence

tic
fprintf('estimating bleaching')

%% load tifs and calculate mean fluorescence per frame

tifls      = dir([formatFilePath(rec) '*tif']);
tifls      = cellfun(@(x)([formatFilePath(rec) x]),{tifls(:).name},'uniformoutput',false);
nFiles     = numel(tifls);
meanF      = zeros(nFiles,1);
ct         = 1;
frameID    = zeros(nFiles,1);

for iFile = 1:nFiles
  fprintf('.')
  % read just the first frame of each file
  imheader   = imfinfo(tifls{iFile});
  nFrames    = numel(imheader);  
  readObj    = Tiff(tifls{iFile},'r');
  readObj.setDirectory(1);
  thisstack  = readObj.read();
  readObj.close();
  meanF(iFile)      = mean(mean(thisstack(1:512,:,:),1),2);
  frameID(iFile)    = ct;
  ct                = ct + nFrames;                
end

%% estimate best fitting line for fluorescence decay
x       = frameID;
try
  betas = robustfit(x,meanF);
catch
  betas = fit(x,meanF,'poly1');
  betas = [betas.p2; betas.p1];
end

yhat          = betas(1)+x.*betas(2);
lastGoodFile  = find(yhat > yhat(1) - (FDecreaseThreshold/100)*yhat(1),1,'last');
if isempty(lastGoodFile); lastGoodFile = nFiles; end
cumFrames     = cumsum(frameID);
lastGoodFrame = cumFrames(lastGoodFile);

fprintf(' done after %1.1f min\n',toc/60)
