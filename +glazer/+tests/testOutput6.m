function testOutput6()

datapath = glazer.tests.getDataPath();
infile = [datapath '/' 'input_gold6.txt'];

pass = glazer.tests.outputEqual(infile);

if ~(pass)
  error('testOutput6:notEqual', 'Gold and gotten mismatch.') 
end