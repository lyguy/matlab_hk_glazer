function testHashf()
%TESTHASHS Summary of this function goes here
%   Detailed explanation goes here

datapath = glazer.tests.getDataPath();
infile = [datapath '/' 'hashGold.txt'];
goldHash = '6F0C57F4470AD360FAEB8994A2528184F0480883';

hash = reshape(glazer.hash.sha1f(infile),1,[]);
assertEqual(goldHash, hash);
end

