 % Financial Engineering HW6
% Author:  Yanni Dalkos
% Does Capital Budgeting I for different values of P and Q
%   generated from a multivariate normal distribution


clear all;  % reset ram 
format bank;  % set the way numbers are displayed 

% addpath a:\;
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

%*************************** BEGIN CONTROL PANEL *****************************

% Price and Quantity Parameters
   swtPMean = 20;    % Expected Price
   swtQMean = 1500;  % Expected Quantity
   swtPStDev = 2;    % Price Standard Deviation
   swtQStDev = 200;  % Quantity Standard Deviation
   swtPQCorr = -.50; % Correlation between Price and Quantity
   
   swtN = 10000; % number of price/quantity draws to make from the bivariate normal distibution**** originaly 5,000 should eventually set to 10,000
   
% CI and Probability Parameters

swtCI = [.99 .95 .50]'; 
   % enter [] to find no confidence intervals
   % enter any confidence intervals with a space in between
   % there are NO LIMITS on the number of intervals to be found.
   % eg [.99 .95 .50]
      
swtNPVProb = [15000 10000 5000 0 -5000]';
   % enter [] to find no probabilities
   % enter any values with a space in between and the program will compute
   %    probability of achieving a greater NPV
   % there are NO LIMITS on the number of probabilities to be found.
   % eg [-1000 0 1500]   
   
% Overall Parameters 
	swtProjectLife = 5;    % Expected life of project, in years 
	swtWACC = 0.122;      % Weighted average cost of capital for this project 
	swtTaxRate = 0.34;     % Marginal tax rate for the project 

% Capital Spending Parameters 
	swtCostOfEquip = 65000;   % cost of factory at t=0, assume paid in cash 
	swtSalvValue = 20000;     % Est. of Salvage value for deprec purposes 
   	                       % at the end of the assumed deprec period 
	swtMktValue = 40000;      % Est. of the actual mkt value of factory at 
	                          % the end of the projects life
	swtDeprecLife =  7;       % The Depreciation period (in yrs) to use. 
	                          % Dictated by the IRS and the type of asset used

% Operating Parameters  

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


% Program output functions 
   swtPrtNPV = 0; % 1 = print NPV matix to screen, 0 = don't print 
   swtPrtGph = 1; % 1 = print histogram graph to screen, 0 = don't print 
   swtPrtFile= 0; % 1,3 4 5 etc print NPV matrix to file, 0 = don't print 
      % i.e. 4 = print to d:\   5 = print to e:\   6 = print to f:\ etc

%************************** END OF CONTROL PANEL *****************************/

% Create 2x2 VCV matrix
VCV = zeros(2,2); % initialize matrix
VCV (1,1) = swtPStDev^2;
VCV (2,2) = swtQStDev^2;
VCV (1,2) = swtPQCorr*swtPStDev*swtQStDev;
VCV (2,1) = swtPQCorr*swtPStDev*swtQStDev;

mu = [ swtPMean swtQMean ]';


PQNow = mvnormal(mu,VCV,round(swtN*1.1)); % generate 10 percent more PQ combos incase any negative values are generated 

g = 1;
while g <= cols(PQNow)         % in this loop we delete any PQ combos that have a negative value for P or Q
    
    if PQNow(1,g) <=0 || PQNow(2,g)<=0
        PQNow(:,g) = [];
        g=g-1;
    end
    
    g = g+1;
end

if cols(PQNow)>swtN             % Finaly with this if statement we delete any extra PQs above our swtN
    PQNow(:,(swtN+1):cols(PQNow)) = [];
end                             % this leaves us with swtN amount of positive PQ combos


% Now to generate our NPVs for each given PQ combo
NPVsim = zeros(swtN,1) - 9.99;
i=1;
while i<=swtN
    
 NPVNow = HW3NPV (PQNow(1,i),PQNow(2,i),swtProjectLife,swtWACC,swtTaxRate,swtCostOfEquip,swtSalvValue,swtMktValue,swtDeprecLife,...
    swtPGrowth,swtQGrowth,swtFixOpCost,swtFixOpCostGr,...
    swtVarOpCost,swtVarOpCostGr,swtInvent,swtAR,swtAP);

NPVsim (i,1) = NPVNow;
i=i+1;
end

if swtPrtNPV == 1
    PQ_NPV_Matx = [PQNow' NPVsim]
else
    PQ_NPV_Matx = [PQNow' NPVsim];
end

if swtPrtGph == 1
    histogram(NPVsim)
    xlabel('NPV');
    ylabel('Frequency');
    title('NPV Histogram');
end

SampleNPVMean = mean(NPVsim)

SampleStd = std(NPVsim)


% Creating CIs
CIStorage = zeros(rows(swtCI),2)-9.99;
SmltoLrgNPVsim = sort(NPVsim);                        % organize NPVsim from smallest to largest
FindCI = [round(swtN*((1-swtCI)/2)) round(swtN*(1-(1-swtCI)/2))];    % find the rows that would contain CI endpoints in new sorted Matx

f=1;
while f<=rows(swtCI)                       % This first loop takes care of all the lower bounds for reach CI
   CILowNow = FindCI(f,1);
   CILower = SmltoLrgNPVsim(CILowNow,1); 
  
   CIStorage(f,1) = CILower;
f=f+1;
end

j=1;
while j<=rows(swtCI)                       % This swcond loop takes care of all the Upper bounds for each CI
    CIUpNow = FindCI(j,2);
    CIUpper = SmltoLrgNPVsim(CIUpNow,1);
    
    CIStorage(j,2) = CIUpper;
j=j+1;
end

CIs = [ swtCI CIStorage ]


% Now to find the probability of getting an NPV greater than specified
% amounts in swtNPVProb matrix
ProbStorage = zeros(rows(swtNPVProb),1) - 9.99;   % initialize storage matrix for probabilities

p=1;
while p<=rows(swtNPVProb)
    GreaterValues = rows(find(NPVsim >= swtNPVProb(p,1)));  % locates NPV values greater than specified amount and counts them 
    ProbNow = GreaterValues/swtN;                           % Takes that number and puts it over swtN to find P(>swtNPVProb Value)
    
    ProbStorage (p,1) = ProbNow;                  % Stores the probability before moving to the next value in swtNPVProb matx
    
p=p+1;
end
ProbabilityOfBeingGreaterThan = [swtNPVProb ProbStorage]

% Print PQ and NPV matrix to an ascii file
if swtPrtFile == 1
    save ('a:\bus444\hw6\FEHW6.out','PQ_NPV_Matx','-ascii');
elseif swtPrtFile == 3
    save ('c:\bus444\hw6\FEHW6.out','PQ_NPV_Matx','-ascii');
elseif swtPrtFile == 4
    save ('d:\bus444\hw6\FEHW6.out','PQ_NPV_Matx','-ascii');
elseif swtPrtFile == 5
    save ('e:\bus444\hw6\FEHW6.out','PQ_NPV_Matx','-ascii');
elseif swtPrtFile == 6
    save ('f:\bus444\hw6\FEHW6.out','PQ_NPV_Matx','-ascii');
elseif swtPrtFile == 7
    save ('g:\bus444\hw6\FEHW6.out','PQ_NPV_Matx','-ascii');
elseif swtPrtFile == 8
    save ('h:\bus444\hw6\FEHW6.out','PQ_NPV_Matx','-ascii');
elseif swtPrtFile == 9
    save /users/YanniDalkos/bus444/hw6/FEHW6.out -ascii;
elseif swtPrtFile == 0
    save ('c:\Users\YDalk\Documents\MATLAB\CapPQ.out','PQ_NPV_Matx','-ascii');
 end;      
