function [fmouse,fdate,fgenotype] = mouseAndDateFromFileName(fn)

% [fmouse,fdate,fgenotype] = mouseAndDateFromFileName(fn)

%% mouse name (try 4 characters first)


temp      = regexp(fn,'[/][a-z][a-z][0-9][0-9]','match');
if isempty(temp)
  temp  = regexp(fn,'[/][a-z][a-z][0-9]','match');
end
if isempty(temp)
  temp  = regexp(fn,'[/][a-z][a-z][0-9][a-z]','match');
end
if isempty(temp)
  temp  = regexp(fn,'[/][a-z][0-9][0-9]','match');
end
if isempty(temp)
  temp  = regexp(fn,'[/][a-z][0-9]','match');
end
if isempty(temp)
  temp  = regexp(fn,'[/][A-Z][0-9][0-9][0-9]','match');
end
if isempty(temp)
  temp  = regexp(fn,'[/][A-Z][0-9][0-9]','match');
end

% for running on windows (fullfile will return paths with backslashes)
if ~isempty(temp)
  fmouse = temp{1}(2:end);
else
temp      = regexp(fn,'[\\][a-z][a-z][0-9][0-9]','match');
if isempty(temp)
  temp  = regexp(fn,'[\\][a-z][a-z][0-9]','match');
end
if isempty(temp)
  temp  = regexp(fn,'[\\][a-z][a-z][0-9][a-z]','match');
end
if isempty(temp)
  temp  = regexp(fn,'[\\][a-z][0-9][0-9]','match');
end
if isempty(temp)
  temp  = regexp(fn,'[\\][a-z][0-9]','match');
end
if isempty(temp)
  temp  = regexp(fn,'[\\][A-Z][0-9][0-9][0-9]','match');
end
if isempty(temp)
  temp  = regexp(fn,'[\\][A-Z][0-9][0-9]','match');
end    
end

if ~isempty(temp)
  fmouse = temp{1}(2:end);
else
  temp      = regexp(fn,'[_][a-z][a-z][0-9][0-9]','match');
  if isempty(temp)
    temp  = regexp(fn,'[_][a-z][a-z][0-9]','match');
  end
  if isempty(temp)
    temp  = regexp(fn,'[_][a-z][a-z][0-9][a-z]','match');
  end
  if isempty(temp)
    temp  = regexp(fn,'[_][a-z][0-9][0-9]','match');
  end
  if isempty(temp)
    temp  = regexp(fn,'[_][a-z][0-9]','match');
  end
  if isempty(temp)
    temp  = regexp(fn,'[_][A-Z][0-9][0-9][0-9]','match');
  end
  if isempty(temp)
    temp  = regexp(fn,'[_][A-Z][0-9][0-9]','match');
  end
end

if ~isempty(temp)
  fmouse = temp{1}(2:end);
else
   temp      = regexp(fn,'[a-z][a-z][0-9][0-9]','match');  
if isempty(temp)
  temp  = regexp(fn,'[a-z][a-z][0-9]','match'); 
  end
  if isempty(temp)
    temp  = regexp(fn,'[a-z][a-z][0-9][a-z]','match');
  end
  if isempty(temp)
    temp  = regexp(fn,'[a-z][0-9][0-9]','match');
  end
  if isempty(temp)
    temp  = regexp(fn,'[a-z][0-9]','match');
  end
  if isempty(temp)
    temp  = regexp(fn,'[A-Z][0-9][0-9][0-9]','match');
  end
  if isempty(temp)
    temp  = regexp(fn,'[A-Z][0-9][0-9]','match');
  end
  if isempty(temp)
    fmouse = [];
  else
    fmouse = temp{1};
  end
end

%% date
temp     = regexp(fn,'[0-9]{8,}','match');
if isempty(temp)
  fdate  = [];
else
  fdate  = temp{1};
end
%% genotype
if isempty(fmouse)
  fgenotype   = [];
else
  if strcmpi(fmouse(1:2),'vg')
    fgenotype = 'vgat';
  elseif strcmpi(fmouse(1:2),'wt')
    fgenotype = 'wt';
  elseif strcmpi(fmouse(1),'k') && eval([fmouse(2:end) '< 48'])
    fgenotype = 'thy1';
  elseif strcmpi(fmouse(1:2),'ty')
    fgenotype = 'yfp';
  elseif strcmpi(fmouse(1),'B')
    fgenotype = 'datcre';
  elseif strcmpi(fmouse(1),'sp')
    fgenotype = 'snap25';
  else
    fgenotype = 'ai93';
  end
end