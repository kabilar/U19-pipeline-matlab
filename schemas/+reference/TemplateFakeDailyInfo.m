%{
# Daily Info template for the information of each column
-> reference.Template
field                       : varchar(64)                   # field name
---
description                 : varchar(255)                  # description of this field
grouping                    : varchar(16)                   # 
identifier                  : varchar(64)                   # 
data                        : blob                          # cell array of the data types
mandatory                   : enum('yes','no')              # 
is_dynamic                  : enum('yes','no')              # isDynamic for the original template
is_filter                   : enum('yes','no')              # isFilter for the original template
is_trials                   : enum('yes','no')              # isTrials for the original template
plot_index                  : int                           # index of where to plot in GUI
%}

classdef TemplateFakeDailyInfo < dj.Part
    properties(SetAccess=protected)
        master = reference.Template
    end
end
