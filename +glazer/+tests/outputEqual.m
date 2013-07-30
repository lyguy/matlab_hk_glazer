function pass = outputEqual(infile)


sIn = fileread(infile);
M = glazer.degreeToMaps(sIn);
sOut = glazer.mapToDegrees(M);
pass = isequal(sIn, sOut);
end