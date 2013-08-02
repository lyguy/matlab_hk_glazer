function testHashs()
%TESTHASHS Summary of this function goes here
%   Detailed explanation goes here

datapath = glazer.tests.getDataPath();
infile = [datapath '/' 'hashGold.txt'];
goldHash = '6f0c57f4470ad360faeb8994a2528184f0480883';

str = fileread(infile);
hashOpts = struct('Method', 'SHA-1', 'Format', 'hex');
hash = glazer.DataHash.DataHash(str,hashOpts);
assertEqual(goldHash, hash);
end

