load momeydata

Recessions = [ datenum('15-May-1937'), datenum('15-Jun-1938');
	datenum('15-Feb-1945'), datenum('15-Oct-1945');
	datenum('15-Nov-1948'), datenum('15-Oct-1949');
	datenum('15-Jul-1953'), datenum('15-May-1954');
	datenum('15-Aug-1957'), datenum('15-Apr-1958');
	datenum('15-Apr-1960'), datenum('15-Feb-1961');
	datenum('15-Dec-1969'), datenum('15-Nov-1970');
	datenum('15-Nov-1973'), datenum('15-Mar-1975');
	datenum('15-Jan-1980'), datenum('15-Jul-1980');
	datenum('15-Jul-1981'), datenum('15-Nov-1982');
	datenum('15-Jul-1990'), datenum('15-Mar-1991');
	datenum('15-Mar-2001'), datenum('15-Nov-2001');
	datenum('15-Dec-2007'), today ];

Recessions = busdate(Recessions);

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


clf;

subplot(3,2,1,'align');
plot(Dates, [rGDP, rINV]);
moneydemo_recessions(Dates, Recessions);
dateaxis('x');
title('\bfInvestment and Output');
h = legend('GDP','INV','Location','Best');
set(h,'FontSize',7,'Box','off');
axis([Dates(1) - 600, Dates(end) + 600, 0, 1]);
axis 'auto y'
hold on;

subplot(3,2,2,'align');
plot(Dates, [rCPI, rDEF]);
moneydemo_recessions(Dates, Recessions);
dateaxis('x');
title('\bfInflation and GDP Deflator');
h = legend('CPI','DEF','Location','Best');
set(h,'FontSize',7,'Box','off');
axis([Dates(1) - 600, Dates(end) + 600, 0, 1]);
axis 'auto y'

subplot(3,2,3,'align');
plot(Dates, [rWAGES, rHOURS]);
moneydemo_recessions(Dates, Recessions);
dateaxis('x');
title('\bfWages and Hours');
h = legend('WAGES','HOURS','Location','Best');
set(h,'FontSize',7,'Box','off');
axis([Dates(1) - 600, Dates(end) + 600, 0, 1]);
axis 'auto y'

subplot(3,2,4,'align');
plot(Dates, [rCONS, rGCE]);
moneydemo_recessions(Dates, Recessions);
dateaxis('x');
title('\bfConsumption');
h = legend('CONS','GCE','Location','Best');
set(h,'FontSize',7,'Box','off');
axis([Dates(1) - 600, Dates(end) + 600, 0, 1]);
axis 'auto y'

subplot(3,2,5,'align');
plot(Dates, [rFED, rG10, rTB3]);
moneydemo_recessions(Dates, Recessions);
dateaxis('x');
title('\bfInterest Rates');
h = legend('FED','G10','TB3','Location','Best');
set(h,'FontSize',7,'Box','off');
axis([Dates(1) - 600, Dates(end) + 600, 0, 1]);
axis 'auto y'

subplot(3,2,6,'align');
plot(Dates, rUNEMP);
moneydemo_recessions(Dates, Recessions);
dateaxis('x');
title('\bfUnemployment');
h = legend('UNEMP','Location','Best');
set(h,'FontSize',7,'Box','off');
axis([Dates(1) - 600, Dates(end) + 600, 0, 1]);
axis 'auto y'
hold on;

type moneydemo_recessions.m

Y = [rGDP, rDEF, rWAGES, rHOURS, rTB3, rCONS, rINV, rUNEMP];
iY = [GDP, DEF, WAGES, HOURS, TB3, CONS, INV, UNEMP];

YSeries = {'Output (GDP)', 'Prices', 'Total Wages', 'Hours Worked', ...
	'Cash Rate', 'Consumption', 'Private Investment', 'Unemployment'};
YAbbrev = {'GDP', 'DEF', 'WAGES', 'HOURS', 'TB3', 'CONS', 'INV', 'UNEMP'};

YInfo = 'U.S. Macroeconomic Model';

n = numel(YSeries);

fprintf('The date range for available data is %s to %s.\n', ...
	datestr(Dates(1),1),datestr(Dates(end),1));


nARmax = 7;

Y0 = Y(1:nARmax,:);
Y1 = Y(nARmax+1:end,:);

AICtest = zeros(nARmax,1);
for i = 1:nARmax
	Spec = vgxset('n', n, 'Constant', true, 'nAR', i, 'Series', YSeries);
	[Spec, SpecStd, LLF] = vgxvarx(Spec, Y1, [], Y0);
	AICtest(i) = aicbic(LLF,Spec.NumActive,Spec.T);
	fprintf('AIC(%d) = %g\n',i,AICtest(i));
end
[AICmin, nAR] = min(AICtest);

fprintf('Optimal lag for model is %d.\n',nAR);

clf;

plot(AICtest);
hold on
scatter(nAR,AICmin,'filled','b');
title('\bfOptimal Lag Order with Akaike Information Criterion');
xlabel('Lag Order');
ylabel('AIC');
hold off



nAR = 2;

syy = 1975;                 % start year for backtest
eyy = 2008;                 % end year for backtest

Horizon = 4;                % number of quarters for forecast horizon

[T, n] = size(Y);

FError = NaN(eyy - syy + 1, n);
FDates = zeros(eyy - syy + 1, 1);

