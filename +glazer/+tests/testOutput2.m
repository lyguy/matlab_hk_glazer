function testOutput2()

datapath = glazer.tests.getDataPAth();
infile = [datapath 'input_gold2.txt'];

pass = glazer.tests.outputEqual(infile);

if ~(pass)
  error('testOutput2:notEqual', 'Gold and gotten mismatch.') 
end