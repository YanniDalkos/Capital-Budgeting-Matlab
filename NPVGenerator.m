
function [NPVMatrix] = NPVGenerator(PlotNPV,swtProjectLife,swtWACC,swtTaxRate,swtCostOfEquip,swtSalvValue,swtMktValue,swtDeprecLife,...
    swtMinP,swtMaxP,swtGridP,swtMinQ,swtMaxQ,swtGridQ,swtPGrowth,swtQGrowth,swtFixOpCost,swtFixOpCostGr,...
    swtVarOpCost,swtVarOpCostGr,swtInvent,swtAR,swtAP)

% **************************  ****************************   ****************************

% build P and Q grid for the loops 
% These column vectors hold the specific values of P and Q that we'll investigate 
PGrid = seqa(swtMinP, (swtMaxP-swtMinP)/(swtGridP-1), swtGridP);
QGrid = seqa(swtMinQ, (swtMaxQ-swtMinQ)/(swtGridQ-1), swtGridQ);

DiscFactors = seqm(1,1+swtWACC,swtProjectLife+1)';  % Creat Matrix of Discounting Factors 


% Now initialize Matricies for CF from Capital Spending, Operations and changes 
% in Working Capital.  

CFOP  = zeros(6,swtProjectLife+1);  % CF from OPerations % 
  
  PQGrowthMatx = seqm(1,((1+swtPGrowth)*(1+swtQGrowth)),swtProjectLife)';  % Creat Matrix of P & Q Growth Factors 
  FixedGrowthMatx = seqm(1,1+swtFixOpCostGr,swtProjectLife)';  % Creat Matrix of Fixed Cost Growth Factors 
  VarGrowthMatx = seqm(1,((1+swtVarOpCostGr)*(1+swtQGrowth)),swtProjectLife)';  % Creat Matrix of Variable Cost Growth Factors 
  
  % row 1 = accting revenue before tax 
  % row 2 = accting value of fixed operating expenses - enter as positive values 
  % row 3 = accting value of total variable operating expenses - positive values 
  % row 4 = depreciation per year - enter as a positive value 
  % row 5 = Rev - Exp - Deprec = +row1 - row2 - row3 - row4 
  % row 6 =  (row 5 * (1 - TaxRate) ) + Deprec = CF from Operations 
  

CFCS = zeros(7,swtProjectLife+1);  % CF from Capital Spending - all values entered 
                                    % as positive values unless noted otherwise 
  % row 1 =   Turn-key purchase cost of Capital Equipment - enter as a negative num. 
  % row 2 =   Depreciation per year of capital Equipment - via straight line to 
  %           to an expected salvage value of swtSalvValue - positive value. 
  % row 3 =   Accumulated Depreciation 
  % row 4 =   Book Value of capital equipment at each point in time. 
  % row 5 =   Expected market selling price of capital equipment when disposed of 
  %           at the end of the project per swtMktValue.  Enter as a positive value 
  % row 6 =   CF from liqidation of capital equipment at end of project.  This line 
  %           includes the tax effect from selling the equipment at a price other   
  %           than the current book value = MV + (TaxRate)*(BV-MV), will be pos %   
  % row 7 =   sum of rows 1 and 6 = CF from Capital Spending - can have pos 
  %           and neg values 


CFWC  = zeros(10,swtProjectLife+1);  % CF from changes in Working Capital 
  % row 1 = inventory levels 
  % row 2 = A/R levels 
  % row 3 = A/P levels 
  % row 4 = Changes in inventory levels 
  % row 5 = Changes in A/R levels 
  % row 6 = Changes in A/P levels 
  % row 7 = CF implication from the change in inventory levels = row 4 * -1 
  % row 8 = CF implication from the change in A/R levels = row 5 * -1 
  % row 9 = CF implication from the change in A/P levels = row 6 
  % row 10 = sum of rows 7,8,9 = CF from changes in Working Capital 

NPVMatx = zeros(swtGridP,swtGridQ) - 9.99;  % will hold NPV for each P-Q combo 

% Done initializing matricies 

% Now YOU write the program using the above framework 



