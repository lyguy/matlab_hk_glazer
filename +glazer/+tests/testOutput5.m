function testOutput5()

datapath = glazer.tests.getDataPath();
infile = [datapath '/' 'input_gold5.txt'];

pass = glazer.tests.outputEqual(infile);

if ~(pass)
  error('testOutput5:notEqual', 'Gold and gotten mismatch.') 
end