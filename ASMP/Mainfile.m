clear;
close all; 
clc;

DataSet1 = 'FF25EU';
DataSet2 = 'FF25';
DataSet3 = 'FF32';
DataSet4 = 'FF49';
DataSet5 = 'FF100';
DataSet6 = 'FF100MEOP';
DataSet7 = 'sp500';
DataSet8 = 'FF100MEINV';
DatasetName = DataSet8;
addr = ['D:\Desktop\Code\DataSets\' DatasetName '.mat'];
tic;
load(addr);
t1 = toc;
fprintf('It costs %f seconds to import the data.\n',t1);

fullR = (data-1);
[T,N] = size(fullR);
Param.winsize = 120;
Param.trancost = 0;

%% Parameters for Model and Algorithm

Param.lambda = 6;
Param.rho = 0.066;

Param.betacoe = 0.5;
Param.MaxIter = 10000;
Param.tol = 1E-4;
Param.mm = 0.1;

Param.omega = 1;
Param.a = 1/2.01;
Param.b = 1;
Param.rho1 = 0.01;
Param.rho2 = 0.1;

[Aver_CW, Aver_allw] = Averagestrategy(Param,data);
[Aver_Sharpe,Aver_MaxDD,Aver_alphafact,Aver_Ttestpval] = FOMfunc(Aver_CW,data);

[S1_CW]=RUNS1(data,Param.winsize);
[S1_Sharpe,S1_MaxDD,S1_alphafact,S1_Ttestpval] = FOMfunc(S1_CW,data);

[S2_CW,~,~]=RUNS2(data,Param.winsize);
[S2_Sharpe,S2_MaxDD,S2_alphafact,S2_Ttestpval] = FOMfunc(S2_CW,data);

[S3_CW,~,~]=RUNS3(data,Param.winsize);
[S3_Sharpe,S3_MaxDD,S3_alphafact,S3_Ttestpval] = FOMfunc(S3_CW,data);

[SSPO_CW,~,~,~,~] = SSPO_run(data,Param.winsize);
[SSPO_Sharpe,SSPO_MaxDD,SSPO_alphafact,SSPO_Ttestpval] = FOMfunc(SSPO_CW,data);

[SPOLC_CW,~,~] = SPOLC_run(data,Param.winsize);
[SPOLC_Sharpe,SPOLC_MaxDD,SPOLC_alphafact,SPOLC_Ttestpval] = FOMfunc(SPOLC_CW,data);

[SSMP_CW,~,~] = SSMP_lasso_run(data,Param.winsize);
[SSMP_Sharpe,SSMP_MaxDD,SSMP_alphafact,SSMP_Ttestpval] = FOMfunc(SSMP_CW,data);

[AICTR_CW,~,~] = AICTR_run(data,Param.winsize,Param.trancost);
[AICTR_Sharpe,AICTR_MaxDD,AICTR_alphafact,AICTR_Ttestpval] = FOMfunc(AICTR_CW,data);

MTCVaR_CW = MTCVaR_run(data);
[MTCVaR_Sharpe,MTCVaR_MaxDD,MTCVaR_alphafact,MTCVaR_Ttestpval] = FOMfunc(MTCVaR_CW,data);

[ASMP_CW, ASMP_allw] = ASMP_run(Param,data);
[ASMP_Sharpe,ASMP_MaxDD,ASMP_alphafact,ASMP_Ttestpval] = FOMfunc(ASMP_CW,data);

%% Plot the Cumulative Wealth
lw = 3;
figure;
plot(1:T,Aver_CW,'k','LineWidth',lw);hold on
%plot(1:T,Market_CW,'Color','[0.4 0.4 0.4]','Linewidth',lw);hold on
plot(1:T,SSMP_CW,'Color','[0.8 0.4 0.1]','Linewidth',lw);hold on
plot(1:T,SPOLC_CW,'c','Linewidth',lw);hold on
plot(1:T,SSPO_CW,'m','Linewidth',lw);hold on
plot(1:T,S1_CW,'b','Linewidth',lw);hold on
plot(1:T,S2_CW,'g','Linewidth',lw);hold on
plot(1:T,S3_CW,'y','Linewidth',lw);hold on
plot(1:T,AICTR_CW,'Color','[0.4 0.8 0.1]','Linewidth',lw);hold on
plot(1:T,MTCVaR_CW,'Color','[0.1 0.4 0.8]','Linewidth',lw);hold on
plot(1:T,ASMP_CW,'r','LineWidth',lw);
hold off
xlim([0,T]);
xlabel('Trade Time');ylabel('Cumulative Wealth');
legend('1/N','SSMP','SPOLC','SSPO','S1','S2','S3','AICTR','MT-CVaR','ASMP-AFBA','Location','NorthWest')
title(DatasetName);
set(gca,'FontSize',20)
