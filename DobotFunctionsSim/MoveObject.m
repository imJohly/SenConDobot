function [] = MoveObject(object,position,vertices)
%MoveObject Takes an object and moves it to a specific position
    
    transformedVertices = [vertices,ones(size(vertices,1),1)] * position';
    set(object,'Vertices',transformedVertices(:,1:3));

end