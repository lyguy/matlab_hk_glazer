% Copyright 2013 Lyman Gillispie
% This code is distributed under the MIT License
% Author: Lyman Gillispie

function c = degreeToMaps(s)
% degreeToMaps
% Load strings containing valid DEBaM/DETIM v1.x.x input.txt files
% into MATLAB containers.Map dictionaries, which may be manipulated.
%
% Args: s - String containing a full "input.txt" config file
% Returns: c - MATLAB containers.Map object, whose keys are the
% names of parameters set in "input.txt" and whose values are the values
% from said config file.
%
% e.g 
% > s = fileread("input.txt");
% > c = glazer.degreeToMaps(s);
% > c('inpath') 
%  
%  ans = "/Users/luser/meltmodel/data/"
%

  %EntryGetter is object created in @EntryGetter/EntryGetter.m 
  eg = glazer.EntryGetter(s);   %s=input.txt
  
  c = containers.Map();
  
  c('daysscreenoutput') = toInt(eg.linePos(3, 1)); %line 3, word 1, convert to integer
  c('inpath') = (eg.linePos(4, 1));
  c('outpath') = (eg.linePos(5, 1));
  c('jdbeg') = toInt(eg.linePos(6, 1));
  c('yearbeg') = toInt(eg.linePos(6, 2));
  c('jdend') = toInt(eg.linePos(7, 1));
  c('yearend') = toInt(eg.linePos(7, 2));
  c('disyes') = toInt(eg.linePos(8, 1));
  c('calcgridyes') = toInt(eg.linePos(9, 1));
  
  c('maxmeltstakes') = toInt(eg.linePos(11, 1));
  c('plusminus') = toInt(eg.linePos(12, 1));
  c('do_out') = toInt(eg.linePos(13, 1));

  c('shayes') = toInt(eg.linePos(15, 1));
  c('exkyes') = toInt(eg.linePos(15, 2));
  c('solyes') = toInt(eg.linePos(15, 3));
  c('diryes') = toInt(eg.linePos(15, 4));
  c('dir2yes') = toInt(eg.linePos(15, 5));
  c('difyes') = toInt(eg.linePos(15, 6));
  c('gloyes') = toInt(eg.linePos(15, 7));
  c('albyes') = toInt(eg.linePos(15, 8));
  c('swbyes') = toInt(eg.linePos(15, 9));
  c('linyes') = toInt(eg.linePos(15, 10));
  c('loutyes') = toInt(eg.linePos(15, 11));
  c('netyes') = toInt(eg.linePos(17, 1));
  c('senyes') = toInt(eg.linePos(17, 2));
  c('latyes') = toInt(eg.linePos(17, 3));
  c('raiyes') = toInt(eg.linePos(17, 4));
  c('enbyes') = toInt(eg.linePos(17, 5));
  c('melyes') = toInt(eg.linePos(17, 6));
  c('ablyes') = toInt(eg.linePos(17, 7));
  c('surftempyes') = toInt(eg.linePos(17, 8));
  c('posyes') = toInt(eg.linePos(17, 9));
  c('ddfyes') = toInt(eg.linePos(17, 10));

  c('surfyes') = toInt(eg.linePos(18, 1));
  c('snowyes') = toInt(eg.linePos(19, 1));
  c('daysnow') = toInt(eg.linePos(20, 1));
  c('numbersnowdaysout') = toInt(eg.linePos(21, 1));
  
  
  if c('numbersnowdaysout') == 0
    offset = 0;
    jdsurface = [];
  else    
    %preallocate jdsurface
    offset = 1;
    jdsurface = zeros(1,c('numbersnowdaysout'));
    for ii = 1:c('numbersnowdaysout')
      jdsurface(ii) = toInt(eg.linePos(22, ii));
    end
  end
  
  c('jdsurface') = jdsurface;

  c('winterbalyes') = toInt(eg.linePos(23 + offset, 1));
  c('winterjdbeg') = toInt(eg.linePos(24 + offset, 1));
  c('winterjdend') = toInt(eg.linePos(24 + offset, 2));
  c('summerbalyes') = toInt(eg.linePos(25 + offset, 1));
  c('summerjdbeg') = toInt(eg.linePos(26 + offset, 1));
  c('summerjdend') = toInt(eg.linePos(26 + offset, 2));
  c('datesfromfileyes') = toInt(eg.linePos(27 + offset, 1));
  c('namedatesmassbal') = (eg.linePos(28 + offset, 1));
  c('beltwidth') = toInt(eg.linePos(29 + offset, 1));
  c('snow2zeroeachyearyes') = toInt(eg.linePos(30 + offset, 1));
  c('snowfreeyes') = toInt(eg.linePos(31 + offset, 1));

  c('cumulmeltyes') = toInt(eg.linePos(33 + offset, 1));
  c('cm_or_m') = toInt(eg.linePos(34 + offset, 1));
  c('do_out_area') = toInt(eg.linePos(35 + offset, 1));
  c('outgridnumber') = toInt(eg.linePos(36 + offset, 1));
  
  % Read in 'outgrids'. this fails if 'outgridnumber' and the actual number
  % of grids in the file mismatch
  outGridOffset = 38 + offset + c('outgridnumber');
  if c('outgridnumber')
    outgrids = {};
    for grid = 1:(c('outgridnumber') )
      line = 38 + offset + grid;
      keySet = {'name', 'location', 'outglobnet'};
      keyValues = { (eg.linePos(line, 1)), [toInt(eg.linePos(line, 2)), toInt(eg.linePos(line, 3))], toInt(eg.linePos(line, 4))};
      thisGrid = containers.Map(keySet, keyValues);
      outgrids{end+1}= thisGrid;
    end
    c('outgrids') = outgrids;
  else
    c('outgrids') = {};
  end

  % based on 'outgridnumber' we need to take into consideration the number
  % of outgrid positions in the file, and start looking for the rest
  % of the options _after_ the outgrids are finished
  lineposOffset = @(line, pos)   eg.linePos(line + outGridOffset, pos); 
 
  c('methodinisnow') = toInt(lineposOffset(2, 1));
  c('methodsnowalbedo') = toInt(lineposOffset(3, 1));
  c('methodglobal') = toInt(lineposOffset(4, 1));
  c('methodlonginstation') = toInt(lineposOffset(5, 1));
  c('methodlongin') = toInt(lineposOffset(6, 1));
  c('methodsurftempglac') = toInt(lineposOffset(7, 1));

  c('methodturbul') = toInt(lineposOffset(9, 1));
  c('method_z0Te') = toInt(lineposOffset(10, 1));
  c('methodiceheat') = toInt(lineposOffset(11, 1));
  c('methodnegbal') = toInt(lineposOffset(12, 1));

  c('scalingyes') = toInt(lineposOffset(14, 1));
  c('gamma') = str2double(lineposOffset(15, 1));
  c('c_coefficient') = str2double(lineposOffset(16, 1));

  c('namedgm') = (lineposOffset(18, 1));
  c('namedgmdrain') = (lineposOffset(19, 1));
  c('namedgmglac') = (lineposOffset(20, 1));
  c('namedgmslope') = (lineposOffset(21, 1));
  c('namedgmaspect') = (lineposOffset(22, 1));
  c('namedgmskyview') = (lineposOffset(23, 1));
  c('namedgmfirn') = (lineposOffset(24, 1));
  c('nameinitialsnow') = (lineposOffset(25, 1));
  c('nameklima') = (lineposOffset(26, 1));

  c('laenge') = str2double(lineposOffset(28, 1));
  c('breite') = str2double(lineposOffset(29, 1));
  c('reflongitude') = str2double(lineposOffset(30, 1));
  c('rowclim') = toInt(lineposOffset(31, 1));
  c('colclim') = toInt(lineposOffset(32, 1));
  c('climoutsideyes') = toInt(lineposOffset(33, 1));
  c('heightclim') = toInt(lineposOffset(33, 2));
  c('gridsize') = toInt(lineposOffset(34, 1));
  c('timestep') = toInt(lineposOffset(35, 1));

  c('formatclimdata') = toInt(lineposOffset(37, 1));
  c('maxcol') = toInt(lineposOffset(38, 1));

  c('coltemp') = toInt(lineposOffset(39, 1));
  c('colhum') = toInt(lineposOffset(40, 1));
  c('colwind') = toInt(lineposOffset(41, 1));
  c('colglob') = toInt(lineposOffset(42, 1));
  c('colref') = toInt(lineposOffset(43, 1));
  c('colnet') = toInt(lineposOffset(44, 1));
  c('collongin') = toInt(lineposOffset(45, 1));
  c('collongout') = toInt(lineposOffset(46, 1));
  c('colprec') = toInt(lineposOffset(47, 1));
  c('colcloud') = toInt(lineposOffset(48, 1));
  c('coltempgradvarying') = toInt(lineposOffset(49, 1));
  c('coldis') = toInt(lineposOffset(50, 1));

  c('ERAtempshift') = toInt(lineposOffset(52, 1));
  c('ERAwindshift') = toInt(lineposOffset(53, 1));

  c('methodtempinterpol') = toInt(lineposOffset(55, 1));
  c('tempgrad') = str2double(lineposOffset(56, 1));
  c('tempscenario') = toInt(lineposOffset(57, 1));
  c('precscenario') = toInt(lineposOffset(58, 1));
  c('monthtempgradyes') = toInt(lineposOffset(60, 1));
  
  c('monthtempgrad') = arrayfun(@(y)str2double(lineposOffset(60,y)), 2:13);
  %float(lineposOffset(59,x)) for x in range(1,13));
    
  c('monthtempscenyes') = toInt(lineposOffset(61, 1));
  c('monthtempscen') = arrayfun(@(y)str2double(lineposOffset(61,y)), 2:13);
  %(float(lineposOffset(60,x)) for x in range(1,13));
  c('monthprecipscenyes') = toInt(lineposOffset(62, 1));
  c('monthprecipscen') = arrayfun(@(y)str2double(lineposOffset(62,y)), 2:13);
  %(float(lineposOffset(61,x)) for x in range(1,13));


  c('n_albfiles') = toInt(lineposOffset(64, 1));
  c('albsnow') = str2double(lineposOffset(65, 1));
  c('albslush') = str2double(lineposOffset(66, 1));
  c('albice') = str2double(lineposOffset(67, 1));
  c('albfirn') = str2double(lineposOffset(68, 1));
  c('albrock') = str2double(lineposOffset(69, 1));
  c('albmin') = str2double(lineposOffset(70, 1));
  c('snowalbincrease') = str2double(lineposOffset(71, 1));
  c('albiceproz') = str2double(lineposOffset(72, 1));
  c('ndstart') = toInt(lineposOffset(73, 1));

  c('split') = toInt(lineposOffset(75, 1));
  c('prozdiffuse') = str2double(lineposOffset(76, 1));
  c('trans') = str2double(lineposOffset(77, 1));
  c('ratio') = str2double(lineposOffset(78, 1));
  c('ratiodir2dir') = str2double(lineposOffset(79, 1));
  c('surftemplapserate') = str2double(lineposOffset(80, 1));
  c('directfromfile') = toInt(lineposOffset(81, 1));
  c('pathdirectfile') = (lineposOffset(82, 1));
  c('daysdirect') = toInt(lineposOffset(83, 1));
  c('slopestation') = str2double(lineposOffset(84, 1));

  c('iterstep') = str2double(lineposOffset(86, 1));
  c('z0wice') = str2double(lineposOffset(87, 1));
  c('dividerz0T') = str2double(lineposOffset(88, 1));
  c('dividerz0snow') = str2double(lineposOffset(89, 1));
  c('z0proz') = str2double(lineposOffset(90, 1));
  c('icez0min') = str2double(lineposOffset(91, 1));
  c('icez0max') = str2double(lineposOffset(92, 1));

  c('methodprecipinterpol') = toInt(lineposOffset(94, 1));
  c('precgrad') = str2double(lineposOffset(95, 1));
  c('precgradhigh') = str2double(lineposOffset(96, 1));
  c('precgradelev') = toInt(lineposOffset(96, 2));
  c('preccorr') = str2double(lineposOffset(97, 1));
  c('snowmultiplierglacier') = str2double(lineposOffset(98, 1));
  c('snowmultiplierrock') = str2double(lineposOffset(99, 1));
  c('threshtemp') = str2double(lineposOffset(100, 1));
  c('onlyglacieryes') = toInt(lineposOffset(101, 1));
  c('glacierpart') = str2double(lineposOffset(102, 1));

  c('nameqcalc') = (lineposOffset(104, 1));
  c('nodis') = toInt(lineposOffset(105, 1));
  c('firnkons') = toInt(lineposOffset(106, 1));
  c('snowkons') = toInt(lineposOffset(107, 1));
  c('icekons') = toInt(lineposOffset(108, 1));
  c('rockkons') = toInt(lineposOffset(109, 1));

  c('qfirnstart') = str2double(lineposOffset(111, 1));
  c('qsnowstart') = str2double(lineposOffset(112, 1));
  c('qicestart') = str2double(lineposOffset(113, 1));
  c('qrockstart') = str2double(lineposOffset(114, 1));
  c('qground') = str2double(lineposOffset(115, 1));
  c('jdstartr2diff') = str2double(lineposOffset(116, 1));

  c('percolationyes') = toInt(lineposOffset(118, 1));
  c('slushformationyes') = toInt(lineposOffset(119, 1));
  c('densificationyes') = toInt(lineposOffset(120, 1));
  c('wetstartyes') = toInt(lineposOffset(121, 1));
  c('ndepths') = toInt(lineposOffset(122, 1));
  c('factinter') = toInt(lineposOffset(123, 1));

  c('thicknessfirst') = str2double(lineposOffset(125, 1));
  c('thicknessdeep') = str2double(lineposOffset(126, 1));
  c('depthdeep') = str2double(lineposOffset(127, 1));
  c('denssnow') = toInt(lineposOffset(128, 1));
  c('irrwatercontyes') = toInt(lineposOffset(129, 1));
  c('irrwatercont') = str2double(lineposOffset(130, 1));

  c('factsubsurfout') = toInt(lineposOffset(132, 1));
  c('offsetsubsurfout') = toInt(lineposOffset(133, 1));

  c('runoffyes') = toInt(lineposOffset(135, 1));
  c('superyes') = toInt(lineposOffset(135, 2));
  c('wateryes') = toInt(lineposOffset(135, 3));
  c('surfwateryes') = toInt(lineposOffset(135, 4));
  c('slushyes') = toInt(lineposOffset(135, 5));
  c('coldsnowyes') = toInt(lineposOffset(135, 6));
  c('coldtotyes') = toInt(lineposOffset(135, 7));

  c('ddmethod') = toInt(lineposOffset(139, 1));
  c('DDFice') = str2double(lineposOffset(140, 1));
  c('DDFsnow') = str2double(lineposOffset(141, 1));

  c('meltfactor') = str2double(lineposOffset(143, 1));
  c('radfactorice') = str2double(lineposOffset(144, 1));
  c('radfactorsnow') = str2double(lineposOffset(145, 1));
  c('debrisfactor') = toInt(lineposOffset(146, 1));

  c('coordinatesyes') = toInt(lineposOffset(148, 1));
  
  %Read in the stake coords
  if c('maxmeltstakes') > 0
    fmt = c('coordinatesyes');
    stake_coords = [];
    for ii = 149:(149 + c('maxmeltstakes') - 1)
      thisStake = [coordFmt(fmt, lineposOffset(ii,1)), coordFmt(fmt,lineposOffset(ii,2))];
      %thisStake = arrayfun(@(y)coordFmt(fmt,y), thisStake);%, 'UniformOutput', false);
      stake_coords = [stake_coords; thisStake ];
    end
    %stake_coords = (map(fmt, [lineposOffset(ii,0), lineposOffset(ii,1)] for ii = range(159, 159 + c('maxmeltstakes'))));
    c('stake_coords') = stake_coords;
  else
    c('stake_coords') = [];
  end 
end


% called several times above
function i = toInt(s)
% Convert strings to Integers not floats
  ss = str2num(s); %converts string to float
  i = int32(ss); %convert float to integer
end

% called above once for stake coordinates
function e = coordFmt(fmt, str)
% convert output-stake coordinates 
% to corect type given 'coordinateyes'
%
% if coordinateyes == 1 or 2 -> double, otherwise to int
if or(fmt == 1, fmt == 2)
  e = str2double(str);
elseif fmt == 3
  e = toInt(str);
end
end
