% Copyright 2013 Lyman Gillispie
% This code is distributed under the MIT License
% Author: Lyman Gillispie

function ostr = mapToDegrees(CC)
% Convert containers.Map object to a valid "input.txt" file
% for DEBaM/DETIM v1.x.x
% The Map object must have a key for every parameter specified in
% "input.txt".
%
%Args: CC - a dictionary containing all of the appropriate elements
%Returns: ostr - string contianing  a valid input.txt for the Hock melt model

    ostr = [];

    ostr = [ostr '' char(10)];
    ostr = [ostr '***********************************************************' char(10)];
    ostr = [ostr sprintf('%s    %%output to screen every X day.  daysscreenoutput.\n', dropZeros(CC('daysscreenoutput')))];
    ostr = [ostr sprintf('%s    %%Path for Inputfiles.  inpath\n', CC('inpath'))];
    ostr = [ostr sprintf('%s    %%Path for Outputfiles.  outpath\n', CC('outpath'))];
    ostr = [ostr sprintf('%i  %i    %%first julian day to be calculated.  jdbeg  yearbeg\n', CC('jdbeg'), CC('yearbeg'))];
    ostr = [ostr sprintf('%i  %i    %%last julian day to be calculated.  jdend  yearend\n', CC('jdend'), CC('yearend'))];
    ostr = [ostr sprintf('%i    %%discharge to be calculated: 1=yes,0=no,2=yes, but no discharge data.  disyes\n', CC('disyes'))];
    ostr = [ostr sprintf('%i    %%1=whole grid computed,  2=only grid cell of weather station.  calcgridyes\n', CC('calcgridyes'))];
    ostr = [ostr '%********* 1.) MODEL OUTPUT PARAMETERS ****************************' char(10)];
    ostr = [ostr sprintf('%i    %%number of stakes for melt output.  maxmeltstakes\n', CC('maxmeltstakes'))];
    ostr = [ostr sprintf('%i    %%cum massbal multiplied by this factor in melting.dat.  plusminus\n', CC('plusminus'))];
    ostr = [ostr sprintf('%i    %%0=no output 1=every step, 2=daily, 3=whole period 4=2and3.  do_out\n', CC('do_out'))];
    ostr = [ostr '%shayes exkyes solyes diryes dir2yes difyes gloyes albyes  swbyes linyes loutyes' char(10)];
    ostr = [ostr sprintf('%i %i %i %i %i %i %i %i %i %i %i\n', CC('shayes'), CC('exkyes'), CC('solyes'), CC('diryes'), CC('dir2yes'), CC('difyes'), CC('gloyes'), CC('albyes'), CC('swbyes'), CC('linyes'), CC('loutyes'))];
    ostr = [ostr '%netyes senyes latyes raiyes enbyes melyes  ablyes surftempyes  posyes ddfyes' char(10)];
    ostr = [ostr sprintf('%i %i %i %i %i %i %i %i %i %i\n', CC('netyes'), CC('senyes'), CC('latyes'), CC('raiyes'), CC('enbyes'), CC('melyes'), CC('ablyes'), CC('surftempyes'), CC('posyes'), CC('ddfyes'))];
    ostr = [ostr sprintf('%i    %%surface conditions to grid file (2=for specified JDs).  surfyes\n', CC('surfyes'))];
    ostr = [ostr sprintf('%i    %%snow cover to grid file at midnight.  snowyes\n', CC('snowyes'))];
    ostr = [ostr sprintf('%i    %%snow or surface written to file if jd dividable by this value.  daysnow\n', CC('daysnow'))];
    ostr = [ostr sprintf('%i    %%number of jd for output of surface type/snow cover.  numbersnowdaysout\n', CC('numbersnowdaysout'))];
    jdsurfaceLoc = cell2mat(arrayfun(@(x) sprintf('%i ', x), CC('jdsurface'), 'uniformoutput', false));

    ostr = [ostr jdsurfaceLoc(1:end-1) char(10)];

    ostr = [ostr '%----------- 2.) MASS BALANCE -------------------' char(10)];
    ostr = [ostr sprintf('%i    %%gridout winter mass balance yes=1, no=0.  winterbalyes\n', CC('winterbalyes'))];
    ostr = [ostr sprintf('%i  %i    %%julian day winter starts and ends.  winterjdbeg  winterjdend\n', CC('winterjdbeg'), CC('winterjdend'))];
    ostr = [ostr sprintf('%i    %%gridout summer mass balance yes=1, no=0.  summerbalyes\n', CC('summerbalyes'))];
    ostr = [ostr sprintf('%i  %i    %%julian day summer starts and ends.  summerjdbeg  summerjdend\n', CC('summerjdbeg'), CC('summerjdend'))];
    ostr = [ostr sprintf('%i    %%1=dates for MB meas read from file, 0=fixed dates.  datesfromfileyes\n', CC('datesfromfileyes'))];
    ostr = [ostr sprintf('%s    %%file containing the dates of massbal meas.  namedatesmassbal\n', CC('namedatesmassbal'))];
    ostr = [ostr sprintf('%i    %% vertical extent of elevation bands (m) for mass balance profiles.  beltwidth\n', CC('beltwidth'))];
    ostr = [ostr sprintf('%i    %%set snow cover to 0 at start of each massbal year.  snow2zeroeachyearyes\n', CC('snow2zeroeachyearyes'))];
    ostr = [ostr sprintf('%i   %%times series file with number of pixels snowfree written to file.  snowfreeyes \n', CC('snowfreeyes'))];
    ostr = [ostr '-----------------------------------------' char(10)];
    ostr = [ostr sprintf('%i   %%gridoutput of melt cumulated=1 or mean=0.  cumulmeltyes\n', CC('cumulmeltyes'))];
    ostr = [ostr sprintf('%i    %%if cumulated, output in cm=10 or m=1000.  cm_or_m\n', CC('cm_or_m'))];
    ostr = [ostr sprintf('%i    %%time series of spatial mean to output (yes=1 no=0).  do_out_area\n', CC('do_out_area'))];
    ostr = [ostr sprintf('%i    %%number of individual grid points for which model result output.  outgridnumber\n', CC('outgridnumber'))];
    ostr = [ostr '%***====read if number > 0============================***' char(10)];
    ostr = [ostr '%***Outputfilename ** row/x-coord ***column/y-coord *** glob and net data included from input data' char(10)];

    % printing outgrids requires a little care
    outgridsLoc = '';
    outgrids = CC('outgrids');

    for ii = 1:length(outgrids)
      grid = outgrids{ii};
      thisGrid = sprintf('%s ', grid('name'));
      thisGrid = [thisGrid, cell2mat(arrayfun(@(x)sprintf('%s ',dropZeros(x)), grid('location'), 'uniformoutput', false))];
      thisGrid = [thisGrid(1:end-1), sprintf(' %d\n', grid('outglobnet'))];
      outgridsLoc = [outgridsLoc thisGrid];
    end

    ostr = [ostr outgridsLoc];

    ostr = [ostr '%******** 3.) METHODS ENERGY BALANCE COMPONENTS ********************************' char(10)];

    ostr = [ostr sprintf('%i    %%1=surface maps 2=start with initial snow cover.  methodinisnow\n', CC('methodinisnow'))];
    ostr = [ostr sprintf('%i    %%1=constant for surface types, >2=alb generated.  methodsnowalbedo, 6=zongo\n', CC('methodsnowalbedo'))];
    ostr = [ostr sprintf('%i    %%1=direct and diffuse not separated, 2=separated.  methodglobal\n', CC('methodglobal'))];
    ostr = [ostr sprintf('%i    %%1=longin from net,glob,ref (Tsurf=0),2=meas,3-6=from paramet. methodlonginstation\n', CC('methodlonginstation'))];
    ostr = [ostr sprintf('%i    %%1=longin constant, 2=spatially variable. methodlongin\n', CC('methodlongin'))];
    ostr = [ostr sprintf('%i    %%1=surftemp=0, 2=iteration 3=measurement+(decrease height), 4=snowmodel.  methodsurftempglac\n', CC('methodsurftempglac'))];

    ostr = [ostr '%********************* TURBULENCE OPTION' char(10)];
    ostr = [ostr sprintf('%i    %%1=turbulence accord. to Escher-Vetter, 2=Ambach 3=stabil.  methodturbul\n', CC('methodturbul'))];
    ostr = [ostr sprintf('%i    %%1=z0T/z0w fixed ratio 2=according to Andreas (1987).  method_z0Te\n', CC('method_z0Te'))];
    ostr = [ostr sprintf('%i    %%1=no ice heat flux 2=ice heat flux.  methodiceheat\n', CC('methodiceheat'))];
    ostr = [ostr sprintf('%i    %%1=neglected 2=neg energy balance stored to retard melt.  methodnegbal\n', CC('methodnegbal'))];

    ostr = [ostr '%********* SCALING ********************************' char(10)];
    ostr = [ostr sprintf('%i    %%V-A scaling yes=1, no=0.  scalingyes\n', CC('scalingyes'))];
    ostr = [ostr sprintf('%s    %%gamma in V-A scaling.  gamma\n', dropZeros(CC('gamma')))];
    ostr = [ostr sprintf('%s    %%coefficient in V-A scaling.  c_coefficient\n', dropZeros(CC('c_coefficient')))];

    ostr = [ostr '%********* 4.) NAMES OF INPUT FILES ********************************' char(10)];
    ostr = [ostr sprintf('%s    %%name of Digital Terrain Model.  namedgm\n', CC('namedgm'))];
    ostr = [ostr sprintf('%s    %%name of DTM with drainage basin.  namedgmdrain\n', CC('namedgmdrain'))];
    ostr = [ostr sprintf('%s    %%name of DTM glacier.  namedgmglac\n', CC('namedgmglac'))];
    ostr = [ostr sprintf('%s    %%name of DTM slope.  namedgmslope\n', CC('namedgmslope'))];
    ostr = [ostr sprintf('%s    %%name of DTM aspect.  namedgmaspec\n', CC('namedgmaspect'))];
    ostr = [ostr sprintf('%s    %%name of DTM sky view factor.  namedgmskyview\n', CC('namedgmskyview'))];
    ostr = [ostr sprintf('%s    %%name of DTM firnarea.  namedgmfirn\n', CC('namedgmfirn'))];
    ostr = [ostr sprintf('%s   %%name of DTM initial snow cover.  nameinitialsnow \n', CC('nameinitialsnow'))];
    ostr = [ostr sprintf('%s    %%name of climate data file.  nameklima\n', CC('nameklima'))];

    ostr = [ostr '%********* 5.) GRID INFORMATION***************************************' char(10)];
    ostr = [ostr sprintf('%s    %%geographical longitude [degree].  laenge\n', dropZeros(CC('laenge')))];
    ostr = [ostr sprintf('%s    %%latitude.  breite\n', dropZeros(CC('breite')))];
    ostr = [ostr sprintf('%s    %%longitude time refers to.  reflongitude\n', dropZeros(CC('reflongitude')))];
    ostr = [ostr sprintf('%i    %%row in DTM where climate station is located.   rowclim\n', CC('rowclim'))];
    ostr = [ostr sprintf('%i    %%column of climate station.  colclim\n', CC('colclim'))];
    ostr = [ostr sprintf('%i  %i    %%take this elevation for AWS yes/no.  climoutsideyes  heightclim\n', CC('climoutsideyes'), CC('heightclim'))];
    ostr = [ostr sprintf('%i    %%gridsize in m.  gridsize\n', CC('gridsize'))];
    ostr = [ostr sprintf('%i    %%time step in hours.  timestep\n', CC('timestep'))];
    ostr = [ostr '%********* 6.) CLIMATE DATA ******************************************' char(10)];
    ostr = [ostr sprintf('%i    %%1=midnight time is 0, 2=time is 24, 3=24 but previous day.  formatclimdata\n', CC('formatclimdata'))];
    ostr = [ostr sprintf('%i    %%number of columns in climate file.  maxcol\n', CC('maxcol'))];
    ostr = [ostr sprintf('%i    %%columns in climate input file: temperature.  coltemp\n', CC('coltemp'))];
    ostr = [ostr sprintf('%i    %%column containing relative humidity.  colhum\n', CC('colhum'))];
    ostr = [ostr sprintf('%i    %%column wind speed [m/s].  colwind\n', CC('colwind'))];
    ostr = [ostr sprintf('%i    %%global radiation.  colglob\n', CC('colglob'))];
    ostr = [ostr sprintf('%i    %%reflected shortwave radiation.  colref\n', CC('colref'))];
    ostr = [ostr sprintf('%i    %%net radiation.  colnet\n', CC('colnet'))];
    ostr = [ostr sprintf('%i    %%longwave incoming radiation.  collongin\n', CC('collongin'))];
    ostr = [ostr sprintf('%i    %%longwave outgoing radiation.  collongout\n', CC('collongout'))];
    ostr = [ostr sprintf('%i    %%precipitation.  colprec\n', CC('colprec'))];
    ostr = [ostr sprintf('%i    %%cloud cover (number of eigths).  colcloud\n', CC('colcloud'))];
    ostr = [ostr sprintf('%i    %%time variant lapse rate (neg=decrease).  coltempgradvarying\n', CC('coltempgradvarying'))];
    ostr = [ostr sprintf('%i    %%column of discharge data.  coldis\n', CC('coldis'))];

    ostr = [ostr '%********** CORRECTIONS TO INPUT ********************************' char(10)];
    ostr = [ostr sprintf('%i    %%add this to ERA temp to get to elevationstation.  ERAtempshift\n', CC('ERAtempshift'))];
    ostr = [ostr sprintf('%i    %%add this to ERA wind to get to elevationstation.  ERAwindshift\n', CC('ERAwindshift'))];

    ostr = [ostr '%********** 7.) LAPSE RATE / SCENARIOS ********************************' char(10)];
    ostr = [ostr sprintf('%i    %%1=const lapse rate 2=variable 2AWS 3=grid.  methodtempinterpol\n', CC('methodtempinterpol'))];
    ostr = [ostr sprintf('%s    %%temperature change with elevation [degree/100m].  tempgrad\n', dropZeros(CC('tempgrad')))];
    ostr = [ostr sprintf('%i    %%climate perturbation: temp + this amount.  tempscenario\n', CC('tempscenario'))];
    ostr = [ostr sprintf('%i    %%climate perturbation: precip + this amount in percent.  precscenario\n', CC('precscenario'))];
    ostr = [ostr '%on/off Jan   Feb   Mar   Apr   May   Jun   Jul   Aug   Sep   Oct   Nov   Dec' char(10)];

    ostr = [ostr sprintf('%i ', CC('monthtempgradyes'))];
    monthtempgradLoc = cell2mat(arrayfun(@(x)sprintf('%s ',dropZeros(x)),CC('monthtempgrad'), 'uniformoutput', false));
    ostr = [ostr monthtempgradLoc(1:end-1)];
    ostr = [ostr '    %monthtempgrad(yes)' char(10)];

    ostr = [ostr sprintf('%i ', CC('monthtempscenyes'))];
    monthtempscenLoc = cell2mat(arrayfun(@(x)sprintf('%s ',dropZeros(x)),CC('monthtempscen'), 'uniformoutput', false));
    ostr = [ostr monthtempscenLoc(1:end-1)];
    ostr = [ostr '    %monthtempscen(yes)' char(10)];


    ostr = [ostr sprintf('%i ', CC('monthprecipscenyes'))];
    monthtempprecipscenLoc = cell2mat(arrayfun(@(x)sprintf('%s ',dropZeros(x)),CC('monthprecipscen'), 'uniformoutput', false));
    ostr = [ostr monthtempprecipscenLoc(1:end-1)];
    ostr = [ostr '    %monthprecipscen(yes)' char(10)];


    ostr = [ostr '%******** 8.) SURFACE TYPE / ALBEDO ***********************************' char(10)];
    ostr = [ostr sprintf('%i    %%number of transient surface type files\n', CC('n_albfiles'))];
    ostr = [ostr sprintf('%s    %%albedo for snow and firn (fixed value).  albsnow\n', dropZeros(CC('albsnow')))];
    ostr = [ostr sprintf('%s    %%albedo for slush.  albslush\n', dropZeros(CC('albslush')))];
    ostr = [ostr sprintf('%s    %%albedo for ice.  albice\n', dropZeros(CC('albice')))];
    ostr = [ostr sprintf('%s    %%albedo for firn (method 2).  albfirn\n', dropZeros(CC('albfirn')))];
    ostr = [ostr sprintf('%s    %%albedo for rock outside glacier.  albrock\n', dropZeros(CC('albrock')))];
    ostr = [ostr sprintf('%s    %%minimum albedo for snow if generated.  albmin\n', dropZeros(CC('albmin')))];
    ostr = [ostr sprintf('%s    %%increase snowalb/100m elevation for 1. time. snowalbincrease\n', dropZeros(CC('snowalbincrease')))];
    ostr = [ostr sprintf('%s    %%decrease of ice albedo with elevation.  albiceproz\n', dropZeros(CC('albiceproz')))];
    ostr = [ostr sprintf('%i    %%number of days since snow fall at start.  ndstart\n', CC('ndstart'))];

    ostr = [ostr '%******** 9.) RADIATION *******************************************' char(10)];
    ostr = [ostr sprintf('%i    %%number of shade calculation per time step.  split\n', CC('split'))];
    ostr = [ostr sprintf('%s    %%percent diffuse radiation of global radiation.  prozdiffuse\n', dropZeros(CC('prozdiffuse')))];
    ostr = [ostr sprintf('%s    %%transmissivity.  trans\n', dropZeros(CC('trans')))];
    ostr = [ostr sprintf('%s    %%first ratio of global radiation and direct rad.  ratio\n', dropZeros(CC('ratio')))];
    ostr = [ostr sprintf('%s    %%first ratio of direct and clear-sky direct rad.  ratiodir2dir\n', dropZeros(CC('ratiodir2dir')))];
    ostr = [ostr sprintf('%s    %%decrease in surftemp with height if longout meas.  surftemplapserate\n', dropZeros(CC('surftemplapserate')))];
    ostr = [ostr sprintf('%i    %%direct radiation read from file = 1.  directfromfile\n', CC('directfromfile'))];
    ostr = [ostr sprintf('%s    %%Path for direct files.  pathdirectfile\n', CC('pathdirectfile'))];
    ostr = [ostr sprintf('%i    %%files only exist every number of days defined here.  daysdirect\n', CC('daysdirect'))];
    ostr = [ostr sprintf('%s    %%0=slope at climate station is set to 0.  slopestation\n', dropZeros(CC('slopestation')))];

    ostr = [ostr '%******** 10.) TURBULENCE ***********************************************' char(10)];
    ostr = [ostr sprintf('%s    %%step for surface temp lowering for iteration.  iterstep\n', dropZeros(CC('iterstep')))];
    ostr = [ostr sprintf('%s    %%roughness length for wind for ice in m   .0027.  z0wice\n', dropZeros(CC('z0wice')))];
    ostr = [ostr sprintf('%s    %%z0Temp is zow divided by this value.  dividerz0T\n', dropZeros(CC('dividerz0T')))];
    ostr = [ostr sprintf('%s    %%z0snow is z0wice divided by this value.  dividerz0snow\n', dropZeros(CC('dividerz0snow')))];
    ostr = [ostr sprintf('%s    %%increase of z0 with decreasing elevation.  z0proz\n', dropZeros(CC('z0proz')))];
    ostr = [ostr sprintf('%s    %%min z0w ice.  icez0min\n', dropZeros(CC('icez0min')))];
    ostr = [ostr sprintf('%s    %%max z0w ice.  icez0max\n', dropZeros(CC('icez0max')))];

    ostr = [ostr '%********** 11.) PRECIPITATION *******************************************' char(10)];
    ostr = [ostr sprintf('%i    %%1=lapse rate 2=scale AWS precip with index map 3=read grids.  methodprecipinterpol\n', CC('methodprecipinterpol'))];
    ostr = [ostr sprintf('%s    %%precipitation change with elevation [%%/100m].  precgrad\n', dropZeros(CC('precgrad')))];
    ostr = [ostr sprintf('%s %i    %%precipitation change with elevation beyond certain elevation.  precgradhigh precgradelev\n', dropZeros(CC('precgradhigh')), CC('precgradelev'))];
    ostr = [ostr sprintf('%s    %%35 precipitation correction, caused by losses.  preccorr\n', dropZeros(CC('preccorr')))];
    ostr = [ostr sprintf('%s    %%snow precip is multiplied by this factor.  snowmultiplierglacier\n', dropZeros(CC('snowmultiplierglacier')))];
    ostr = [ostr sprintf('%s    %%snow precip is multiplied by this factor.  snowmultiplierrock\n', dropZeros(CC('snowmultiplierrock')))];
    ostr = [ostr sprintf('%s    %%threshold temperature rain/snow precipitation.  threshtemp\n', dropZeros(CC('threshtemp')))];
    ostr = [ostr sprintf('%i    %%0=if massbal calculations for whole drainage basin, 1=only glacier.  onlyglacieryes\n', CC('onlyglacieryes'))];
    ostr = [ostr sprintf('%s    %%percentage of glacierization.  glacierpart\n', dropZeros(CC('glacierpart')))];

    ostr = [ostr '%************* 13.) DISCHARGE STARTING VALUES**********************' char(10)];
    ostr = [ostr sprintf('%s     %%name of discharge output file.  nameqcalc\n', CC('nameqcalc'))];
    ostr = [ostr sprintf('%i    %%nodata value of discharge file.  nodis\n', CC('nodis'))];
    ostr = [ostr sprintf('%i    %%storage constant k for firn.  firnkons\n', CC('firnkons'))];
    ostr = [ostr sprintf('%i    %%storage constant k for snow.  snowkons\n', CC('snowkons'))];
    ostr = [ostr sprintf('%i    %%storage constant k for ice.  icekons\n', CC('icekons'))];
    ostr = [ostr sprintf('%i    %%storage constant k for rock(outside glacier non-snowcovered.  icekons\n', CC('rockkons'))];

    ostr = [ostr '%************* 13.) DISCHARGE STARTING VALUES**********************' char(10)];
    ostr = [ostr sprintf('%s    %%start value for firn discharge (previous time step).  qfirnstart\n', dropZeros(CC('qfirnstart')))];
    ostr = [ostr sprintf('%s    %%start value for snow discharge (m3/s).  qsnowstart\n', dropZeros(CC('qsnowstart')))];
    ostr = [ostr sprintf('%s    %%start value for ice discharge.  qicestart\n', dropZeros(CC('qicestart')))];
    ostr = [ostr sprintf('%s    %%start value for rock discharge (outside glacier non-snowcovered).  qicestart\n', dropZeros(CC('qrockstart')))];
    ostr = [ostr sprintf('%s    %%groundwater discharge[m3].  qground\n', dropZeros(CC('qground')))];
    ostr = [ostr sprintf('%s    %%difference between start of calculation and start r2.  jdstartr2diff\n', dropZeros(CC('jdstartr2diff')))];

    ostr = [ostr '%%%%%%%%%%%% 15.) OPTIMIZATION %%%%%%%%%%%%%%%%%%%%%' char(10)];
    ostr = [ostr sprintf('%i    %%optimization run for k-values = 1; simulation=0.  disyesopt\n', CC('disyesopt'))];
    ostr = [ostr sprintf('%s    %%1. parameter to optimize.  optkA\n', CC('optkA'))];
    ostr = [ostr sprintf('%s    %%startvalue of 1. parameter to optimize.  startopt1\n', dropZeros(CC('startopt1')))];
    ostr = [ostr sprintf('%s    %%step length.  stepopt1\n', dropZeros(CC('stepopt1')))];
    ostr = [ostr sprintf('%i    %%number of steps no.1  anzahlopt1\n', CC('anzahlopt1'))];
    ostr = [ostr sprintf('%s    %%2. parameter to optimize.  optkB\n', CC('optkB'))];
    ostr = [ostr sprintf('%s    %%startvalue of 2. parameter.  startopt2\n', dropZeros(CC('startopt2')))];
    ostr = [ostr sprintf('%s    %%steplength no.2 of optimal r2.  stepopt2\n', dropZeros(CC('stepopt2')))];
    ostr = [ostr sprintf('%i    %%number of steps no.2.  anzahlopt2\n', CC('anzahlopt2'))];
    ostr = [ostr sprintf('%s    %%name of r2-outputfile.  namematrix\n', CC('namematrix'))];
    
    ostr = [ostr '%============ 16.) SNOW MODEL by C. Tijm-Reijmer 2/2005 ========================' char(10)];
    ostr = [ostr sprintf('%i    %%0=no percolation, 1=percolation+refreezing in snowlayer.  percolationyes\n', CC('percolationyes'))];
    ostr = [ostr sprintf('%i    %%0=no slush, 1=meltwater accumulation in snowlayer.  slushformationyes\n', CC('slushformationyes'))];
    ostr = [ostr sprintf('%i    %%0=no densification, 1=densific. of dry snow due to aging.  densificationyes\n', CC('densificationyes'))];
    ostr = [ostr sprintf('%i    %%0=dry start, 1=wet start.  wetstartyes\n', CC('wetstartyes'))];
    ostr = [ostr sprintf('%i    %%maximum number of vertical layers.  ndepths\n', CC('ndepths'))];
    ostr = [ostr sprintf('%i    %%number of subtimesteps for interpolation per main timestep 8.  factinter\n', CC('factinter'))];

    ostr = [ostr '%----------------------------' char(10)];
    ostr = [ostr sprintf('%s    %%layer thickness of first layer (m snow).  thicknessfirst\n', dropZeros(CC('thicknessfirst')))];
    ostr = [ostr sprintf('%s    %%layer thickness at deepest layer (m snow).  thicknessdeep\n', dropZeros(CC('thicknessdeep')))];
    ostr = [ostr sprintf('%s    %%maximum depth model (m).  depthdeep\n', dropZeros(CC('depthdeep')))];
    ostr = [ostr sprintf('%i    %%density of fresh snowfall kg/m3.  denssnow\n', CC('denssnow'))];
    ostr = [ostr sprintf('%i    %%0=constant irreducible water content, 1=density dep. Schneider, 2= density dep. Coleou.  irrwatercontyes\n', CC('irrwatercontyes'))];
    ostr = [ostr sprintf('%s    %%fraction of space irreducible filled with water.  irrwatercont\n', dropZeros(CC('irrwatercont')))];

    ostr = [ostr '%---- Output ----------' char(10)];
    ostr = [ostr sprintf('%i    %%factor for subsurf output, 1=every hour, 24=once per day at midnight.  factsubsurfout\n', CC('factsubsurfout'))];
    ostr = [ostr sprintf('%i    %%offfsetfactor for subsurf output to make print at noon possible.  offsetsubsurfout\n', CC('offsetsubsurfout'))];
    ostr = [ostr '%runoffyes superyes   wateryes   surfwateryes slushyes   coldsnowyes   coldtotyes.      for grid output' char(10)];
    ostr = [ostr sprintf('%i %i %i %i %i %i %i\n', CC('runoffyes'), CC('superyes'), CC('wateryes'), CC('surfwateryes'), CC('slushyes'), CC('coldsnowyes'), CC('coldtotyes'))];

    ostr = [ostr '%========================================================' char(10)];
    ostr = [ostr '%   17.) TEMPERATURE INDEX METHOD' char(10)];
    ostr = [ostr '%========================================================' char(10)];
    ostr = [ostr sprintf('%i    %%which temp index method (1,2 or 3).  ddmethod\n', CC('ddmethod'))];
    ostr = [ostr sprintf('%s    %%degree day factor for ice (only simple DDF method 1).  DDFice\n', dropZeros(CC('DDFice')))];
    ostr = [ostr sprintf('%s    %%degree day factor for snow (only simple DDF method 1).  DDFsnow\n', dropZeros(CC('DDFsnow')))];
    ostr = [ostr '%---------------------------------------------------' char(10)];
    ostr = [ostr sprintf('%s    %%meltfactor (only for modified temp index method 2 or 3).  meltfactor\n', dropZeros(CC('meltfactor')))];
    ostr = [ostr sprintf('%s    %%radiation melt factor for ice.  radfactorice\n', dropZeros(CC('radfactorice')))];
    ostr = [ostr sprintf('%s    %%radiation melt factor for snow.  radfactorsnow\n', dropZeros(CC('radfactorsnow')))];
    ostr = [ostr sprintf('%i    %%factor to reduce melt over debris.  debrisfactor\n', CC('debrisfactor'))];
    ostr = [ostr '%******* 18.) OUTPUT STAKES **************************************' char(10)];
    ostr = [ostr sprintf('%i    %%1=stake locations given in local coordinates (x,y), 2=as 1 but center, 3=row/col.  coordinatesyes\n', CC('coordinatesyes'))];

    % print out stake coords, with the correct formatting
    stake_coordsLoc = '';
    stakes = CC('stake_coords');
    diam = size(stakes);
    fmt = CC('coordinatesyes');
    for ii = 1:diam(1)
      first = fmtStakes(fmt, stakes(ii,1));
      second = fmtStakes(fmt, stakes(ii,2));
      thisStake = [first ' ' second char(10)];
      stake_coordsLoc = [stake_coordsLoc thisStake];
    end
    ostr = [ostr stake_coordsLoc];

end
  

function s = dropZeros(f)
% Helper function to drop trailing zeros from decimal representations.
% This is a little slow.
str = sprintf('%0.15f', f);
re =regexp(str, '^0+(?!\.)|(?<!\.)0+$', 'split');
s = char(re(1));
end


function s = fmtStakes(fmt, num)
% Format Output-Stake locations to match
% correct format given by 'coordinatesyes'
%
if or(fmt == 1, fmt ==2)
  s = dropZeros(num);
elseif fmt == 3
  s = sprintf('%i', num);
end
end
