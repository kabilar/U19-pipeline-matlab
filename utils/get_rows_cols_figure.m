function [num_rows,num_cols] = get_rows_cols_figure(num_plots, fig_size)

% Check width vs height relation
fig_rel = fig_size(1) / fig_size(2);

num_rows = 1;
num_cols = 1;
while 1
    
    %Add rows and columns to closely match desired width height relationship and surpass number of desired plots
    ac_rel = num_cols / num_rows;
    
    if num_cols * num_rows >= num_plots
        break
    end
    
    if ac_rel >= fig_rel
        num_rows = num_rows + 1;
    else
        num_cols = num_cols +  1;
    end
    
end
