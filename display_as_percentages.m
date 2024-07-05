1;
function display_as_percentages(matrix)
    % Convert the matrix values from 0-1 range to 0-100 range
    percentage_matrix = matrix * 100;
    
    % Get the dimensions of the matrix
    [rows, cols] = size(percentage_matrix);
    
    % Display the matrix as percentages with the '%' character
    for i = 1:rows
        for j = 1:cols
            % Print each value with a percentage sign
            fprintf('%.2f%%\t', percentage_matrix(i, j));
        end
        fprintf('\n');
    end
end
