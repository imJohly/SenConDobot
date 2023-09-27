function [] = MoveObject(object,position)
%MoveObject Takes an object and moves it to a specific position

    vertices = get(object,'Vertices');
    transformedVertices = [vertices,ones(size(vertices,1),1)] * position';
    set(object,'Vertices',transformedVertices(:,1:3));

end