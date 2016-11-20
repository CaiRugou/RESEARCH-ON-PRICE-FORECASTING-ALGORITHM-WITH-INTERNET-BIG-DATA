load moneydata

%% Business Cycle Dates from National Bureau of Economic Research
%
% To examine the interplay between the business cycle and our model, we also
% include the Dates for peaks and troughs of the economic cycle from the
% National Bureau of Economic Research (see link to NBER in the references). We
% arbitrarily set the middle of the listed month as the start or end date of a
% recession.

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


%% Transform Raw Data into Time Series for the Model 转变行数据 -> 时间序列模型

% Remove Dates with NaN values

ii = any(isnan(Data),2);
Dates(ii) = [];
Data(ii,:) = [];
Dataset(ii,:) = [];

% Log Series

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
%主要是时间序列的数据转换

%% Set up Three Models with Combinations of Base Model with or without M1 or M2
%建立三个模型---》1.基本模型   2. 包含 M1 和 M2 再建立模型  
% The main model for our analysis uses the seven time Series described in Smets
% and Wouters (2007) plus an appended eighth time Series. These time Series are
% listed in the following table with their relationship to raw FRED
% counterparts. The variable Y contains the main time Series for the model and
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
%   rM1         M1            rM1 = diff(log(M1))
%   rM2         M2            rM2 = diff(log(M2))

% YModel(Model,1) = Y
% YModel(Model,2) = iY
% YModel(Model,3) = YSeries
% YModel(Model,4) = YAbbrev
% YModel(Model,5) = nAR
% YModel(Model,6) = FError

YModel = cell(3,6);

Model = 1;
YModel{Model,1} = [rGDP, rDEF, rWAGES, rHOURS, rTB3, rCONS, rINV, rUNEMP];
YModel{Model,2} = [GDP, DEF, WAGES, HOURS, TB3, CONS, INV, UNEMP];
YModel{Model,3} = {'Output (GDP)', 'Prices', 'Total Wages', 'Hours Worked', ...
	'Cash Rate', 'Consumption', 'Private Investment', 'Unemployment'};
YModel{Model,4} = {'GDP', 'DEF', 'WAGES', 'HOURS', 'TB3', 'CONS', 'INV', 'UNEMP'};
YModel{Model,5} = 2;

Model = 2;
YModel{Model,1} = [rGDP, rDEF, rWAGES, rHOURS, rTB3, rCONS, rINV, rUNEMP, rM1];
YModel{Model,2} = [GDP, DEF, WAGES, HOURS, TB3, CONS, INV, UNEMP, M1];
YModel{Model,3} = {'Output (GDP)', 'Prices', 'Total Wages', 'Hours Worked', ...
	'Cash Rate', 'Consumption', 'Private Investment', 'Unemployment', 'M1 Money Supply'};
YModel{Model,4} = {'GDP', 'DEF', 'WAGES', 'HOURS', 'TB3', 'CONS', 'INV', 'UNEMP', 'M1'};
YModel{Model,5} = 2;

Model = 3;
YModel{Model,1} = [rGDP, rDEF, rWAGES, rHOURS, rTB3, rCONS, rINV, rUNEMP, rM2];
YModel{Model,2} = [GDP, DEF, WAGES, HOURS, TB3, CONS, INV, UNEMP, M2];
YModel{Model,3} = {'Output (GDP)', 'Prices', 'Total Wages', 'Hours Worked', ...
	'Cash Rate', 'Consumption', 'Private Investment', 'Unemployment', 'M2 Money Supply'};
YModel{Model,4} = {'GDP', 'DEF', 'WAGES', 'HOURS', 'TB3', 'CONS', 'INV', 'UNEMP', 'M2'};
YModel{Model,5} = 2;

YInfo = 'U.S. Macroeconomic Model';

fprintf('The date range for available data is %s to %s.\n', ...
	datestr(Dates(1),1),datestr(Dates(end),1));

NumPaths = 10000;					% number of samples for Monte Carlo simulation 蒙特卡罗模拟的样本数
Horizon = 4;						% number of quarters for forecast horizon 预测水平


StartDate = lbusdate(1959,3);		% start date for data        开始日期
syy = 1975;							% start year for backtest   为测试启动
eyy = 2008;							% end year for backtest     测试结束日期  





%% Backtest First Model

Model = 1;

Y = YModel{Model,1};
iY = YModel{Model,2};
YSeries = YModel{Model,3};
YAbbrev = YModel{Model,4};
nAR = YModel{Model,5};

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

