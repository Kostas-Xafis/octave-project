1;
% Return the susceptibility level based on the average difference between the original utility values
function [susceptibility_lvl, susceptibility_lvl_full, susceptibility_chart_color] = susceptibility(mean_diff)
    susceptibility_lvl="";
    susceptibility_lvl_full="";
    susceptibility_chart_color = "";
    if mean_diff <= 0.015 % <= 1.5% avg difference
        %high susceptibility
        susceptibility_lvl = "hs"; 
        susceptibility_lvl_full = "High susceptibility level";
        susceptibility_chart_color = "#dc0925";
    elseif mean_diff <= 0.03 % <= 3% avg difference
        %medium susceptibility
        susceptibility_lvl = "ms"; 
        susceptibility_lvl_full = "Medium susceptibility level";
        susceptibility_chart_color = "#110cf1";
    else % > 3% avg difference
        %low susceptibility
        susceptibility_lvl = "ls"; 
        susceptibility_lvl_full = "Low susceptibility level";
        susceptibility_chart_color = "#82f22c";
    end
endfunction