i=1;

 while i<=swtGridP;
    PNow = PGrid (i,1 );
    j=1;
     while j<=swtGridQ;
        QNow = QGrid (j,1 );
              
        % Now to compute CFCS 
        CFCS (1,1 ) = -swtCostOfEquip;
        
        
        if swtDeprecLife >= swtProjectLife;
            CFCS (2,2:swtProjectLife+1 ) = seqm((swtCostOfEquip-swtSalvValue)/swtDeprecLife,1,swtProjectLife)';
            CFCS (3,2:swtProjectLife+1 ) = seqa((CFCS (2,2 )),(swtCostOfEquip-swtSalvValue)/swtDeprecLife,swtProjectLife)';
            CFCS (4,1:swtProjectLife+1 ) = seqa(swtCostOfEquip,-((swtCostOfEquip-swtSalvValue)/swtDeprecLife),swtProjectLife+1)';
        else;
            CFCS (2,2:swtDeprecLife+1 ) = seqm((swtCostOfEquip-swtSalvValue)/swtDeprecLife,1,swtDeprecLife)';
            CFCS (3,2:swtDeprecLife+1 ) = seqa((CFCS (2,2 )),(swtCostOfEquip-swtSalvValue)/swtDeprecLife,swtDeprecLife)';
             CFCS (3,swtDeprecLife+1:swtProjectLife+1 ) = seqm((CFCS (3,swtDeprecLife+1 )),1,swtProjectLife-swtDeprecLife+1)';
            CFCS (4,1:swtDeprecLife+1 ) = seqa(swtCostOfEquip,-((swtCostOfEquip-swtSalvValue)/swtDeprecLife),swtDeprecLife+1)';
             CFCS (4,swtDeprecLife+1:swtProjectLife+1 ) = seqm((CFCS (4,swtDeprecLife+1 )),1,swtProjectLife-swtDeprecLife+1)';
         end;
                
        CFCS (5,swtProjectLife+1 ) = swtMktValue;
        CFCS (6,swtProjectLife+1 ) = swtMktValue + (swtTaxRate)*(CFCS (4,swtProjectLife+1 )-swtMktValue);
        CFCS (7, : ) = CFCS (6, : ) + CFCS (1, : );
        
        % Now to compute CFOP 
        
        CFOP (1,2:swtProjectLife+1 ) = PNow*QNow * PQGrowthMatx (1,: );
        CFOP (2,2:swtProjectLife+1 ) = swtFixOpCost * FixedGrowthMatx (1,: );
        CFOP (3,2:swtProjectLife+1 ) = QNow*swtVarOpCost * VarGrowthMatx (1,: );
        CFOP (4,1:swtProjectLife+1 ) = CFCS (2,1:swtProjectLife+1 );
        CFOP (5,: ) = CFOP (1,: ) - CFOP (2,: ) - CFOP (3,: ) - CFOP (4,: );
        CFOP (6,: ) = CFOP (5,: )*(1-swtTaxRate)+CFOP (4,: );
        
        % Now to compute CFWC 
        
        CFWC (1,1:swtProjectLife ) = swtInvent * CFOP (1,2:swtProjectLife+1 );
        CFWC (2,2:swtProjectLife+1 ) = swtAR * CFOP (1,2:swtProjectLife+1 );
        CFWC (3,2:swtProjectLife+1 ) = swtAP * CFOP (1,2:swtProjectLife+1 );
        CFWC (4,1 ) = CFWC (1,1 );
        CFWC (4,2:swtProjectLife+1 ) = CFWC (1,2:swtProjectLife+1 ) - CFWC (1,1:swtProjectLife );
        CFWC (5,2:swtProjectLife+1 ) = CFWC (2,2:swtProjectLife+1 ) - CFWC (2,1:swtProjectLife );
        CFWC (5,swtProjectLife+1 ) = -1* CFWC (2,swtProjectLife );
        CFWC (6,2:swtProjectLife+1 ) = CFWC (3,2:swtProjectLife+1 ) - CFWC (3,1:swtProjectLife );
        CFWC (6,swtProjectLife+1 ) = -1* CFWC (3,swtProjectLife );
        CFWC (7,: ) = -1* CFWC (4,: );
        CFWC (8,: ) = -1* CFWC (5,: );
        CFWC (9,: ) = 1* CFWC (6,: );
        CFWC (10,: ) = sum(CFWC (7:9,: ))';
        
        OverallCF = (CFCS (7,: ) + CFOP (6,: ) + CFWC (10,: ));
        NPVCFs = OverallCF ./ DiscFactors;
        NPVMatx (i,j ) = sum(NPVCFs);
       
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
 
NPVMatrix = NPVMatx(:,:)    % Print NPV Matx to the Command Prompt 

% Plot the NPV Surface 


if PlotNPV == 1

mesh(PGrid',QGrid,NPVMatx');
xlabel('PGrid');
ylabel('QGrid');
zlabel('NPV');
title('NPV Plot Girth');
else
end



end
