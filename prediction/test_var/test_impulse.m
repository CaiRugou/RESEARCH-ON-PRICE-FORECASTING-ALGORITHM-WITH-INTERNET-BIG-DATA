load moneydata
% Remove dates with NaN values

% ii = any(isnan(Data),2);
% Dates(ii) = [];
% Data(ii,:) = [];
% Dataset(ii,:) = [];
% 
% Data =[127.200000000000,22,NaN,36.3000000000000,237.200000000000,13.3820000000000,33.7000000000000,NaN,54.0090000000000,NaN,NaN,156.300000000000,0.380000000000000,NaN;
%        128.700000000000,22.0800000000000,NaN,36.6000000000000,240.400000000000,13.5860000000000,32.4000000000000,NaN,54.0130000000000,NaN,NaN,160.200000000000,0.380000000000000,NaN;
%        130.100000000000,22.8400000000000,2.2,36.3000000000000,244.500000000000,13.8280000000000,32.7000000000000,2.2,54.1590000000000,2.2,2.2,163.700000000000,0.800000000000000,2.2];
% Dataset = {127.200000000000,22,NaN,36.3000000000000,237.200000000000,13.3820000000000,33.7000000000000,NaN,54.0090000000000,NaN,NaN,156.300000000000,0.380000000000000,NaN;
%            128.700000000000,22.0800000000000,NaN,36.6000000000000,240.400000000000,13.5860000000000,32.4000000000000,NaN,54.0130000000000,NaN,NaN,160.200000000000,0.380000000000000,NaN;
%            130.100000000000,22.8400000000000,2.2,36.3000000000000,244.500000000000,13.8280000000000,32.7000000000000,2.2,54.1590000000000,2.2,2.2,163.700000000000,0.800000000000000,2.2};
% Dates = [711217;711308;711400];
% Series = {'COE','CPIAUCSL','FEDFUNDS','GCE','GDP','GDPDEF','GPDI','GS10','HOANBS','M1SL','M2SL','PCEC','TB3MS','UNRATE'};



%isnan(A)   如矩阵A某个元素为NaN 则返回1   否则返回0
nan_data = isnan(Data);
% disp(nan_data);
% any(A) 某一列  存在非零为1 否则返回0
ii = any(nan_data,2);
% ii = any(isnan(Data),2);
% disp(ii);

%找到某一行是否有值为空  则删除
Dates(ii) = [];
% disp(Dates);
Data(ii,:) = [];
% disp(Data);
Dataset(ii,:) = [];
%  disp(Dataset);
% Log Series

% Series = {'COE','CPIAUCSL','GCE','GDP','GDPDEF','GPDI','HOANBS','M1SL','M2SL','PCEC'};
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

% ii = any(isnan(Data),2);
% Dates(ii) = [];
% Data(ii,:) = [];
% Dataset(ii,:) = [];


% Series = {'FEDFUNDS','GS10','TB3MS'};
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
% The main model for our analysis uses the seven time Series described in Smets
% and Wouters (2007) plus an appended eighth time Series. These time Series are
% listed in the following table with their relationship to raw FRED
% counterparts. The variable Y contains the main time Series for the model and
% the variable iY contains integrated data from Y that will be used in
% forecasting analyses.

%   Model       FRED Series     Transformation from FRED Data to Model Time Series
%   --------    -----------     --------------------------------------------------
%   rGDP        GDP             rGDP = diff(log(GDP))
%   rDEF        GDPDEF          rDEF = diff(log(GDPDEF))
%   rWAGES      COE             rWAGE = diff(log(COE))
%   rHOURS      HOANBS          rWORK = diff(log(WORK))
%   rTB3        TB3MS           rTB3 = 0.01*TB3MS
%   rCONS       PCEC            rCONS = diff(log(PCEC))
%   rINV        GPDI            rINV = diff(log(GPDI))
%   rUNEMP      UNRATE          rUNEMP = 0.01*UNRATE

Y = [rGDP, rDEF, rWAGES, rHOURS, rTB3, rCONS, rINV, rUNEMP];

