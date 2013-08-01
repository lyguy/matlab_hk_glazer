function testEntryGetter()
%Test the EntryGetter class

datapath = glazer.tests.getDataPath();
infile = [datapath '/' 'EntryGetterTest.txt'];

gold1 = 'one';
gold2 = '2';
gold3 = 'tree';

str = fileread(infile);
eG = glazer.EntryGetter(str);

got1 = eG.linePos(1, 1);
got2 = eG.linePos(2, 2);
got3 = eG.linePos(5, 3);

if ~isequal(gold1, got1) | ~isequal(gold2, got2) | ~isequal(gold3, got3)
  error('testEntryGetter:notEqual', 'Gold and gotten mismatch.');
end

end