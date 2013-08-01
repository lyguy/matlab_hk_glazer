function testOutput1()
%Test
datapath = glazer.tests.getDataPath();
infile = [datapath '/' 'input_gold1.txt'];

pass = glazer.tests.outputEqual(infile);

if ~(pass)
  error('testOutput1:notEqual', 'Gold and gotten mismatch.') 
end