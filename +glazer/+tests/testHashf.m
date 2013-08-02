function testHashf()
%TESTHASHS Summary of this function goes here
%   Detailed explanation goes here

datapath = glazer.tests.getDataPath();
infile = [datapath '/' 'hashGold.txt'];
goldHash = '6f0c57f4470ad360faeb8994a2528184f0480883';

hashOpts = struct('Method', 'SHA-1', 'Format', 'hex', 'Input', 'file');
hash = glazer.DataHash.DataHash(infile, hashOpts);
assertEqual(goldHash, hash);
end

