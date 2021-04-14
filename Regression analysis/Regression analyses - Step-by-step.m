% define independent and dependent variables
IV = [14, 19, 19; 11, 11, 8; 8, 10, 14; 13, 5, 10; 10, 9, 8; 10, 7, 9]
DV = [18; 9; 8; 8; 5; 12]

% calculate correlations among them and separate correlations within
% independent variables as well as between independent and dependent
% variables
R = corrcoef([IV, DV])
RII = R(1:3, 1:3)
RID = R(1:3, 4)

% determine the standaridized B-weights multiple correlation
BS = inv(RII) * RID
R2 = RID' * BS

% determine the unstandardized regression coefficients
BU = diag(BS * (std(DV) ./ std(IV)))
A = mean(DV) - mean(IV) * BU

% calculate the predicted DVs
DVP = IV * BU + A

% display your results
plot(DV, DVP, "r*"); xlim([0, 20]); ylim([0, 20]); line([0, 20], [0, 20]);
plot(DVP, DV - DVP, "b*"); xlim([0, 20]); ylim([-10, 10]); line([0, 20], [0, 0]);

% create an "artifical" new student and use this for prediction
[12, 14, 15] * BU + A
