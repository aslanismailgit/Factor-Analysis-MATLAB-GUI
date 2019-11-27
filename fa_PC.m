function D = fa_PC (D) 

[V , De , W ] = eig( D.R );
[d,ind] = sort(diag(De),'descend');
Ds = De(ind,ind);
Vs = V(:,ind);

[a,b]=size(D.R);
%% Loadings
for i=1:a
    for j=1:D.PC.NumberOfFactors
        L(i,j)=((Ds(j,j))^0.5)*Vs(i,j);
    end
end

%% Cumulative proportation of total Standardized samp var
CumPropOfTotVar(1)=diag(Ds(1))/a;
for i=2:size(L,2)
    CumPropOfTotVar(i)=CumPropOfTotVar(i-1)+diag(Ds(i,i))/a;
end

% below is a different way of avobe calculation
% it shows the eigvals are the relative variance of each loading
LL=L'*L;
CumPropOfTotVar(2,1)=LL(1,1)/a;
for i=2:size(L,2)
    CumPropOfTotVar(2,i)=CumPropOfTotVar(2,i-1)+LL(i,i)/a;
end




%% H: communalities

for i=1:a
    if D.PC.NumberOfFactors==1;
        H(i,1)=(L(i,1)^2);
    elseif D.PC.NumberOfFactors==2;
        H(i,1)=(L(i,1)^2)+(L(i,2)^2);
    elseif D.PC.NumberOfFactors==3;
        H(i,1)=(L(i,1)^2)+(L(i,2)^2)+(L(i,3)^2);
    end
    psi(i,1)=1-H(i,1); % specific variance
end

psiD=zeros(a,a);
psiD(1:(a+1):end)=psi;
ResMat=D.R-L*L'-psiD;

D.PC.L=L;
D.PC.CumPropOfTotVar=CumPropOfTotVar(1,:);
D.PC.H=H;
D.PC.psi=psi;
D.PC.psiD=psiD;
D.PC.ResMatPC=ResMat;

if strcmp(D.PC.DataType,'Data')
    switch D.PC.FactorScoreCalcMeth
        case 'wls'
            D.PC.score=(inv(L'*inv(psiD)*L)*L'*inv(psiD)*(D.Z)')'; % WLS
        case 'regression'
            D.PC.score=(L'*inv(D.R)*(D.Z)')'; % regression
    end
end

%% ===============  Rotation ======================
D.PC.NA=0;
try
    [L_rot,T_rot] = ...
        rotatefactors(L,'method',D.PC.RotationType,'maxit',1000);
    for i=1:a
        if D.PC.NumberOfFactors==1;
            H_rot(i,1)=(L_rot(i,1)^2);
        elseif D.PC.NumberOfFactors==2;
            H_rot(i,1)=(L_rot(i,1)^2)+(L_rot(i,2)^2);
        elseif D.PC.NumberOfFactors==3;
            H_rot(i,1)=(L_rot(i,1)^2)+(L_rot(i,2)^2)+(L_rot(i,3)^2);
        end
        psi_rot(i,1)=1-H_rot(i,1); % specific variance
    end
    
    psiD_rot=zeros(a,a);
    psiD_rot(1:(a+1):end)=psi_rot;
    
    ResMat_rot=D.R-L_rot*L_rot'-psiD_rot;
    
    LLrot=L_rot'*L_rot;
    CumPropOfTotVar_rot(1)=LLrot(1,1)/a;
    for i=2:size(L_rot,2)
        CumPropOfTotVar_rot(i)=CumPropOfTotVar_rot(i-1)+LLrot(i,i)/a;
    end
    
    D.PC.L_rot=L_rot;
    D.PC.T_rot=T_rot;
    D.PC.H_rot=H_rot;
    D.PC.psi_rot=psi_rot;
    D.PC.psiD_rot=psiD_rot;
    D.PC.ResMat_rot=ResMat_rot;
    D.PC.CumPropOfTotVar_rot=CumPropOfTotVar_rot;
    
    inv(T_rot'*T_rot); % Correlation matrix of the rotated factors
    
    if strcmp(D.PC.DataType,'Data')
        switch D.PC.FactorScoreCalcMeth
            case 'wls'
                D.PC.score_rot=(inv(L_rot'*inv(psiD_rot)*L_rot)*L_rot'*inv(psiD_rot)*(D.Z)')'; % WLS
            case 'regression'
                D.PC.score_rot=(L_rot'*inv(D.R)*(D.Z)')'; % regression
        end
    end
    
catch
    if D.PC.NumberOfFactors==1
        msgbox('No rotaion for 1 factor or max iteration is reached')
        D.PC.NA=1;
    end
    
end

D.PC.FLs=D.FLs(1:D.PC.NumberOfFactors);
D.PC.RFLs=D.RFLs(1:D.PC.NumberOfFactors);


if (D.PC.NA==1)
    D.PC.Headrs=[D.PC.FLs 'Communalities' 'SpecVar'];
    D.PC.Table=[D.PC.L D.PC.H D.PC.psi];
    D.PC.Table(D.Num_Variables+2,1:D.PC.NumberOfFactors+1)=...
        [D.PC.CumPropOfTotVar D.PC.CumPropOfTotVar];
elseif D.PC.NA==0
    D.PC.Headrs=[D.PC.FLs D.PC.RFLs 'Communalities' 'SpecVar'];
    D.PC.Table=[D.PC.L D.PC.L_rot D.PC.H D.PC.psi];
    D.PC.Table(D.Num_Variables+2,1:2*D.PC.NumberOfFactors)=...
        [D.PC.CumPropOfTotVar D.PC.CumPropOfTotVar];
end