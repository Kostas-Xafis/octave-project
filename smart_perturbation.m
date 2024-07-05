1;
source('./map.m');
% Perturb the criteria matrix and returns their normalized weights
function wnew = perturb_criteria(C,s)
	[nx, ny] = size(C);
	wnew = ones(nx, ny);

	for i = 1:nx
		wnew(i) = map(C(i) + C(i) * s * (rand-0.5), 10, 100, 10, 100); %Perturb the Ci criteria
	end

	csum = sum(wnew);
	for i = 1:nx
		wnew(i) = wnew(i) / csum; %Normalize the criteria
	end	

endfunction
