% Copyright 2013 Lyman Gillispie
% This code is distributed under the MIT License
% Author: Lyman Gillispie

function ostr = mapsToDat(config)
    %Super ugly conversion method,
    %Args: config - a dictionary containing all of the appropriate elements
    %Returns: os, a valid input.dat for the Hock melt model

    ostr = [];

    ostr = [ostr '' char(10)];
    ostr = [ostr '***********************************************************' char(10)];
    ostr = [ostr sprintf('%f    %%output to screen every X day.  daysscreenoutput.\n', config('daysscreenoutput'))];
    ostr = [ostr sprintf('%s    %%Path for Inputfiles.  inpath\n', config('inpath'))];
    ostr = [ostr sprintf('%s    %%Path for Outputfiles.  outpath\n', config('outpath'))];
    ostr = [ostr sprintf('%i  %i    %%first julian day to be calculated.  jdbeg  yearbeg\n', config('jdbeg'), config('yearbeg'))];
    ostr = [ostr sprintf('%i  %i    %%last julian day to be calculated.  jdend  yearend\n', config('jdend'), config('yearend'))];
    ostr = [ostr sprintf('%i    %%discharge to be calculated: 1=yes,0=no,2=yes, but no discharge data.  disyes\n', config('disyes'))];
    ostr = [ostr sprintf('%i    %%1=whole grid computed,  2=only grid cell of weather station.  calcgridyes\n', config('calcgridyes'))];
    ostr = [ostr '%%********* 1.) MODEL OUTPUT PARAMETERS ****************************' char(10)];
    ostr = [ostr sprintf('%i    %%number of stakes for melt output.  maxmeltstakes\n', config('maxmeltstakes'))];
    ostr = [ostr sprintf('%i    %%cum massbal multiplied by this factor in melting.dat.  plusminus\n', config('plusminus'))];
    ostr = [ostr sprintf('%i    %%0=no output 1=every step, 2=daily, 3=whole period 4=2and3.  do_out\n', config('do_out'))];
    ostr = [ostr '%%shayes exkyes solyes diryes dir2yes difyes gloyes albyes  swbyes linyes loutyes' char(10)];
    ostr = [ostr sprintf('%i %i %i %i %i %i %i %i %i %i %i\n', config('shayes'), config('exkyes'), config('solyes'), config('diryes'), config('dir2yes'), config('difyes'), config('gloyes'), config('albyes'), config('swbyes'), config('linyes'), config('loutyes'))];
    ostr = [ostr '%%netyes senyes latyes raiyes enbyes melyes  ablyes surftempyes  posyes ddfyes' char(10)];
    ostr = [ostr sprintf('%i %i %i %i %i %i %i %i %i %i\n', config('netyes'), config('senyes'), config('latyes'), config('raiyes'), config('enbyes'), config('melyes'), config('ablyes'), config('surftempyes'), config('posyes'), config('ddfyes'))];
    ostr = [ostr sprintf('%i    %%surface conditions to grid file (2=for specified JDs).  surfyes\n', config('surfyes'))];
    ostr = [ostr sprintf('%i    %%snow cover to grid file at midnight.  snowyes\n', config('snowyes'))];
    ostr = [ostr sprintf('%i    %%snow or surface written to file if jd dividable by this value.  daysnow\n', config('daysnow'))];
    ostr = [ostr sprintf('%i    %%number of jd for output of surface type/snow cover.  numbersnowdaysout\n', config('numbersnowdaysout'))];
    jdsurfaceLoc = cell2mat(arrayfun(@(x) sprintf('%i ', x), config('jdsurface'), 'uniformoutput', false));

    ostr = [ostr jdsurfaceLoc(1:end-1)];

    ostr = [ostr '%%----------- 2.) MASS BALANCE -------------------' char(10)];
    ostr = [ostr sprintf('%i    %%gridout winter mass balance yes=1, no=0.  winterbalyes\n', config('winterbalyes'))];
    ostr = [ostr sprintf('%i  %i    %%julian day winter starts and ends.  winterjdbeg  winterjdend\n', config('winterjdbeg'), config('winterjdend'))];
    ostr = [ostr sprintf('%i    %%gridout summer mass balance yes=1, no=0.  summerbalyes\n', config('summerbalyes'))];
    ostr = [ostr sprintf('%i  %i    %%julian day summer starts and ends.  summerjdbeg  summerjdend\n', config('summerjdbeg'), config('summerjdend'))];
    ostr = [ostr sprintf('%i    %%1=dates for MB meas read from file, 0=fixed dates.  datesfromfileyes\n', config('datesfromfileyes'))];
    ostr = [ostr sprintf('%s    %%file containing the dates of massbal meas.  namedatesmassbal\n', config('namedatesmassbal'))];
    ostr = [ostr sprintf('%i    %% vertical extent of elevation bands (m) for mass balance profiles.  beltwidth\n', config('beltwidth'))];
    ostr = [ostr sprintf('%i    %%set snow cover to 0 at start of each massbal year.  snow2zeroeachyearyes\n', config('snow2zeroeachyearyes'))];
    ostr = [ostr sprintf('%i   %%times series file with number of pixels snowfree written to file.  snowfreeyes \n', config('snowfreeyes'))];
    ostr = [ostr '-----------------------------------------' char(10)];
    ostr = [ostr sprintf('%i   %%gridoutput of melt cumulated=1 or mean=0.  cumulmeltyes\n', config('cumulmeltyes'))];
    ostr = [ostr sprintf('%i    %%if cumulated, output in cm=10 or m=1000.  cm_or_m\n', config('cm_or_m'))];
    ostr = [ostr sprintf('%i    %%time series of spatial mean to output (yes=1 no=0).  do_out_area\n', config('do_out_area'))];
    ostr = [ostr sprintf('%i    %%number of individual grid points for which model result output.  outgridnumber\n', config('outgridnumber'))];
    ostr = [ostr '%%***====read if number > 0============================***' char(10)];
    ostr = [ostr '%%***Outputfilename ** row/x-coord ***column/y-coord *** glob and net data included from input data\n'];


    outgridsLoc = '';
    outgrids = config('outgrids');

    for ii = length(outgrids)
      grid = outgrids{ii};
      thisGrid = sprintf('%s', grid('name'));
      thisGrid = [thisGrid, cell2mat(arrayfun(@(x)sprintf('%f ', x), grid('location'), 'uniformoutput', false))];
      thisGrid = [thisGrid(1:end-1), sprintf('%s\n', grid('outglobnet'))];
      outgridsLoc = [outgridsLoc thisGrid];
    end

    ostr = [ostr outgridsLoc];

    ostr = [ostr '%%******** 3.) METHODS ENERGY BALANCE COMPONENTS ********************************' char(10)];

    ostr = [ostr sprintf('%i    %%1=surface maps 2=start with initial snow cover.  methodinisnow\n', config('methodinisnow'))];
    ostr = [ostr sprintf('%i    %%1=constant for surface types, >2=alb generated.  methodsnowalbedo, 6=zongo\n', config('methodsnowalbedo'))];
    ostr = [ostr sprintf('%i    %%1=direct and diffuse not separated, 2=separated.  methodglobal\n', config('methodglobal'))];
    ostr = [ostr sprintf('%i    %%1=longin from net,glob,ref (Tsurf=0),2=meas,3-6=from paramet. methodlonginstation\n', config('methodlonginstation'))];
    ostr = [ostr sprintf('%i    %%1=longin constant, 2=spatially variable. methodlongin\n', config('methodlongin'))];
    ostr = [ostr sprintf('%i    %%1=surftemp=0, 2=iteration 3=measurement+(decrease height), 4=snowmodel.  methodsurftempglac\n', config('methodsurftempglac'))];

    ostr = [ostr '%%********************* TURBULENCE OPTION' char(10)];
    ostr = [ostr sprintf('%i    %%1=turbulence accord. to Escher-Vetter, 2=Ambach 3=stabil.  methodturbul\n', config('methodturbul'))];
    ostr = [ostr sprintf('%i    %%1=z0T/z0w fixed ratio 2=according to Andreas (1987).  method_z0Te\n', config('method_z0Te'))];
    ostr = [ostr sprintf('%i    %%1=no ice heat flux 2=ice heat flux.  methodiceheat\n', config('methodiceheat'))];
    ostr = [ostr sprintf('%i    %%1=neglected 2=neg energy balance stored to retard melt.  methodnegbal\n', config('methodnegbal'))];

    ostr = [ostr '%%********* SCALING ********************************' char(10)];
    ostr = [ostr sprintf('%i    %%V-A scaling yes=1, no=0.  scalingyes\n', config('scalingyes'))];
    ostr = [ostr sprintf('%f    %%gamma in V-A scaling.  gamma\n', config('gamma'))];
    ostr = [ostr sprintf('%i    %%coefficient in V-A scaling.  c_coefficient\n', config('c_coefficient'))];

    ostr = [ostr '%%********* 4.) NAMES OF INPUT FILES ********************************' char(10)];
    ostr = [ostr sprintf('%s    %%name of Digital Terrain Model.  namedgm\n', config('namedgm'))];
    ostr = [ostr sprintf('%s    %%name of DTM with drainage basin.  namedgmdrain\n', config('namedgmdrain'))];
    ostr = [ostr sprintf('%s    %%name of DTM glacier.  namedgmglac\n', config('namedgmglac'))];
    ostr = [ostr sprintf('%s    %%name of DTM slope.  namedgmslope\n', config('namedgmslope'))];
    ostr = [ostr sprintf('%s    %%name of DTM aspect.  namedgmaspec\n', config('namedgmaspect'))];
    ostr = [ostr sprintf('%s    %%name of DTM sky view factor.  namedgmskyview\n', config('namedgmskyview'))];
    ostr = [ostr sprintf('%s    %%name of DTM firnarea.  namedgmfirn\n', config('namedgmfirn'))];
    ostr = [ostr sprintf('%s   %%name of DTM initial snow cover.  nameinitialsnow \n', config('nameinitialsnow'))];
    ostr = [ostr sprintf('%s    %%name of climate data file.  nameklima\n', config('nameklima'))];

    ostr = [ostr '%%********* 5.) GRID INFORMATION***************************************' char(10)];
    ostr = [ostr sprintf('%f    %%geographical longitude [degree].  laenge\n', config('laenge'))];
    ostr = [ostr sprintf('%f    %%latitude.  breite\n', config('breite'))];
    ostr = [ostr sprintf('%s    %%longitude time refers to.  reflongitude\n', config('reflongitude'))];
    ostr = [ostr sprintf('%i    %%row in DTM where climate station is located.   rowclim\n', config('rowclim'))];
    ostr = [ostr sprintf('%i    %%column of climate station.  colclim\n', config('colclim'))];
    ostr = [ostr sprintf('%i  %i    %%take this elevation for AWS yes/no.  climoutsideyes  heightclim\n', config('climoutsideyes'), config('heightclim'))];
    ostr = [ostr sprintf('%i    %%gridsize in m.  gridsize\n', config('gridsize'))];
    ostr = [ostr sprintf('%i    %%time step in hours.  timestep\n', config('timestep'))];
    ostr = [ostr '%%********* 6.) CLIMATE DATA ******************************************' char(10)];
    ostr = [ostr sprintf('%i    %%1=midnight time is 0, 2=time is 24, 3=24 but previous day.  formatclimdata\n', config('formatclimdata'))];
    ostr = [ostr sprintf('%i    %%number of columns in climate file.  maxcol\n', config('maxcol'))];
    ostr = [ostr sprintf('%i    %%columns in climate input file: temperature.  coltemp\n', config('coltemp'))];
    ostr = [ostr sprintf('%i    %%column containing relative humidity.  colhum\n', config('colhum'))];
    ostr = [ostr sprintf('%i    %%column wind speed [m/s].  colwind\n', config('colwind'))];
    ostr = [ostr sprintf('%i    %%global radiation.  colglob\n', config('colglob'))];
    ostr = [ostr sprintf('%i    %%reflected shortwave radiation.  colref\n', config('colref'))];
    ostr = [ostr sprintf('%i    %%net radiation.  colnet\n', config('colnet'))];
    ostr = [ostr sprintf('%i    %%longwave incoming radiation.  collongin\n', config('collongin'))];
    ostr = [ostr sprintf('%i    %%longwave outgoing radiation.  collongout\n', config('collongout'))];
    ostr = [ostr sprintf('%i    %%precipitation.  colprec\n', config('colprec'))];
    ostr = [ostr sprintf('%i    %%cloud cover (number of eigths).  colcloud\n', config('colcloud'))];
    ostr = [ostr sprintf('%i    %%time variant lapse rate (neg=decrease).  coltempgradvarying\n', config('coltempgradvarying'))];
    ostr = [ostr sprintf('%i    %%column of discharge data.  coldis\n', config('coldis'))];

    ostr = [ostr '%%********** CORRECTIONS TO INPUT ********************************' char(10)];
    ostr = [ostr sprintf('%i    %%add this to ERA temp to get to elevationstation.  ERAtempshift\n', config('ERAtempshift'))];
    ostr = [ostr sprintf('%i    %%add this to ERA wind to get to elevationstation.  ERAwindshift\n', config('ERAwindshift'))];

    ostr = [ostr '%%********** 7.) LAPSE RATE / SCENARIOS ********************************' char(10)];
    ostr = [ostr sprintf('%i    %%1=const lapse rate 2=variable 2AWS 3=grid.  methodtempinterpol\n', config('methodtempinterpol'))];
    ostr = [ostr sprintf('%f    %%temperature change with elevation [degree/100m].  tempgrad\n', config('tempgrad'))];
    ostr = [ostr sprintf('%i    %%climate perturbation: temp + this amount.  tempscenario\n', config('tempscenario'))];
    ostr = [ostr sprintf('%i    %%climate perturbation: precip + this amount in percent.  precscenario\n', config('precscenario'))];
    ostr = [ostr '%%on/off Jan   Feb   Mar   Apr   May   Jun   Jul   Aug   Sep   Oct   Nov   Dec' char(10)];

    ostr = [ostr sprintf('%i ', config('monthtempgradyes'))];
    monthtempgradLoc = cell2mat(arrayfun(@(x)sprintf('%i ', x),config('monthtempgrad'), 'uniformoutput', false));
    ostr = [ostr monthtempgradLoc(1:end-1)];
    ostr = [ostr '    %%monthtempgrad(yes)' char(10)];

    ostr = [ostr sprintf('%i ', config('monthtempscenyes'))];
    monthtempscenLoc = cell2mat(arrayfun(@(x)sprintf('%i ', x),config('monthtempscen'), 'uniformoutput', false));
    ostr = [ostr monthtempscenLoc(1:end-1)];
    ostr = [ostr '    %%monthtempscen(yes)' char(10)];


    ostr = [ostr sprintf('%i ', config('monthprecipscenyes'))];
    monthtempprecipscenLoc = cell2mat(arrayfun(@(x)sprintf('%i ', x),config('monthprecipscen'), 'uniformoutput', false));
    ostr = [ostr monthtempprecipscenLoc(1:end-1)];
    ostr = [ostr '    %%monthprecipscen(yes)' char(10)];


    ostr = [ostr '%%******** 8.) SURFACE TYPE / ALBEDO ***********************************' char(10)];
    ostr = [ostr sprintf('%i    %%number of transient surface type files\n', config('n_albfiles'))];
    ostr = [ostr sprintf('%f    %%albedo for snow and firn (fixed value).  albsnow\n', config('albsnow'))];
    ostr = [ostr sprintf('%f    %%albedo for slush.  albslush\n', config('albslush'))];
    ostr = [ostr sprintf('%f    %%albedo for ice.  albice\n', config('albice'))];
    ostr = [ostr sprintf('%f    %%albedo for firn (method 2).  albfirn\n', config('albfirn'))];
    ostr = [ostr sprintf('%f    %%albedo for rock outside glacier.  albrock\n', config('albrock'))];
    ostr = [ostr sprintf('%f    %%minimum albedo for snow if generated.  albmin\n', config('albmin'))];
    ostr = [ostr sprintf('%f    %%increase snowalb/100m elevation for 1. time. snowalbincrease\n', config('snowalbincrease'))];
    ostr = [ostr sprintf('%f    %%decrease of ice albedo with elevation.  albiceproz\n', config('albiceproz'))];
    ostr = [ostr sprintf('%i    %%number of days since snow fall at start.  ndstart\n', config('ndstart'))];

    ostr = [ostr '%%******** 9.) RADIATION *******************************************' char(10)];
    ostr = [ostr sprintf('%i    %%number of shade calculation per time step.  split\n', config('split'))];
    ostr = [ostr sprintf('%f    %%percent diffuse radiation of global radiation.  prozdiffuse\n', config('prozdiffuse'))];
    ostr = [ostr sprintf('%f    %%transmissivity.  trans\n', config('trans'))];
    ostr = [ostr sprintf('%f    %%first ratio of global radiation and direct rad.  ratio\n', config('ratio'))];
    ostr = [ostr sprintf('%f    %%first ratio of direct and clear-sky direct rad.  ratiodir2dir\n', config('ratiodir2dir'))];
    ostr = [ostr sprintf('%f    %%decrease in surftemp with height if longout meas.  surftemplapserate\n', config('surftemplapserate'))];
    ostr = [ostr sprintf('%i    %%direct radiation read from file = 1.  directfromfile\n', config('directfromfile'))];
    ostr = [ostr sprintf('%s    %%Path for direct files.  pathdirectfile\n', config('pathdirectfile'))];
    ostr = [ostr sprintf('%i    %%files only exist every number of days defined here.  daysdirect\n', config('daysdirect'))];
    ostr = [ostr sprintf('%f    %%0=slope at climate station is set to 0.  slopestation\n', config('slopestation'))];

    ostr = [ostr '%%******** 10.) TURBULENCE ***********************************************' char(10)];
    ostr = [ostr sprintf('%f    %%step for surface temp lowering for iteration.  iterstep\n', config('iterstep'))];
    ostr = [ostr sprintf('%f    %%roughness length for wind for ice in m   .0027.  z0wice\n', config('z0wice'))];
    ostr = [ostr sprintf('%f    %%z0Temp is zow divided by this value.  dividerz0T\n', config('dividerz0T'))];
    ostr = [ostr sprintf('%f    %%z0snow is z0wice divided by this value.  dividerz0snow\n', config('dividerz0snow'))];
    ostr = [ostr sprintf('%f    %%increase of z0 with decreasing elevation.  z0proz\n', config('z0proz'))];
    ostr = [ostr sprintf('%f    %%min z0w ice.  icez0min\n', config('icez0min'))];
    ostr = [ostr sprintf('%f    %%max z0w ice.  icez0max\n', config('icez0max'))];

    ostr = [ostr '%%********** 11.) PRECIPITATION *******************************************' char(10)];
    ostr = [ostr sprintf('%i    %%1=lapse rate 2=scale AWS precip with index map 3=read grids.  methodprecipinterpol\n', config('methodprecipinterpol'))];
    ostr = [ostr sprintf('%f    %%precipitation change with elevation [%%/100m].  precgrad\n', config('precgrad'))];
    ostr = [ostr sprintf('%f %i    %%precipitation change with elevation beyond certain elevation.  precgradhigh precgradelev\n', config('precgradhigh'), config('precgradelev'))];
    ostr = [ostr sprintf('%f    %%35 precipitation correction, caused by losses.  preccorr\n', config('preccorr'))];
    ostr = [ostr sprintf('%f    %%snow precip is multiplied by this factor.  snowmultiplierglacier\n', config('snowmultiplierglacier'))];
    ostr = [ostr sprintf('%f    %%snow precip is multiplied by this factor.  snowmultiplierrock\n', config('snowmultiplierrock'))];
    ostr = [ostr sprintf('%f    %%threshold temperature rain/snow precipitation.  threshtemp\n', config('threshtemp'))];
    ostr = [ostr sprintf('%i    %%0=if massbal calculations for whole drainage basin, 1=only glacier.  onlyglacieryes\n', config('onlyglacieryes'))];
    ostr = [ostr sprintf('%f    %%percentage of glacierization.  glacierpart\n', config('glacierpart'))];

    ostr = [ostr '%%************* 13.) DISCHARGE STARTING VALUES**********************' char(10)];
    ostr = [ostr sprintf('%s     %%name of discharge output file.  nameqcalc\n', config('nameqcalc'))];
    ostr = [ostr sprintf('%i    %%nodata value of discharge file.  nodis\n', config('nodis'))];
    ostr = [ostr sprintf('%i    %%storage constant k for firn.  firnkons\n', config('firnkons'))];
    ostr = [ostr sprintf('%i    %%storage constant k for snow.  snowkons\n', config('snowkons'))];
    ostr = [ostr sprintf('%i    %%storage constant k for ice.  icekons\n', config('icekons'))];
    ostr = [ostr sprintf('%i    %%storage constant k for rock(outside glacier non-snowcovered.  icekons\n', config('rockkons'))];

    ostr = [ostr '%%************* 13.) DISCHARGE STARTING VALUES**********************' char(10)];
    ostr = [ostr sprintf('%f    %%start value for firn discharge (previous time step).  qfirnstart\n', config('qfirnstart'))];
    ostr = [ostr sprintf('%f    %%start value for snow discharge (m3/s).  qsnowstart\n', config('qsnowstart'))];
    ostr = [ostr sprintf('%f    %%start value for ice discharge.  qicestart\n', config('qicestart'))];
    ostr = [ostr sprintf('%f    %%start value for rock discharge (outside glacier non-snowcovered).  qicestart\n', config('qrockstart'))];
    ostr = [ostr sprintf('%f    %%groundwater discharge[m3].  qground\n', config('qground'))];
    ostr = [ostr sprintf('%f    %%difference between start of calculation and start r2.  jdstartr2diff\n', config('jdstartr2diff'))];

    ostr = [ostr '%%%%%%%%%%%%%%%%%%%%%%%% 15.) OPTIMIZATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%' char(10)];
    ostr = [ostr sprintf('%i    %%optimization run for k-values = 1; simulation=0.  disyesopt\n', config('disyesopt'))];
    ostr = [ostr sprintf('%s    %%1. parameter to optimize.  optkA\n', config('optkA'))];
    ostr = [ostr sprintf('%f    %%startvalue of 1. parameter to optimize.  startopt1\n', config('startopt1'))];
    ostr = [ostr sprintf('%f    %%step length.  stepopt1\n', config('stepopt1'))];
    ostr = [ostr sprintf('%i    %%number of steps no.1  anzahlopt1\n', config('anzahlopt1'))];
    ostr = [ostr sprintf('%s    %%2. parameter to optimize.  optkB\n', config('optkB'))];
    ostr = [ostr sprintf('%f    %%startvalue of 2. parameter.  startopt2\n', config('startopt2'))];
    ostr = [ostr sprintf('%f    %%steplength no.2 of optimal r2.  stepopt2\n', config('stepopt2'))];
    ostr = [ostr sprintf('%i    %%number of steps no.2.  anzahlopt2\n', config('anzahlopt2'))];
    ostr = [ostr sprintf('%s    %%name of r2-outputfile.  namematrix\n', config('namematrix'))];
    
    ostr = [ostr '%%============ 16.) SNOW MODEL by C. Tijm-Reijmer 2/2005 ========================' char(10)];
    ostr = [ostr sprintf('%i    %%0=no percolation, 1=percolation+refreezing in snowlayer.  percolationyes\n', config('percolationyes'))];
    ostr = [ostr sprintf('%i    %%0=no slush, 1=meltwater accumulation in snowlayer.  slushformationyes\n', config('slushformationyes'))];
    ostr = [ostr sprintf('%i    %%0=no densification, 1=densific. of dry snow due to aging.  densificationyes\n', config('densificationyes'))];
    ostr = [ostr sprintf('%i    %%0=dry start, 1=wet start.  wetstartyes\n', config('wetstartyes'))];
    ostr = [ostr sprintf('%i    %%maximum number of vertical layers.  ndepths\n', config('ndepths'))];
    ostr = [ostr sprintf('%i    %%number of subtimesteps for interpolation per main timestep 8.  factinter\n', config('factinter'))];

    ostr = [ostr '%%----------------------------' char(10)];
    ostr = [ostr sprintf('%f    %%layer thickness of first layer (m snow).  thicknessfirst\n', config('thicknessfirst'))];
    ostr = [ostr sprintf('%f    %%layer thickness at deepest layer (m snow).  thicknessdeep\n', config('thicknessdeep'))];
    ostr = [ostr sprintf('%f    %%maximum depth model (m).  depthdeep\n', config('depthdeep'))];
    ostr = [ostr sprintf('%i    %%density of fresh snowfall kg/m3.  denssnow\n', config('denssnow'))];
    ostr = [ostr sprintf('%i    %%0=constant irreducible water content, 1=density dep. Schneider, 2= density dep. Coleou.  irrwatercontyes\n', config('irrwatercontyes'))];
    ostr = [ostr sprintf('%f    %%fraction of space irreducible filled with water.  irrwatercont\n', config('irrwatercont'))];

    ostr = [ostr '%%---- Output ----------' char(10)];
    ostr = [ostr sprintf('%i    %%factor for subsurf output, 1=every hour, 24=once per day at midnight.  factsubsurfout\n', config('factsubsurfout'))];
    ostr = [ostr sprintf('%i    %%offfsetfactor for subsurf output to make print at noon possible.  offsetsubsurfout\n', config('offsetsubsurfout'))];
    ostr = [ostr sprintf('%%runoffyes superyes   wateryes   surfwateryes slushyes   coldsnowyes   coldtotyes.      for grid output\n')];
    ostr = [ostr sprintf('%i %i %i %i %i %i %i\n', config('runoffyes'), config('superyes'), config('wateryes'), config('surfwateryes'), config('slushyes'), config('coldsnowyes'), config('coldtotyes'))];

    ostr = [ostr '%%========================================================' char(10)];
    ostr = [ostr '%%   17.) TEMPERATURE INDEX METHOD' char(10)];
    ostr = [ostr '%%========================================================' char(10)];
    ostr = [ostr sprintf('%i    %%which temp index method (1,2 or 3).  ddmethod\n', config('ddmethod'))];
    ostr = [ostr sprintf('%f    %%degree day factor for ice (only simple DDF method 1).  DDFice\n', config('DDFice'))];
    ostr = [ostr sprintf('%f    %%degree day factor for snow (only simple DDF method 1).  DDFsnow\n', config('DDFsnow'))];
    ostr = [ostr '%%---------------------------------------------------' char(10)];
    ostr = [ostr sprintf('%f    %%meltfactor (only for modified temp index method 2 or 3).  meltfactor\n', config('meltfactor'))];
    ostr = [ostr sprintf('%f    %%radiation melt factor for ice.  radfactorice\n', config('radfactorice'))];
    ostr = [ostr sprintf('%f    %%radiation melt factor for snow.  radfactorsnow\n', config('radfactorsnow'))];
    ostr = [ostr sprintf('%i    %%factor to reduce melt over debris.  debrisfactor\n', config('debrisfactor'))];
    ostr = [ostr '%%******* 18.) OUTPUT STAKES **************************************' char(10)];
    ostr = [ostr sprintf('%i    %%1=stake locations given in local coordinates (x,y), 2=as 1 but center, 3=row/col.  coordinatesyes\n', config('coordinatesyes'))];

    stake_coordsLoc = '';
    for stake = config('stake_coords')
      thisStake = [sprintf('%f',stake(1)) ' ' sprintf('%f', stake(2)) char(10)];
      stake_coordsLoc = [stake_coordsLoc thisStake];
    end
    ostr = [ostr stake_coordsLoc];

  end