iY = [GDP, DEF, WAGES, HOURS, TB3, CONS, INV, UNEMP];

YSeries = {'Output (GDP)', 'Prices', 'Total Wages', 'Hours Worked', ...
	'Cash Rate', 'Consumption', 'Private Investment', 'Unemployment'};
YAbbrev = {'GDP', 'DEF', 'WAGES', 'HOURS', 'TB3', 'CONS', 'INV', 'UNEMP'};

YInfo = 'U.S. Macroeconomic Model';
% disp(YSeries);
% disp(Y);

%统计元素个数
n = numel(YSeries);
%disp(n);
fprintf('The date range for available data is %s to %s.\n', ...
	datestr(Dates(1),1),datestr(Dates(end),1));




%% Set Up Backtest for Impulse Responses

nAR = 2;

Presample = nAR;					% presample period 预采样周期
Window = 4*30;						% historical estimation window 历史估计窗口
Offset = 4;							% sliding offset for rolling estimation 滑动偏移估计
Horizon = 16;						% forecast horizon 预测水平线

%查看有多长时间个数的  时间序列
T = numel(Dates);





%% Impulse Response Analysis

NumPeriods = floor((T - Presample - Window)/Offset);  %向下取整floor  求得期数20
%disp(NumPeriods)

StartIndex = T - NumPeriods*Offset - Window; %开始的时间索引
%disp(StartIndex);
EndIndex = StartIndex + Window;%结束时间索引 =T-期数
%disp(EndIndex);
NumPeriods = NumPeriods + 1;		% extra forecast period (out-of-sample) 额外的预测期21

Impulses = YSeries; %冲击参数（8个）
Responses = YSeries;%响应

ImpulseDate = zeros(NumPeriods,1);%产生0列向量（21维度）
%disp(ImpulseDate);
ImpulseHorizon = 1:Horizon;
%disp(ImpulseHorizon); 1    2   3   4   5   6   7.......16
ImpulseResponse = zeros(Horizon, NumPeriods, n^2);%产生n^2=64 个 Horizon=16行NumPeriods=21列的全零向量

%disp(ImpulseResponse);

for t = 1:NumPeriods
	if StartIndex == Presample
		Tp = [ 1, StartIndex - 1];
	else
		Tp = [ StartIndex - Presample, StartIndex - 1 ];
	end
	Te = [ StartIndex, EndIndex ];
    %disp(Te);
	Tf = [ EndIndex + 1, EndIndex + Horizon ];
    %disp(Tf);
	
	ImpulseDate(t) = year(Dates(Te(2))) + month(Dates(Te(2)))/12;
    %disp(ImpulseDate);
	
% 	fprintf('Pre: [%3d, %3d], Est: [%3d, %3d], Post: [%3d, %3d] %s - %s\n', ...
% 		Tp(1),Tp(2),Te(1),Te(2),Tf(1),Tf(2),datestr(Dates(Te(1),1)),datestr(Dates(Te(2),1)));

	Yp = Y(Tp(1):Tp(2),:);
	Ye = Y(Te(1):Te(2),:);

	Spec = vgxset('n', n, 'nAR', nAR, 'Constant', true, 'Series', YSeries);
  
	Spec = vgxvarx(Spec, Ye, [], Yp);
	disp(Spec);
    
	W0 = zeros(Horizon, n);
	W1 = W0;
	W2 = W0;
	W3 = W0;
	W4 = W0;
	W5 = W0;
	W6 = W0;
	W7 = W0;
	W8 = W0;
	
 	QSigma = sqrt(diag(Spec.Q));
	
	W1(1,:) = [ QSigma(1) 0 0 0 0 0 0 0 ];
	W2(1,:) = [ 0 QSigma(2) 0 0 0 0 0 0 ];
	W3(1,:) = [ 0 0 QSigma(3) 0 0 0 0 0 ];
	W4(1,:) = [ 0 0 0 QSigma(4) 0 0 0 0 ];
	W5(1,:) = [ 0 0 0 0 QSigma(5) 0 0 0 ];
	W6(1,:) = [ 0 0 0 0 0 QSigma(6) 0 0 ];
	W7(1,:) = [ 0 0 0 0 0 0 QSigma(7) 0 ];
	W8(1,:) = [ 0 0 0 0 0 0 0 QSigma(8) ];

