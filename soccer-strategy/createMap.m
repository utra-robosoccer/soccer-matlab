function fieldOccupancy = createmap()
    fieldOccupancy = zeros(90,60);
    fieldOccupancy(1,:) = 1;
    fieldOccupancy(end,:) = 1;
    fieldOccupancy(:,1) = 1;
    fieldOccupancy(:,end) = 1;