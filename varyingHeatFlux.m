clear all
close all

%  i think not really necessary 
% tomorrow try to run manully
lVaryingHeatFlux = [];
pVaryingHeatFlux = [];

i = 1;
for q = [3.4,5.2,7.0]*1e5
    main
    [row0,col0] = size(lVaryingHeatFlux);
    [row1,col1] = size(l);
    if col1 >= col0
        lVaryingHeatFlux(i,col1) = 0;
        lVaryingHeatFlux = [lVaryingHeatFlux;l];
    end
    if col1 < col0
        l(col0) = 0;
        llVaryingHeatFlux = [lVaryingHeatFlux;l];
    end

    i = i+1;
end
