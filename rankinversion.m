1;
% S: Source is the utility results from ahp_f.m
% T: The array to test if it holds ranking properly
function [N]=rankinversion(S, T)
  	[n] = length(T);

	N = 1; % Assume the array is not ranked properly
	for i = 1:n-1
		diffS = S(i+1) - S(i);
        diffT = T(i+1) - T(i);
		if (diffS >= 0 && diffT >= 0) || (diffS <= 0 && diffT <= 0)
			N = 0;
		else 
			N = 1;
			break;
		end
	end

endfunction