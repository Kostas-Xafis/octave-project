1;
function C=populate_criteria(n)
	C = ones(1,n).*rand(1,n);
	
	% Check if C has at least a cell with value 1
	has_one = false;
	for i=1:n
		if C(i) == 1
			has_one = true;
			break;
		end
	end
	if ~has_one
		rand_index = randi([1 n],1,1);
		C(rand_index) = 1;
	end
endfunction
