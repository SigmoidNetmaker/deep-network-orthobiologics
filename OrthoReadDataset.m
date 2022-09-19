% OrthoReadDataset.m
% this script reads an Excel file containing 
% Albert's OrthoBiologic dataset; the current 
% dataset has 236 rows and 55 columns, not all 
% populated; the first few columns have some
% probably extraneious stuff; for the rest, 
% the first row is text for column heads and 
% the subsequent rows are numeric

% read all text and numerical data from Excel file
% skip the first few columns of extranious data
% (N is the numerical data array)
% (T is the array of all text)
% (R is the array of all text and numeric data)
% the next statement reads V3
% [N T] = xlsread('Orthobiologics data sheet V3',3,'D1:BC236');
% the next statement reads V4
[N T] = xlsread('Orthobiologics data sheet V4',3,'D1:AY227');

% grab the column names from T
CnameLong   = char(T(1,:));
CnameAbbrev = char(T(2,:));

% find the column sizes
numClong   = size(CnameLong,2);
numCabbrev = size(CnameAbbrev,2);


