%% Forecasting Analysis (moneydemo_forecasts)
%
% Robert Taylor
%
% This is a supplemental script that produces a sequence of four forecast plots
% for year-end 2006, 2007, 2008, and for the most recent date in the
% moneydata.mat file. It is best to either run each cell one-at-a-time or to
% publish the overall document.
%
% Copyright 2009 The MathWorks, Inc.

%% Load Time Series Data
%
% FRED Series   Description
% -----------   ----------------------------------------------------------------
% COE           Paid compensation of employees in $ billions
% CPIAUCSL      Consumer price index
% FEDFUNDS      Effective federal funds rate
% GCE           Government consumption expenditures and investment in $ billions
% GDP           Gross domestic product in $ billions
% GDPDEF        Gross domestic product price deflator
% GPDI          Gross private domestic investment in $ billions
% GS10          Ten-year treasury bond yield
% HOANBS        Non-farm business sector index of hours worked
% M1SL          M1 money supply (narrow money)
% M2SL          M2 money supply (broad money)
% PCEC          Personal consumption expenditures in $ billions
% TB3MS         Three-month treasury bill yield
% UNRATE        Unemployment rate

load moneydata

% Remove dates with NaN values

ii = any(isnan(Data),2);
Dates(ii) = [];
Data(ii,:) = [];
Dataset(ii,:) = [];

% Log series

CONS = log(Dataset.PCEC);
CPI = log(Dataset.CPIAUCSL);
DEF = log(Dataset.GDPDEF);
GCE = log(Dataset.GCE);
GDP = log(Dataset.GDP);
HOURS = log(Dataset.HOANBS);
INV = log(Dataset.GPDI);
M1 = log(Dataset.M1SL);
M2 = log(Dataset.M2SL);
WAGES = log(Dataset.COE);

% Interest rates (annual)

rFED = 0.01*(Dataset.FEDFUNDS);
rG10 = 0.01*(Dataset.GS10);
rTB3 = 0.01*(Dataset.TB3MS);

% Integrated rates

FED = ret2tick(0.25*rFED);
FED = log(FED(2:end));
G10 = ret2tick(0.25*rG10);
G10 = log(G10(2:end));
TB3 = ret2tick(0.25*rTB3);
TB3 = log(TB3(2:end));

% Unemployment rate

rUNEMP = 0.01*(Dataset.UNRATE);

UNEMP = ret2tick(0.25*rUNEMP);
UNEMP = log(UNEMP(2:end));

% Annualized rates

rCONS = [ 4*mean(diff(CONS(1:5))); 4*diff(CONS) ];
rCPI = [ 4*mean(diff(CPI(1:5))); 4*diff(CPI) ];
rDEF = [ 4*mean(diff(DEF(1:5))); 4*diff(DEF) ];
rGCE = [ 4*mean(diff(GCE(1:5))); 4*diff(GCE) ];
rGDP = [ 4*mean(diff(GDP(1:5))); 4*diff(GDP) ];
rHOURS = [ 4*mean(diff(HOURS(1:5))); 4*diff(HOURS) ];
rINV = [ 4*mean(diff(INV(1:5))); 4*diff(INV) ];
rM1 = [ 4*mean(diff(M1(1:5))); 4*diff(M1) ];
rM2 = [ 4*mean(diff(M2(1:5))); 4*diff(M2) ];
rWAGES = [ 4*mean(diff(WAGES(1:5))); 4*diff(WAGES) ];

%% Set up the Main Model
%
% The main model for our analysis uses the seven time series described in Smets
% and Wouters (2007) plus an appended eighth time series. These time series are
% listed in the following table with their relationship to raw FRED
% counterparts. The variable Y contains the main time series for the model and
% the variable iY contains integrated data from Y that will be used in
% forecasting analyses.

%   Model       FRED Series   Transformation from FRED Data to Model Time Series
%   --------    -----------   --------------------------------------------------
%   rGDP        GDP           rGDP = diff(log(GDP))
%   rDEF        GDPDEF        rDEF = diff(log(GDPDEF))
%   rWAGES      COE           rWAGE = diff(log(COE))
%   rHOURS      HOANBS        rWORK = diff(log(WORK))
%   rTB3        TB3MS         rTB3 = 0.01*TB3MS
%   rCONS       PCEC          rCONS = diff(log(PCEC))
%   rINV        GPDI          rINV = diff(log(GPDI))
%   rUNEMP      UNRATE        rUNEMP = 0.01*UNRATE

Y = [rGDP, rDEF, rWAGES, rHOURS, rTB3, rCONS, rINV, rUNEMP];
iY = [GDP, DEF, WAGES, HOURS, TB3, CONS, INV, UNEMP];

YSeries = {'Output (GDP)', 'Prices', 'Total Wages', 'Hours Worked', ...
	'Cash Rate', 'Consumption', 'Private Investment', 'Unemployment'};
YAbbrev = {'GDP', 'DEF', 'WAGES', 'HOURS', 'TB3', 'CONS', 'INV', 'UNEMP'};

YInfo = 'U.S. Macroeconomic Model';

n = numel(YSeries);