% 	W1(1,:) = [ 1 0 0 0 0 0 0 0 ];		% sqrt(Spec.Q(i,i));
% 	W2(1,:) = [ 0 1 0 0 0 0 0 0 ];
% 	W3(1,:) = [ 0 0 1 0 0 0 0 0 ];
% 	W4(1,:) = [ 0 0 0 1 0 0 0 0 ];
% 	W5(1,:) = [ 0 0 0 0 1 0 0 0 ];
% 	W6(1,:) = [ 0 0 0 0 0 1 0 0 ];
% 	W7(1,:) = [ 0 0 0 0 0 0 1 0 ];
% 	W8(1,:) = [ 0 0 0 0 0 0 0 1 ];

	Y1 = 100*(vgxproc(Spec, W1, [], Y) - vgxproc(Spec, W0, [], Y));
	Y2 = 100*(vgxproc(Spec, W2, [], Y) - vgxproc(Spec, W0, [], Y));
	Y3 = 100*(vgxproc(Spec, W3, [], Y) - vgxproc(Spec, W0, [], Y));
	Y4 = 100*(vgxproc(Spec, W4, [], Y) - vgxproc(Spec, W0, [], Y));
	Y5 = 100*(vgxproc(Spec, W5, [], Y) - vgxproc(Spec, W0, [], Y));
	Y6 = 100*(vgxproc(Spec, W6, [], Y) - vgxproc(Spec, W0, [], Y));
	Y7 = 100*(vgxproc(Spec, W7, [], Y) - vgxproc(Spec, W0, [], Y));
	Y8 = 100*(vgxproc(Spec, W8, [], Y) - vgxproc(Spec, W0, [], Y));
	
	ii = 0;
	for i = 1:n
		for j = 1:n
			ii = ii + 1;
			if i == 1
				ImpulseResponse(:,t,ii) = Y1(:,j);
			elseif i == 2
				ImpulseResponse(:,t,ii) = Y2(:,j);
			elseif i == 3
				ImpulseResponse(:,t,ii) = Y3(:,j);
			elseif i == 4
				ImpulseResponse(:,t,ii) = Y4(:,j);
			elseif i == 5
				ImpulseResponse(:,t,ii) = Y5(:,j);				
			elseif i == 6
				ImpulseResponse(:,t,ii) = Y6(:,j);
			elseif i == 7
				ImpulseResponse(:,t,ii) = Y7(:,j);
			else
				ImpulseResponse(:,t,ii) = Y8(:,j);
			end
		end
	end

	StartIndex = StartIndex + Offset;
	EndIndex = EndIndex + Offset;
end




ii = 0;
for i = 1:n
	for j = 1:n
		ii = ii + 1;
		subplot(n,n,ii);
		surf(ImpulseResponse(:,:,ii)');
		title([ '\bf ' Impulses{i} ' Shock on ' Responses{j} ]);
	end
end


% clf;
% subplot(1,2,1);
% surf(ImpulseDate,ImpulseHorizon,ImpulseResponse(:,:,9));
% view(80,30);
% title('\bfPrice Shock on GDP');
% 
% subplot(1,2,2);
% surf(ImpulseDate,ImpulseHorizon,ImpulseResponse(:,:,17));
% view(80,30);
% title('\bfWages Shock on GDP');




%% Examine Impact of Consumption and Investment Shocks on Output

clf;
subplot(1,2,1);
surf(ImpulseDate,ImpulseHorizon,ImpulseResponse(:,:,41));
view(80,30);
title('\bfCON Shock on GDP');

subplot(1,2,2);
surf(ImpulseDate,ImpulseHorizon,ImpulseResponse(:,:,49));
view(80,30);
title('\bfINV Shock on GDP');

