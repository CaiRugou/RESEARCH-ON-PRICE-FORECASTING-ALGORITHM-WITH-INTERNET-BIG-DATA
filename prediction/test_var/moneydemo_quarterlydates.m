function QuarterlyDates = moneydemo_quarterlydates(StartDate, NumQuarters)
%MONEYDEMO_QUARTERLYDATES - Compute quarterly forecast dates.
%
%   QuarterlyDates = moneydemo_quarterlydates(StartDate, NumQuarters)
%
% Inputs:
%   StartDate - Starting date number.
%   NumQuarters - Number of quarterly dates into future to compute.
%
% Outputs:
%   QuarterlyDates - NumQuarters quarterly date numbers, starting with the first quarter after
%		StartDate.
%
% Comments:
%	1) Compute a specified number of quarterly dates after a start date with month-end March, June,
%		September, December quarterly dates.

% Copyright (C) The MathWorks, Inc.

QuarterlyDates = zeros(NumQuarters,1);
qq = month(StartDate)/3;
yy = year(StartDate);
for i = 1:NumQuarters
	qq = qq + 1;
	if qq > 4
		qq = 1;
		yy = yy + 1;
	end
	QuarterlyDates(i) = lbusdate(yy,3*qq);    
end
