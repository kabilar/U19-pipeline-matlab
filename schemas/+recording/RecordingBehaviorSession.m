%{
-> recording.Recording
---
-> acquisition.Session
%}
 
classdef RecordingBehaviorSession < dj.Part
    properties(SetAccess=protected)
        master = recording.Recording
    end
     
end
