Supplemental Information from the MathWorks webinar "Using MATLAB to Develop Macroeconomic Models"

It is necessary to have MATLAB and the following toolboxes to run this code: Econometrics, Financial, and Statistics.

1. Files in moneydemo.zip folder are
	readme.txt
	moneydemo.m
	moneydemo.pdf
	moneydata.mat
	moneydemo_forecasts.m
	moneydemo_impulse.m
	moneydemo_moneysupply.m
	moneydemo_quarterlydates.m
	moneydemo_recessions.m

2. The moneydata.mat file contains time series for all demos and is necessary if you do not have the Datafeed Toolbox.

3. The moneydemo.pdf file contains the slides that were presented in the MathWorks webinar "Using MATLAB to Develop Macroeconomic Models."

4. The main script is moneydemo.m.
	a. It is in "cell" form. If you open the file in the MATLAB editor, you can step through the script by running each cell or you can publish the entire script as a separate document.
	b. If you have the Datafeed toolbox, you can download additional time series from FRED by appending them to the Series cell array on lines 87-88.
	c. If you want to save data, uncomment or execute the save command on line 178 which will store the data in a file called moneydataupdate.mat.
	d. If you download additional series, you must form a series in "rate" form and in "integrated" form in the cell covering lines 219-279.
	e. In the cell covering lines 356-389, you can set up the specific time series for a VAR model. Basically, you would need to modify Y, iY, YSeries, and YAbbrev to have a conformable collection of time series that you want to use.
	f. The number of AR lags in nAR is hard-coded to be equal to 2 in most of the file. If you want to use a different number of lags, you need to make the changes in each cell from line 494 onward.
	g. In the cell covering lines 476-581, the backtest start year (line 496), end year (line 497), and forecast horizon (line 499) can be modified. The start year must be sometime after 1959 that allows for a suitable historical averaging window (10 years would be 1969, etc.).
	h. To generate forecasts for the time series, the cell covering lines 624-707 has a StartDate (line 639) and an EndDate (line 640) that can be used to specify a date range for estimation between StartDate and EndDate and a forecast from EndDate onward. You can also try different AR lags (line 635). 

5. Additional scripts are
	moneydemo_forecasts.m - Generates forecasts with the demo macro model for 2006, 2007, 2008, and the most recent data in moneydata.mat.
	moneydemo_impulse.m - Generates an impulse response analysis that examines the stability of impulse responses over time. Edit lines 124-129 to modify the backtest. If you want to pick out different backtested impulse responses, you need to find the index of the impulse and response in the matrix of impulses and responses, for example, with n = 8 time series and consumption being series i = 6 and GDP being series r = 1, the index is n*(i - 1)+r = 41.
	moneydemo_moneysupply.m - Examines the impact of including or excluding the money supply from the demo macro model.

6. Helper functions are:
	moneydemo_quarterlydates.m - Sets up a vector of quarterly dates for forecasting into the future.
	moneydemo_recessions.m - When applied to a date plot, adds gray vertical bands that identify recessions according to the dates in Recessions.
