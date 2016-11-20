
fprintf('Loading data from moneydata.mat ...\n');
load moneydata

% Recessions = [ datenum('15-May-1937'), datenum('15-Jun-1938');
% 	datenum('15-Feb-1945'), datenum('15-Oct-1945');
% 	datenum('15-Nov-1948'), datenum('15-Oct-1949');
% 	datenum('15-Jul-1953'), datenum('15-May-1954');
% 	datenum('15-Aug-1957'), datenum('15-Apr-1958');
% 	datenum('15-Apr-1960'), datenum('15-Feb-1961');
% 	datenum('15-Dec-1969'), datenum('15-Nov-1970');
% 	datenum('15-Nov-1973'), datenum('15-Mar-1975');
% 	datenum('15-Jan-1980'), datenum('15-Jul-1980');
% 	datenum('15-Jul-1981'), datenum('15-Nov-1982');
% 	datenum('15-Jul-1990'), datenum('15-Mar-1991');
% 	datenum('15-Mar-2001'), datenum('15-Nov-2001');
% 	datenum('15-Dec-2007'), datenum('15-5-2016') ];
Recessions = [datenum('6-6-2015'), datenum('6-7-2015');
              datenum('6-7-2015'), datenum('6-8-2015');
              datenum('6-8-2015'), datenum('6-9-2015');
              datenum('6-9-2015'), datenum('6-10-2015');
              datenum('6-10-2015'), datenum('6-11-2015');
              datenum('6-11-2015'), datenum('6-12-2015');
              datenum('6-12-2015'), datenum('6-1-2016');
              datenum('6-1-2016'), datenum('6-2-2016');
              datenum('6-2-2016'), datenum('6-3-2016');
              datenum('6-3-2016'), datenum('6-4-2016');
              datenum('6-4-2016'), datenum('6-5-2016');
              datenum('6-5-2016'), datenum('6-6-2016');
              datenum('6-6-2016'), datenum('6-7-2016')]

Recessions = busdate(Recessions);



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

%% Display Raw Data
%
% To see what our time series look like, we plot each of the differenced time
% series (identified with a lowercase r preceding the series mnemonic) and
% overlay shaded bands that identify periods of economic recession as determined
% by NBER.

clf;

subplot(2,1,1,'align');
plot(Dates, [rGDP, rINV]);
moneydemo_recessions(Dates, Recessions);
dateaxis('x');
title('\bf情感因素和收盘价趋势');
h = legend('情感因素','收盘价');
set(h,'FontSize',7,'Box','off');
axis([Dates(1) - 500, Dates(end) + 500, 0, 1]);
axis 'auto y'



subplot(2,1,2,'align');
plot(Dates, [rCONS, rGCE]);
moneydemo_recessions(Dates, Recessions);
dateaxis('x');
title('\bf情感因素和开盘价趋势');
h = legend('开盘价','情感因素');
set(h,'FontSize',7,'Box','off');
axis([Dates(1) - 600, Dates(end) + 600, 0, 1]);
axis 'auto y'





type moneydemo_recessions.m

%% Set up the Main Model
%


Y = [rGDP, rDEF, rWAGES, rHOURS, rTB3, rCONS, rINV, rUNEMP];
% Y = [rGDP, rCONS, rINV, rUNEMP rDEF, rWAGES, rHOURS, rTB3];
iY = [GDP, DEF, WAGES, HOURS, TB3, CONS, INV, UNEMP];
% iY= [GDP, CONS, INV, UNEMP,DEF, WAGES, HOURS, TB3]

YSeries = {'收盘价', 'Prices', 'Total Wages', 'Hours Worked', ...
	'Cash Rate', '最低价', '开盘价', '情感因素'};
YAbbrev = {'GDP', 'DEF', 'WAGES', 'HOURS', 'TB3', 'CONS', 'INV', 'UNEMP'};
% YSeries = {'收盘价',  '最低价', '开盘价', '情感因素','Prices', 'Total Wages', 'Hours Worked', ...
% 	'Cash Rate'};
% YAbbrev = {'GDP', 'CONS', 'INV', 'UNEMP', 'DEF', 'WAGES', 'HOURS', 'TB3'};

YInfo = '基于情感倾向多变量模型';

n = numel(YSeries);

fprintf('The date range for available data is %s to %s.\n', ...
	datestr(Dates(1),1),datestr(Dates(end),1));



%%



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

fprintf('模型最佳滞后阶数 %d.\n',nAR);

clf;

plot(AICtest);
hold on
scatter(nAR,AICmin,'filled','b');
title('最佳校准滞后阶数');
xlabel('滞后阶数');
ylabel('AIC');
hold off

%% Backtest to Assess Forecast Accuracy of the Model
% 求解模型的滞后阶数p=2

nAR = 2;

syy = 2015;                 % start year for backtest
eyy = 2016;                 % end year for backtest

Horizon = 4;                % number of quarters for forecast horizon

[T, n] = size(Y);

FError = NaN(eyy - syy + 1, n);
FDates = zeros(eyy - syy + 1, 1);

fprintf('RMSE of Actual vs Model Forecast (x 100) with Horizon of %d Quarters\n',Horizon);
fprintf('%3s','ForecastDate');
for i = 1:n
	fprintf('  %7s',YAbbrev{i});
