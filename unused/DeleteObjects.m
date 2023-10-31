function [] = DeleteObjects(varargin)
%DeleteObjects Used to delete the specified objects

    for i = 1:numel(varargin)
    
        try
            delete(varargin{i})
        catch
            warning(['Could not delete input ',num2str(i)])
        end
    
    end

end

