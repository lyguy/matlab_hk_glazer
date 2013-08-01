function testOutput4()

datapath = glazer.tests.getDataPath();
infile = [datapath '/' 'input_gold4.txt'];

pass = glazer.tests.outputEqual(infile);

if ~(pass)
  error('testOutput4:notEqual', 'Gold and gotten mismatch.') 
end