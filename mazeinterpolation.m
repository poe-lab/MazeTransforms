function [interpolated_array] = mazeinterpolation(input_array)
% Column1 input_array = timestamp
% Column2 input_array = linear maze position

ia = input_array; % for the sake of brevity

n = 0;
for k = 1:length(ia(:,1))
    if k ~= length(ia(:,1))
        if (ia(k+1,2)-ia(k,2) > 1.0)||(ia(k+1,2)-ia(k,2) < -1.0)
            n = n + 1;
        end
    end
end

if n ~= 0
       new_TSc = cell(n,1);
     new_distc = cell(n,1);
     time_diff = zeros(n,1);
     dist_diff = zeros(n,1);
    newTScount = zeros(n,1);
      time_int = zeros(n,1);
      dist_int = zeros(n,1);

    n = 0;
    for k = 1:length(ia(:,1))
        if k ~= length(ia(:,1))
            if ia(k+1,2)-ia(k,2) > 1.0
                n = n + 1;

                 time_diff(n) = ia(k+1,1)-ia(k,1);
                 dist_diff(n) = ia(k+1,2)-ia(k,2);

                newTScount(n) = int32(dist_diff(n)*2);
                newTScount(n) = double(newTScount(n));

                  time_int(n) = time_diff(n)/newTScount(n);
                  dist_int(n) = dist_diff(n)/newTScount(n);

                for l = 1:newTScount(n)                
                      new_TSa(l,1) = ia(k,1) + time_int(n)*l;
                    new_dista(l,1) = ia(k,2) + dist_int(n)*l;
                end

                   new_TSc{n} = new_TSa;
                 new_distc{n} = new_dista;

            elseif ia(k+1,2)-ia(k,2) < -1.0
                n = n + 1;

                 time_diff(n) = ia(k+1,1)-ia(k,1);
                 dist_diff(n) = ia(k+1,2)-ia(k,2);

                newTScount(n) = int32(abs(dist_diff(n)*2));
                newTScount(n) = double(newTScount(n));

                  time_int(n) = time_diff(n)/newTScount(n);
                  dist_int(n) = dist_diff(n)/newTScount(n);

                for l = 1:newTScount(n)                
                      new_TSa(l,1) = ia(k,1) + time_int(n)*l;
                    new_dista(l,1) = ia(k,2) + dist_int(n)*l;
                end

                   new_TSc{n} = new_TSa;
                 new_distc{n} = new_dista;
            end
        end
    end

      new_TS = cell2mat(new_TSc);
    new_dist = cell2mat(new_distc);
    addendum(:,1) = new_TS;
    addendum(:,2) = new_dist;

    interpolated_cell = cell(2,1);
    interpolated_cell{1} = input_array;
    interpolated_cell{2} = addendum;
    interpolated_array = cell2mat(interpolated_cell);
    interpolated_array = sortrows(interpolated_array,1);
    
elseif n == 0
    
    interpolated_array = input_array;

end

end