fprintf('The date range for available data is %s to %s.\n', ...
	datestr(Dates(1),1),datestr(Dates(end),1));

%% Analysis to the End of 2006

nAR = 2;

% Set up date range

StartDate = lbusdate(1959,3);
EndDate = lbusdate(2006,12);

if StartDate < Dates(1)
	error('StartDate is before earliest available date %s in data.',datestr(Dates(1),1));
end
if EndDate > Dates(end)
	error('EndDate is after last available date %s in data.',datestr(Dates(end),1));
end

% Locate indexes in data for specified date range

iStart = find(StartDate <= Dates,1);
if iStart < 1
	iStart = 1;
end
iEnd = find(EndDate <= Dates,1);
if iEnd > numel(Dates)
	iEnd = numel(Dates);
end

% Set up data for estimation

D1 = Dates(iStart:iEnd,:);			% Dates for specified date range
if iStart > 1
	Y0 = Y(1:iStart-1,:);			% presample data
else
	Y0 = [];
end
Y1 = Y(iStart:iEnd,:);				% estimation data

% Set up model and estimate coefficients

Spec = vgxset('n', n, 'Constant', true, 'nAR', nAR, 'Series', YSeries, 'Info', YInfo);
Spec = vgxvarx(Spec, Y1, [], Y0);

% Do forecasts

FT = 20;
FD = moneydemo_quarterlydates(Dates(iEnd), FT);

[FY, FYCov] = vgxpred(Spec, FT, [], Y1);
FYSigma = zeros(size(FY));
for t = 1:FT
	FYSigma(t,:) = sqrt(diag(FYCov{t}))';
end

Hw = 20;                                    % number of historical quarters to display
Fw = 20;                                    % number of forecast quarters to display
Ow = max(0,min(Fw,(size(Y,1) - iEnd)));     % overlap between historical and forecast data

clf;

for i = 1:n
	subplot(ceil(n/2),2,i,'align');
	plot(D1(end-Hw+1:end),Y1(end-Hw+1:end,i));
	hold on
	scatter(Dates(iEnd-Hw+1:iEnd+Ow),Y(iEnd-Hw+1:iEnd+Ow,i),'.');
	plot([D1(end); FD],[Y1(end,i); FY(:,i)],'b');
	plot(FD,[FY(:,i) - FYSigma(:,i), FY(:,i) + FYSigma(:,i)],':r');
	dateaxis('x',12);
	if i == 1
		title(['\bfModel Calibration to ' sprintf('%s',datestr(Dates(iEnd),1))]);
	end
	h = legend(YSeries{i},'Location','best');
	set(h,'FontSize',7,'Box','off');
	hold off
end

%% Analysis to the End of 2007

nAR = 2;

% Set up date range

StartDate = lbusdate(1959,3);
EndDate = lbusdate(2007,12);

if StartDate < Dates(1)
	error('StartDate is before earliest available date %s in data.',datestr(Dates(1),1));
end
if EndDate > Dates(end)
	error('EndDate is after last available date %s in data.',datestr(Dates(end),1));
end

% Locate indexes in data for specified date range

iStart = find(StartDate <= Dates,1);
if iStart < 1
	iStart = 1;
end
iEnd = find(EndDate <= Dates,1);
if iEnd > numel(Dates)
	iEnd = numel(Dates);
end

% Set up data for estimation

D1 = Dates(iStart:iEnd,:);			% Dates for specified date range
if iStart > 1
	Y0 = Y(1:iStart-1,:);			% presample data
else
	Y0 = [];
end
Y1 = Y(iStart:iEnd,:);				% estimation data

% Set up model and estimate coefficients

Spec = vgxset('n', n, 'Constant', true, 'nAR', nAR, 'Series', YSeries, 'Info', YInfo);
Spec = vgxvarx(Spec, Y1, [], Y0);

% Do forecasts

FT = 20;
FD = moneydemo_quarterlydates(Dates(iEnd), FT);

[FY, FYCov] = vgxpred(Spec, FT, [], Y1);
FYSigma = zeros(size(FY));
for t = 1:FT
	FYSigma(t,:) = sqrt(diag(FYCov{t}))';
end

Hw = 20;                                    % number of historical quarters to display
Fw = 20;                                    % number of forecast quarters to display
Ow = max(0,min(Fw,(size(Y,1) - iEnd)));     % overlap between historical and forecast data

clf;

for i = 1:n
	subplot(ceil(n/2),2,i,'align');
	plot(D1(end-Hw+1:end),Y1(end-Hw+1:end,i));
	hold on
	scatter(Dates(iEnd-Hw+1:iEnd+Ow),Y(iEnd-Hw+1:iEnd+Ow,i),'.');
	plot([D1(end); FD],[Y1(end,i); FY(:,i)],'b');
	plot(FD,[FY(:,i) - FYSigma(:,i), FY(:,i) + FYSigma(:,i)],':r');
	dateaxis('x',12);
	if i == 1
		title(['\bfModel Calibration to ' sprintf('%s',datestr(Dates(iEnd),1))]);
	end
	h = legend(YSeries{i},'Location','best');
	set(h,'FontSize',7,'Box','off');
	hold off
