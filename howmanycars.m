function a = howmanycars(X, numbercars, road, time, roadsectionlength)
    distances = X(1:numbercars, time);
    a = zeros(1, size(road, 2));
    for i = 1:size(distances, 1)
        for j = 1:size(road, 2)
            if j == size(road, 2)
                if distances(i) >= road(j) && distances(i) < road(j) + roadsectionlength
                    a(j) = a(j) + 1;
                end
            
            
            elseif distances(i) >= road(j) && distances(i) < road(j+1) 
                a(j) = a(j) +1;
            end
        end
    end



end
