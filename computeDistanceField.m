function [imgbwSDF,ridgeLine] = computeDistanceField(imgbw)
%%%%%计算距离长，并返回脊线

    [h,w] = size(imgbw);
    
    neighborPoint = [-1,-1;
                     -1,0;
                     -1,1;
                     0,-1;
                     0,1;
                     1,-1;
                     1,0;
                     1,1];
    lenNP = length(neighborPoint);
    ridgeLine = [];
    %计算边界
    se = [1,1,1;
          1,1,1;
          1,1,1];
    imgbw_bdry = logical(imgbw - imerode(imgbw,se));    
   % imgbw_bdry_index = bwboundaries(imgbw,'holes');
    imgbwSDF =  bwdist(imgbw_bdry ,'euclidean');
    
    %计算每一个像素的到边界的距离   
    for i = 1:h
        for j = 1:w
            if imgbw(i,j) == 1  %在字的范围内距离就为正
                imgbwSDF(i,j) = imgbwSDF(i,j);
            else
                imgbwSDF(i,j) = -imgbwSDF(i,j);
            end
        end    
    end  
    
    %先找出局部最大值点
    for i = 2:h-1
        for j = 2:w-1
            numGreaterPiont = 0;
            for k=1:lenNP
                if imgbwSDF(i,j) > imgbwSDF(i+neighborPoint(k,1),j+neighborPoint(k,2))
                   numGreaterPiont = numGreaterPiont + 1; 
                end
                if numGreaterPiont >= lenNP
                    ridgeLine = [ridgeLine;i,j];
                end
            end
        end    
    end
    
end

% 采用的是扫描的方法速度相当慢
% function nearestPiont = computeNearestPoint(x,y, imgbw_bdry_index)
%     nearestPiont.distance = Inf;
%     nearestPiont.Num = 0;
%     nearestPiont.P = [];
%     for i = 1:length(imgbw_bdry_index)
%         for j = 1:size(imgbw_bdry_index{i})-1
%             distanceTmp = sqrt( (x - imgbw_bdry_index{i}(j,1))^2 + (y - imgbw_bdry_index{i}(j,2))^2);
%             if distanceTmp < nearestPiont.distance
%                 nearestPiont.distance  = distanceTmp;
%                 nearestPiont.Num = 1;
%                 nearestPiont.P = [x,y];
%             elseif distanceTmp == nearestPiont.distance
%                 nearestPiont.Num = nearestPiont.Num + 1;
%                 pointTmp = [x,y];
%                 nearestPiont.P = [nearestPiont.P;pointTmp];
%             end
%         end
%     end
% end