fprintf('RMSE of Actual vs Model Forecast (x 100) with Horizon of %d Quarters\n',Horizon);
fprintf('%12s','ForecastDate');
for i = 1:n
	fprintf('  %7s',YAbbrev{i});
end
fprintf('\n');

for yy = syy:eyy
	
	StartDate = lbusdate(1959,3);
	EndDate = lbusdate(yy,12);
	
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
	
	if iStart > 1
		Y0 = Y(1:iStart-1,:);
	else
		Y0 = [];
	end
	Y1 = Y(iStart:iEnd,:);
	iY1 = iY(iStart:iEnd,:);
	
	% Set up model and estimate coefficients
	
	Spec = vgxset('n', n, 'Constant', true, 'nAR', nAR, 'Series', YSeries, 'Info', YInfo);
	Spec = vgxvarx(Spec, Y1, [], Y0);
	
	% Do forecasts
	
	NumPaths = 500;
	iFY = vgxsim(Spec, Horizon, [], Y1, [], NumPaths);
	iFY = repmat(iY1(end,:),[Horizon,1,NumPaths]) + 0.25*cumsum(iFY);
	eFY = mean(iFY,3);
	
	% Assess Forecast Quality
	
	Ow = max(0,min(Horizon,(size(Y,1) - iEnd)));		% overlap between actual and forecast data
	
	if Ow >= Horizon
		h = Horizon;
	else
		h = [];
	end
	
	FDates(yy-syy+1) = lbusdate(yy,12);
	if ~isempty(h)
		Yerr = iY(iEnd+1:iEnd+Ow,:) - eFY(1:Ow,:);
		
		Ym2 = Yerr(1:h,:) .^ 2;
		Yrmse = sqrt(mean(Ym2,1));
		
		fprintf('%12s',datestr(EndDate,1));
		for i = 1:n
			fprintf('  %7.2f',100*Yrmse(i));
		end
		FError(yy-syy+1,:) = 100*Yrmse';
		fprintf('\n');
	end
end

mFError = NaN(size(FError));
sFError = NaN(size(FError));
for i = 1:n
	mFError(:,i) = nanmean(FError(:,i));
	sFError(:,i) = nanstd(FError(:,i));
end

for i = 1:n
	subplot(ceil(n/2),2,i,'align');
	plot(FDates,FError(:,i));
	hold on
	plot(FDates,mFError(:,i),'g');
	plot(FDates,[mFError(:,i) - sFError(:,i),mFError(:,i) + sFError(:,i)],':r');
	moneydemo_recessions(FDates, Recessions);
	dateaxis('x',12);
	if i == 1
		title(['\bfForecast Accuracy for ' sprintf('%g',Horizon/4) '-Year Horizon']);
	end
	h = legend(YSeries{i},'Location','best');
	set(h,'FontSize',7,'Box','off');
	hold off
end

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

type moneydemo_quarterlydates.m

%% Analysis to the Current Available Date
%
% We now repeat our previous analysis with more recent data. With downloaded
% data from FRED, we can run our analysis on the most current available data.
% Otherwise, we have data to the end of March 2009.

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

Impulses = YAbbrev;
Responses = YAbbrev;

W0 = zeros(FT, n);

clf;

ii = 0;
for i = 1:n
	WX = W0;
	WX(1,i) = sqrt(Spec.Q(i,i));
	YX = 100*(vgxproc(Spec, WX, [], Y1) - vgxproc(Spec, W0, [], Y1));
	for j = 1:n
		ii = ii + 1;
		subplot(n,n,ii,'align');
		plot(YX(:,j));
		if i == 1
			title(['\bf ' Responses{j}]);
		end
		if j == 1
			ylabel(['\bf ' Impulses{i}]);
		end
		if i == n
			set(gca,'xtickmode','auto');
		else
			set(gca,'xtick',[]);
		end
	end
end


%% Real GDP Forecast
%
% The final analysis is a forecast of real GDP based on the calibrated model to
% the current available date. The projected value is compared with a long-term
% trend value based on the past 30 years of real GDP data.

iY1 = iY(iStart:iEnd,:);

% Simulate forecasts of cumulative values of model time series

NumPaths = 1000;
iFY = vgxsim(Spec, FT, [], Y1, [], NumPaths);
iFY = repmat(iY1(end,:),[FT,1,NumPaths]) + 0.25*cumsum(iFY);
iFY = iFY(:,1,:) - iFY(:,2,:);
FGDP = mean(iFY,3);
FGDPSigma = std(iFY,0,3);
FGDP0 = GDP(iEnd) - DEF(iEnd);

w = 120;
H = [ ones(w,1) (1:w)' ];
trendParam = H \ (GDP(iEnd - w + 1:iEnd) - DEF(iEnd - w + 1:iEnd));
trendFGDP = [ ones(FT,1) w + (1:FT)' ] * trendParam;

clf;

plot(FD, [FGDP, trendFGDP]);
hold on
plot(FD, [FGDP - FGDPSigma, FGDP + FGDPSigma],':r');
title(['\bfReal GDP Forecast Based on Data to End of ' sprintf('%s',datestr(Dates(iEnd),1))]);
dateaxis('x',12);
legend('Forecast','Long-Term Trend','Location','Best');
grid on
ylabel('Log Real GDP');

