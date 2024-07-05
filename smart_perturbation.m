1;
source('./map.m');
% Perturb the criteria matrix and returns the normalized weights
function wnew = perturb_criteria(C,s)
	[nx, ny] = size(C);
	wnew = ones(nx, ny);

	for i = 1:nx
		% C(i) + C(i) * s * (rand-0.5) is the perturbation of the i-th criteria
		% map is used to clamp the perturbated value so that it doesn't exceed the range [10, 100]
		wnew(i) = map(C(i) + C(i) * s * (rand-0.5), 10, 100, 10, 100); 
	end

	csum = sum(wnew);
	for i = 1:nx
		wnew(i) = wnew(i) / csum; %Normalized weights
	end	

endfunction
