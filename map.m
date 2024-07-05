1;
function mapped_values = map(arr, A, B, C, D)
    % Validate input ranges
    if A == B
        error('Range [A, B] cannot be zero length.');
    end
    
    if C == D
        error('Range [C, D] cannot be zero length.');
    end

    % Calculate the scaling factor
    scale = (D - C) / (B - A);
    
    % Apply the linear transformation to map values
    mapped_values = C + scale * (arr - A);
    
    % Clamp the values to the target range [C, D]
    mapped_values = max(C, min(D, mapped_values));
end