function b = velocityheatmap(X, numbercars, road, time, roadsectionlength)
% similar structure to howmanycars.m
    distances = X(1:numbercars, time);
    velocities = X(numbercars+1:end, time);
    a = zeros(1, size(road, 2));
    summed_velc = zeros(1, size(road,2));
    for i = 1:size(distances, 1)
        for j = 1:size(road, 2)
            if j == size(road, 2)
                if distances(i) >= road(j) && distances(i) < road(j) + roadsectionlength
                    a(j) = a(j) + 1;
                    summed_velc(j) = summed_velc(j) + velocities(i);
                end
                
            elseif distances(i) >= road(j) && distances(i) < road(j+1) 
                a(j) = a(j) +1;
                summed_velc(j) = summed_velc(j) + velocities(i);
            end
        end
    end
%     b = summed_velc./a;  % can't do this because there are zeros. 

    for k = 1:size(a, 2)
        if a(k) == 0
            b(k) = 0;
        else
            b(k) = summed_velc(k)/a(k);
        end
%         
%         b(k) = summed_velc(k)/a(k);    
end
