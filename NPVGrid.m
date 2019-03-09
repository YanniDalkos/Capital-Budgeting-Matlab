%  Financial Engineering HW3b
% Author: Yanni Dalkos


clear all % reset ram 
format bank

ToolBoxPath = 0; % This tells Matlab which drive it will find the functions 
                 % used in this program, 1=a, 3=b, 4=d, etc.

if ToolBoxPath == 1
    path(path,'a:\ToolBox')
  elseif ToolBoxPath == 3
    path(path,'c:\ToolBox')
  elseif ToolBoxPath == 4
    path(path,'d:\ToolBox')
  elseif ToolBoxPath == 5
    path(path,'e:\ToolBox')
  elseif ToolBoxPath == 6
    path(path,'f:\ToolBox')
  elseif ToolBoxPath == 7
    path(path,'g:\ToolBox')
  elseif ToolBoxPath == 8
    path(path,'h:\ToolBox')
  elseif ToolBoxPath == 0
    path(path,'c:\Users\YDalk\Documents\MATLAB\ToolBox')
end;

% *************************** BEGIN CONTROL PANEL **************************** 


% Set location to write NPV Matrix to 
PlotNPV = 1;      %  1 means plot NPV matrix table, anything else means don't
swtWriteTo = 0;   %  3 = c:\bus444\hw1\, 4 = d:\bus444\hw1\ etc  9 = Apple etc 
                  %  1=a, 3=c, 4=d, 5=e, 6=f, 7=g, 8=h, 9=For Mac  
                  %    Make sure C to H drives are available (via =3 to =8 ) 


% Overall Parameters 
swtProjectLife = 5;    % Expected life of project, in years 
swtWACC = 0.1220;      % Weighted average cost of capital for this project 
swtTaxRate = 0.34;     % Marginal tax rate for the project % 

% Capital Spending Parameters 
swtCostOfEquip = 65000;   % cost of factory at t=0, assume paid in cash 
swtSalvValue = 20000;     % Est. of Salvage value for deprec purposes 
                          % at the end of the assumed deprec period 
swtMktValue = 40000;      % Est. of the actual mkt value of factory at 
                          % the end of the projects life 
swtDeprecLife =  7;       % The Depreciation period (in yrs) to use. 
                          % Dictated by the IRS and the type of asset used 

% Operating Parameters  
	swtMinP = 5.00;          % minimum Price per unit in the grid 
 	swtMaxP = 20.00;         % maximum Price per unit in the grid 
      swtGridP = 5;          % number of grid points (nodes) to for prices. 
                             % Must be > 1 
      swtMinQ = 500;         % minimum Q in the grid 
      swtMaxQ = 1500;        % maximum Q in the grid 
      swtGridQ = 8;          % number of grid points (nodes) to use with Q 
                             % Must be > 1 
      swtPGrowth = .0500;      % annualized nominal growth in prices beyond t=1 
      swtQGrowth = -0.0100;    % annualized growth of quantity sold beyond year 1 
                               % Enter above as a decimal, i.e. 0.0100 for +1% growth 

      swtFixOpCost = 2700;     % fixed Op. Costs at t=1 
      swtFixOpCostGr = 0.0300; % annualized growth in fixed Op. costs after year 1 
                               % Enter above as a decimal, i.e. 0.0100 for +1% growth 
                               % A value close to inflation is probably appropriate 
      swtVarOpCost =  3.86;    % variable op. Costs *per unit* at t=1 
      swtVarOpCostGr = 0.0200; % Ann. growth in variable Op. Cost per unit after t=1 
                               % Enter above as a decimal, i.e. 0.0100 for +1% growth 
                               % A value close to inflation is probably appropriate 

% Changes in Working Capital parameters  
      swtInvent = 0.150;  % Required Invent level as a proportion of next years sales 
      swtAR     = 0.160;  % Acct Rec level as a proportion of same year revenue 
      swtAP     = 0.120;  % Acct Pay level as a proportion of same year revenue 
     

% ************************** END OF CONTROL PANEL **************************** 

% build P and Q grid for the loops 
% These column vectors hold the specific values of P and Q that we'll investigate 
PGrid = seqa(swtMinP, (swtMaxP-swtMinP)/(swtGridP-1), swtGridP);
QGrid = seqa(swtMinQ, (swtMaxQ-swtMinQ)/(swtGridQ-1), swtGridQ);

NPVMatx = zeros(swtGridP,swtGridQ) - 9.99;  % will hold NPV for each P-Q combo 

% Done initializing matricies 

i=1;

 while i<=swtGridP
    PNow = PGrid (i,1 );
    j=1;
     while j<=swtGridQ
        QNow = QGrid (j,1 );
              
        NPVNow = HW3NPV (PNow,QNow,swtProjectLife,swtWACC,swtTaxRate,swtCostOfEquip,swtSalvValue,swtMktValue,swtDeprecLife,...
    swtPGrowth,swtQGrowth,swtFixOpCost,swtFixOpCostGr,...
    swtVarOpCost,swtVarOpCostGr,swtInvent,swtAR,swtAP);  
     
        NPVMatx (i,j) = NPVNow
       
       j=j+1;
     end;
   
    i=i+1;
 end;

 
 % If you want to write an ASCII file to disk (i.e. save your results)
% You do the following.  Lets assume the data is in a matrix called
% XXX and you want to make a file called results.asc, do this:

% XXX = randn(3,3);   make up some data to print out as a file.

% save a:\results.out XXX -ascii;
  % the above writes 8 digits per element of XXX in scientific
  % notation.  i.e. 72.304 will be written as 7.2304000e+01
  % I try and identify my output files via assigning an extension of
  % .out to them.
 
FEHW3b = NPVMatx(:,:)    % Print NPV Matx to the Command Prompt 

if swtWriteTo == 1
    save ('a:\bus444\hw3\FEHW3b.out','FEHW3b','-ascii');
elseif swtWriteTo == 3
    save ('c:\bus444\hw3\FEHW3b.out','FEHW3b','-ascii');
elseif swtWriteTo == 4
    save ('d:\bus444\hw3\FEHW3b.out','FEHW3b','-ascii');
elseif swtWriteTo == 5
    save ('e:\bus444\hw3\FEHW3b.out','FEHW3b','-ascii');
elseif swtWriteTo == 6
    save ('f:\bus444\hw3\FEHW3b.out','FEHW3b','-ascii');
elseif swtWriteTo == 7
    save ('g:\bus444\hw3\FEHW3b.out','FEHW3b','-ascii');
elseif swtWriteTo == 8
    save ('h:\bus444\hw3\FEHW3b.out','FEHW3b','-ascii');
elseif swtWriteTo == 9
    save /users/YanniDalkos/bus444/hw3/NPVMatrix.out -ascii;
elseif swtWriteTo == 0
    save ('c:\Users\YDalk\Documents\MATLAB\CapPQ.out','FEHW3b','-ascii');
 end;      
          
if PlotNPV == 1

mesh(PGrid',QGrid,NPVMatx');
xlabel('PGrid');
ylabel('QGrid');
zlabel('NPV');
title('NPV Plot');
else
end;


