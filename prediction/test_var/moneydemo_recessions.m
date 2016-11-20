function moneydemo_recessions(Dates, Recessions)
%MONEYDEMO_RECESSIONS - Add recession bands to time series plot.
%
%   moneydemo_recessions(Dates, Recessions);
%
% Inputs:
%   Dates - Date numbers used in time series plot.使用date为时间序列
%   Recessions - NumRecessions x 2 array of date numbers. Each row contains the start and end date
%	   of a recession.  （起始时间，结束时间）
%
% Comments:
%   1) Overlays shaded bands on a time series plot to identify recessions.

% Copyright (C) The MathWorks, Inc.

for r = 1:size(Recessions,1)
	if Recessions(r,2) > min(Dates) && Recessions(r,1) <= max(Dates)
		ph(r) = patch([Recessions(r,1) Recessions(r,1) Recessions(r,2) Recessions(r,2)], ...
			          [get(gca,'YLim') fliplr(get(gca,'YLim'))], [0 0 0 0], 'k');
		set(ph(r),'FaceAlpha',0.1,'EdgeColor','none');
	end
end