end


%% Analysis to the End of 2008

nAR = 2;

% Set up date range

StartDate = lbusdate(1959,3);
EndDate = lbusdate(2008,12);

if StartDate < Dates(1)
	error('StartDate is before earliest available date %s in data.',datestr(Dates(1),1));
end
if EndDate > Dates(end)
	error('EndDate is after last available date %s in data.',datestr(Dates(end),1));
end

% Locate indexes in data for specified date range

iStart = find(StartDate <= Dates,1);
if iStart < 1
	iStart = 1;
end
iEnd = find(EndDate <= Dates,1);
if iEnd > numel(Dates)
	iEnd = numel(Dates);
end

% Set up data for estimation

D1 = Dates(iStart:iEnd,:);			% Dates for specified date range
if iStart > 1
	Y0 = Y(1:iStart-1,:);			% presample data
else
	Y0 = [];
end
Y1 = Y(iStart:iEnd,:);				% estimation data

% Set up model and estimate coefficients

Spec = vgxset('n', n, 'Constant', true, 'nAR', nAR, 'Series', YSeries, 'Info', YInfo);
Spec = vgxvarx(Spec, Y1, [], Y0);

% Do forecasts

FT = 20;
FD = moneydemo_quarterlydates(Dates(iEnd), FT);

[FY, FYCov] = vgxpred(Spec, FT, [], Y1);
FYSigma = zeros(size(FY));
for t = 1:FT
	FYSigma(t,:) = sqrt(diag(FYCov{t}))';
end

Hw = 20;                                    % number of historical quarters to display
Fw = 20;                                    % number of forecast quarters to display
Ow = max(0,min(Fw,(size(Y,1) - iEnd)));     % overlap between historical and forecast data

clf;

for i = 1:n
	subplot(ceil(n/2),2,i,'align');
	plot(D1(end-Hw+1:end),Y1(end-Hw+1:end,i));
	hold on
	scatter(Dates(iEnd-Hw+1:iEnd+Ow),Y(iEnd-Hw+1:iEnd+Ow,i),'.');
	plot([D1(end); FD],[Y1(end,i); FY(:,i)],'b');
	plot(FD,[FY(:,i) - FYSigma(:,i), FY(:,i) + FYSigma(:,i)],':r');
	dateaxis('x',12);
	if i == 1
		title(['\bfModel Calibration to ' sprintf('%s',datestr(Dates(iEnd),1))]);
	end
	h = legend(YSeries{i},'Location','best');
	set(h,'FontSize',7,'Box','off');
	hold off
end

%% Analysis to the Current Available Date

nAR = 2;

% Set up date range

StartDate = lbusdate(1959,3);
EndDate = Dates(end);

if StartDate < Dates(1)
	error('StartDate is before earliest available date %s in data.',datestr(Dates(1),1));
end
if EndDate > Dates(end)
	error('EndDate is after last available date %s in data.',datestr(Dates(end),1));
end

% Locate indexes in data for specified date range

iStart = find(StartDate <= Dates,1);
if iStart < 1
	iStart = 1;
end
iEnd = find(EndDate <= Dates,1);
if iEnd > numel(Dates)
	iEnd = numel(Dates);
end

% Set up data for estimation

D1 = Dates(iStart:iEnd,:);			% Dates for specified date range
if iStart > 1
	Y0 = Y(1:iStart-1,:);			% presample data
else
	Y0 = [];
end
Y1 = Y(iStart:iEnd,:);				% estimation data

% Set up model and estimate coefficients

Spec = vgxset('n', n, 'Constant', true, 'nAR', nAR, 'Series', YSeries, 'Info', YInfo);
Spec = vgxvarx(Spec, Y1, [], Y0);

% Do forecasts

FT = 20;
FD = moneydemo_quarterlydates(Dates(iEnd), FT);

[FY, FYCov] = vgxpred(Spec, FT, [], Y1);
FYSigma = zeros(size(FY));
for t = 1:FT
	FYSigma(t,:) = sqrt(diag(FYCov{t}))';
end

Hw = 20;                                    % number of historical quarters to display
Fw = 20;                                    % number of forecast quarters to display
Ow = max(0,min(Fw,(size(Y,1) - iEnd)));     % overlap between historical and forecast data

clf;

for i = 1:n
	subplot(ceil(n/2),2,i,'align');
	plot(D1(end-Hw+1:end),Y1(end-Hw+1:end,i));
	hold on
	scatter(Dates(iEnd-Hw+1:iEnd+Ow),Y(iEnd-Hw+1:iEnd+Ow,i),'.');
	plot([D1(end); FD],[Y1(end,i); FY(:,i)],'b');
	plot(FD,[FY(:,i) - FYSigma(:,i), FY(:,i) + FYSigma(:,i)],':r');
	dateaxis('x',12);
	if i == 1
		title(['\bfModel Calibration to ' sprintf('%s',datestr(Dates(iEnd),1))]);
	end
	h = legend(YSeries{i},'Location','best');
	set(h,'FontSize',7,'Box','off');
	hold off
end
