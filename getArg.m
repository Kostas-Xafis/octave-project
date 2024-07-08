1;
% Convert a stringed argument value to a number, if it is a number
function argm = getNumArg(args, flags, default)
    if length(args) < 1
        argm = default;
        return;
    end
    argm = default;
    for i=1:length(args)
        for j=1:length(flags)
            if strcmp(args{i}, flags{j}) 
                argm = str2num(args{i+1});
                break;
            end
        end
        if argm != default
            break;
        end
    end
end

function argm = getStrArg(args, flags, default)
    if length(args) < 1
        argm = default;
        return;
    end
    argm = default;
    for i=1:length(args)
        for j=1:length(flags)
            if strcmp(args{i}, flags{j}) 
                argm = args{i+1};
                break;
            end
        end
        if strcmp(argm, default) == 0
            break;
        end
    end

    % Remove quotes from the argument, if they exist
    arg_len = length(argm);
    if ((argm(1) == '"') && (argm(end) == '"')) || ((argm(1) == "'") && (argm(end) == "'"))
        argm = argm(2:end-1);
    end
end