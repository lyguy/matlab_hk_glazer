function datapath = getDataPath()
thisFileName = mfilename('fullpath');
datapath = [fileparts(thisFileName) '/data'];
end