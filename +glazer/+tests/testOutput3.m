function testOutput3()

datapath = glazer.tests.getDataPath();
infile = [datapath '/' 'input_gold3.txt'];

pass = glazer.tests.outputEqual(infile);

if ~(pass)
  error('testOutput3:notEqual', 'Gold and gotten mismatch.') 
end