function D = fa_ML (D) 

%% =========== NO ROTATION  =============
D.ML.NA=0;
try
    switch D.ML.DataType
        case 'Data'
            [L,psi,T,stats,score] =...
                factoran(D.X,D.ML.NumberOfFactors,'Xtype',D.ML.DataType,'rotate','none','scores',D.ML.FactorScoreCalcMeth);
            D.ML.score=score;
        case 'cov'
            [L,psi,T,stats] =...
                factoran(D.R,D.ML.NumberOfFactors,'Xtype',D.ML.DataType,'rotate','none','scores',D.ML.FactorScoreCalcMeth);
    end
catch
    msgbox('Check parameters. The number of factors requested may be too large for the number of the observed variables.');
    D.ML.NA=1;
end

if D.ML.NA==0;
    [a,b]=size(D.R);
    LL=L'*L;
    CumPropOfTotVar(1,1)=LL(1,1)/a;
    for i=2:size(L,2)
        CumPropOfTotVar(1,i)=CumPropOfTotVar(1,i-1)+LL(i,i)/a;
    end
     
    % H: communalities
    for i=1:a
        if D.ML.NumberOfFactors==1;
            H(i,1)=(L(i,1)^2);
        elseif D.ML.NumberOfFactors==2;
            H(i,1)=(L(i,1)^2)+(L(i,2)^2);
        elseif D.ML.NumberOfFactors==3;
            H(i,1)=(L(i,1)^2)+(L(i,2)^2)+(L(i,3)^2);
        end
        psi(i,1)=1-H(i,1); % specific variance
    end
    
    psiD=zeros(a,a);
    psiD(1:(a+1):end)=psi;
    
    ResMat=D.R-L*L'-psiD;
    
    D.ML.L=L;
    D.ML.CumPropOfTotVar=CumPropOfTotVar;
    D.ML.H=H;
    D.ML.psi=psi;
    D.ML.psiD=psiD;
    D.ML.ResMat=ResMat;
    D.ML.stats=stats;
end


%% =========== Rotation =================
D.ML.NA_rot=0;
try
    switch D.ML.DataType
        case 'Data'
            [L_rot,psi_rot,T_rot,stats_rot,score_rot] =...
                factoran(D.X,D.ML.NumberOfFactors,'Xtype',D.ML.DataType,'rotate',D.ML.RotationType,'scores',D.ML.FactorScoreCalcMeth);
            D.ML.score_rot=score_rot;
        case 'cov'
            [L_rot,psi_rot,T_rot,stats_rot] =...
                factoran(D.R,D.ML.NumberOfFactors,'Xtype',D.ML.DataType,'rotate',D.ML.RotationType,'scores',D.ML.FactorScoreCalcMeth);
    end
catch
    msgbox('Check parameters. The number of factors requested may be too large for the number of the observed variables.');
    D.ML.NA_rot=1;
end

if D.ML.NA_rot==0;
    [a,b]=size(D.R);
    L_rotL_rot=L_rot'*L_rot;
    CumPropOfTotVar_rot(1,1)=L_rotL_rot(1,1)/a;
    for i=2:size(L_rot,2)
        CumPropOfTotVar_rot(1,i)=CumPropOfTotVar_rot(1,i-1)+L_rotL_rot(i,i)/a;
    end
    
    % H: communalities
    for i=1:a
        if D.ML.NumberOfFactors==1;
            H_rot(i,1)=(L_rot(i,1)^2);
        elseif D.ML.NumberOfFactors==2;
            H_rot(i,1)=(L_rot(i,1)^2)+(L_rot(i,2)^2);
        elseif D.ML.NumberOfFactors==3;
            H_rot(i,1)=(L_rot(i,1)^2)+(L_rot(i,2)^2)+(L_rot(i,3)^2);
        end
        psi_rot(i,1)=1-H_rot(i,1); % specific variance
    end
    
    psiD_rot=zeros(a,a);
    psiD_rot(1:(a+1):end)=psi_rot;
    
    ResMat_rot=D.R-L_rot*L_rot'-psiD_rot;
    
    D.ML.CumPropOfTotVar_rot=CumPropOfTotVar_rot;
    D.ML.L_rot=L_rot;
    D.ML.T_rot=T_rot;
    D.ML.H_rot=H_rot;
    D.ML.psi_rot=psi_rot;
    D.ML.psiD_rot=psiD_rot;
    D.ML.ResMat_rot=ResMat_rot;
    D.ML.stats_rot=stats_rot;
end
D.ML.FLs=D.FLs(1:D.ML.NumberOfFactors);
D.ML.RFLs=D.RFLs(1:D.ML.NumberOfFactors);

%% prepare data for results table
if (D.ML.NA==0)&(D.ML.NA_rot==1)
    D.ML.Headrs=[D.ML.FLs 'Communalities' 'SpecVar'];
    D.ML.Table=[D.ML.L D.ML.H D.ML.psi];
    D.ML.Table(D.Num_Variables+2,1:2*D.ML.NumberOfFactors)=...
        [D.ML.CumPropOfTotVar D.ML.CumPropOfTotVar];
elseif (D.ML.NA==0)&(D.ML.NA_rot==0)
    D.ML.Headrs=[D.ML.FLs D.ML.RFLs 'Communalities' 'SpecVar'];
    D.ML.Table=[D.ML.L D.ML.L_rot D.ML.H D.ML.psi];
    D.ML.Table(D.Num_Variables+2,1:2*D.ML.NumberOfFactors)=...
        [D.ML.CumPropOfTotVar D.ML.CumPropOfTotVar];
else
    D.ML.Headrs=[];
    D.ML.Table=[];
    
end