YModel{Model,6} = FError;

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


% %% Backtest Second Model
% 
% Model = 2;
% 
% Y = YModel{Model,1};
% iY = YModel{Model,2};
% YSeries = YModel{Model,3};
% YAbbrev = YModel{Model,4};
% nAR = YModel{Model,5};
% 
% [T, n] = size(Y);
% 
% FError = NaN(eyy - syy + 1, n);
% FDates = zeros(eyy - syy + 1, 1);
% 
% fprintf('RMSE of Actual vs Model Forecast (x 100) with Horizon of %d Quarters\n',Horizon);
% fprintf('%12s','ForecastDate');
% for i = 1:n
% 	fprintf('  %7s',YAbbrev{i});
% end
% fprintf('\n');
% 
% for yy = syy:eyy
% 	
% 	StartDate = lbusdate(1959,3);
% 	EndDate = lbusdate(yy,12);
% 	
% 	if StartDate < Dates(1)
% 		error('StartDate is before earliest available date %s in data.',datestr(Dates(1),1));
% 	end
% 	if EndDate > Dates(end)
% 		error('EndDate is after last available date %s in data.',datestr(Dates(end),1));
% 	end
% 	
% 	% Locate indexes in data for specified date range
% 	
% 	iStart = find(StartDate <= Dates,1);
% 	if iStart < 1
% 		iStart = 1;
% 	end
% 	iEnd = find(EndDate <= Dates,1);
% 	if iEnd > numel(Dates)
% 		iEnd = numel(Dates);
% 	end
% 	
% 	if iStart > 1
% 		Y0 = Y(1:iStart-1,:);
% 	else
% 		Y0 = [];
% 	end
% 	Y1 = Y(iStart:iEnd,:);
% 	iY1 = iY(iStart:iEnd,:);
% 	
% 	% Set up model and estimate coefficients
% 	
% 	Spec = vgxset('n', n, 'Constant', true, 'nAR', nAR, 'Series', YSeries, 'Info', YInfo);
% 	Spec = vgxvarx(Spec, Y1, [], Y0);
% 	
% 	% Do forecasts
% 	
% 	iFY = vgxsim(Spec, Horizon, [], Y1, [], NumPaths);
% 	iFY = repmat(iY1(end,:),[Horizon,1,NumPaths]) + 0.25*cumsum(iFY);
% 	eFY = mean(iFY,3);
% 	
% 	% Assess Forecast Quality
% 	
% 	Ow = max(0,min(Horizon,(size(Y,1) - iEnd)));		% overlap between actual and forecast data
% 	
% 	if Ow >= Horizon
% 		h = Horizon;
% 	else
% 		h = [];
% 	end
% 	
% 	FDates(yy-syy+1) = lbusdate(yy,12);
% 	if ~isempty(h)
% 		Yerr = iY(iEnd+1:iEnd+Ow,:) - eFY(1:Ow,:);
% 		
% 		Ym2 = Yerr(1:h,:) .^ 2;
% 		Yrmse = sqrt(mean(Ym2,1));
% 		
% 		fprintf('%12s',datestr(EndDate,1));
% 		for i = 1:n
% 			fprintf('  %7.2f',100*Yrmse(i));
% 		end
% 		FError(yy-syy+1,:) = 100*Yrmse';
% 		fprintf('\n');
% 	end
% end
% 
% YModel{Model,6} = FError;
% 
% mFError = NaN(size(FError));
% sFError = NaN(size(FError));
% for i = 1:n
% 	mFError(:,i) = nanmean(FError(:,i));
% 	sFError(:,i) = nanstd(FError(:,i));
% end
% 
% for i = 1:n
% 	subplot(ceil(n/2),2,i,'align');
% 	plot(FDates,FError(:,i));
% 	hold on
% 	plot(FDates,mFError(:,i),'g');
% 	plot(FDates,[mFError(:,i) - sFError(:,i),mFError(:,i) + sFError(:,i)],':r');
% 	moneydemo_recessions(FDates, Recessions);
% 	dateaxis('x',12);
% 	if i == 1
% 		title(['\bfForecast Accuracy for ' sprintf('%g',Horizon/4) '-Year Horizon']);
% 	end
% 	h = legend(YSeries{i},'Location','best');
% 	set(h,'FontSize',7,'Box','off');
% 	hold off
% end


