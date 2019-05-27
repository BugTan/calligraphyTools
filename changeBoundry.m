function imgbw = changeBoundry(imgbwSDF,distance)
    [h,w] = size(imgbwSDF);
    imgbw = false(h,w);

    for i = 1:h
        for j = 1:w
%             if distance <= 0
                if  imgbwSDF(i,j) > distance
                    %-i*44/h
                    imgbw(i,j) = 1;
                end
                
%             elseif distance > 0
%                 if  imgbwSDF(i,j) > distance-i*44/h
%                     imgbw(i,j) = 1;
%                 end
%             end
        end       
    end
end