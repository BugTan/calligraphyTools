function [imgbwSDF,ridgeLine] = computeVerDistanceField(imgbw)
%%%%%������볤�������ؼ���

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
    %����߽�
    se = [1,1,1;
          1,1,1;
          1,1,1];
    imgbw_bdry = logical(imgbw - imerode(imgbw,se));    
   % imgbw_bdry_index = bwboundaries(imgbw,'holes');
    imgbwSDF =  bwdist(imgbw_bdry ,'euclidean');
    
    %����ÿһ�����صĵ��߽�ľ���   
    for i = 1:w
        [row ,col] = find(imgbwSDF(:,i)==0);
        if isempty(col)
            imgbwSDF(:,i) = -Inf;
            continue;
        else
            for j = 1:h
                imgbwSDF(j,i) = Inf;
                for k = 1:length(row)
                    temp = abs(j-row(k));
                    if imgbwSDF(j,i) ~= 0 && temp < imgbwSDF(j,i)
                        imgbwSDF(j,i) = temp;
                    end
                end
                if imgbw(j,i) == 1  %���ֵķ�Χ�ھ����Ϊ��
                    imgbwSDF(j,i) = imgbwSDF(j,i);
                else
                    imgbwSDF(j,i) = -imgbwSDF(j,i);
                end
            end
        end

    end  
    
    %���ҳ��ֲ����ֵ��
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

% ���õ���ɨ��ķ����ٶ��൱��
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