end
fprintf('\n');

for yy = syy:eyy
	
	StartDate = lbusdate(2015,7);
	EndDate = lbusdate(yy,1);
	
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
% 	Y1 = Y(iStart:iEnd,:);
    Y1 = Y
    
    
    
%  
    
% 	iY1 = iY(iStart:iEnd,:);
	
    iY1 = iY
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
		
		fprintf('%3s',datestr(EndDate,1));
		for i = 1:n
			fprintf('  %7.2f',100*Yrmse(i));
		end
		FError(yy-syy+1,:) = 100*Yrmse';
		fprintf('\n');
	end
end

%% Assess Forecast Accuracy
%


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



%% Analysis to the End of 2016


nAR = 2;

% Set up date range

StartDate = lbusdate(2015,7);
EndDate = lbusdate(2015,12);

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

% % % for i = 1:n
% % % 	subplot(ceil(n/2),2,i,'align');
% % % 	plot(D1(end-Hw+1:end),Y1(end-Hw+1:end,i));
% % % 	hold on
% % % 	scatter(Dates(iEnd-Hw+1:iEnd+Ow),Y(iEnd-Hw+1:iEnd+Ow,i),'.');
% % % 	plot([D1(end); FD],[Y1(end,i); FY(:,i)],'b');
% % % 	plot(FD,[FY(:,i) - FYSigma(:,i), FY(:,i) + FYSigma(:,i)],':r');
% % % 	dateaxis('x',12);
% % % 	if i == 1
% % % 		title(['\bfModel Calibration to ' sprintf('%s',datestr(Dates(iEnd),1))]);
% % % 	end
% % % 	h = legend(YSeries{i},'Location','best');
% % % 	set(h,'FontSize',7,'Box','off');
% % % 	hold off
% % % end

	subplot(2,2,1,'align');
	plot(D1(end-Hw+1:end),Y1(end-Hw+1:end,1));
	hold on
	scatter(Dates(iEnd-Hw+1:iEnd+Ow),Y(iEnd-Hw+1:iEnd+Ow,1),'.');
	plot([D1(end); FD],[Y1(end,1); FY(:,1)],'b');
	plot(FD,[FY(:,1) - FYSigma(:,1), FY(:,1) + FYSigma(:,1)],':r');
	dateaxis('x',12);
	
	title(['\bfModel Calibration to ' sprintf('%s',datestr(Dates(iEnd),1))]);
	
	h = legend(YSeries{1},'Location','best');
	set(h,'FontSize',7,'Box','off');
	hold off
    
    subplot(2,2,2,'align');
	plot(D1(end-Hw+1:end),Y1(end-Hw+1:end,6));
	hold on
	scatter(Dates(iEnd-Hw+1:iEnd+Ow),Y(iEnd-Hw+1:iEnd+Ow,6),'.');
	plot([D1(end); FD],[Y1(end,6); FY(:,6)],'b');
	plot(FD,[FY(:,6) - FYSigma(:,6), FY(:,6) + FYSigma(:,6)],':r');
	dateaxis('x',12);
	h = legend(YSeries{6},'Location','best');
	set(h,'FontSize',7,'Box','off');
	hold off
    
    subplot(2,2,3,'align');
	plot(D1(end-Hw+1:end),Y1(end-Hw+1:end,7));
	hold on
	scatter(Dates(iEnd-Hw+1:iEnd+Ow),Y(iEnd-Hw+1:iEnd+Ow,7),'.');
	plot([D1(end); FD],[Y1(end,7); FY(:,7)],'b');
	plot(FD,[FY(:,7) - FYSigma(:,7), FY(:,7) + FYSigma(:,7)],':r');
	dateaxis('x',12);
	h = legend(YSeries{7},'Location','best');
	set(h,'FontSize',7,'Box','off');
	hold off
    
     subplot(2,2,4,'align');
	plot(D1(end-Hw+1:end),Y1(end-Hw+1:end,8));
	hold on
	scatter(Dates(iEnd-Hw+1:iEnd+Ow),Y(iEnd-Hw+1:iEnd+Ow,8),'.');
	plot([D1(end); FD],[Y1(end,8); FY(:,8)],'b');
	plot(FD,[FY(:,8) - FYSigma(:,8), FY(:,8) + FYSigma(:,8)],':r');
	dateaxis('x',12);
	h = legend(YSeries{8},'Location','best');
	set(h,'FontSize',7,'Box','off');
	hold off



%%



type moneydemo_quarterlydates.m

%% Analysis to the Current Available Date
%

nAR = 2;

% Set up date range

StartDate = lbusdate(2015,7);
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

%%


%% Impulse Response Analysis
%


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
title(['2015-6-1 至' sprintf('%s',datestr(Dates(iEnd),1))]);
dateaxis('x',12);
legend('预测趋势','实际观测值趋势','Location','Best');
grid on
ylabel('收盘价/对数值');

%%


%% Conclusion
%
% This demo shows a few things you can do with the multiple time series analysis
% tools in the Econometrics Toolbox. We have shown that a VAR model based
% loosely on the Smets-Wouters model provides reasonably accurate forecasts for
% most of the economic series in our model. Thus, the scripts in this demo are a
% good point of departure to begin testing your own ideas in macroeconomic
% modeling and analysis.

