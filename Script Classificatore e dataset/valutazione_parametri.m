
% script per l'analisi di risultati, training e validazione del
% classificatore

close all 
clearvars
clc

% carico le tabelle con i parametri di tortuosità
load('dataset_MC.mat');
load('dataset_SMC.mat');

% effettuo il t-test 
% alpha cambia la soglia p per cui accetto l'ipotesi (p<0.05 di default, noi abbiamo settato 0.01)
[hMC,pMC] = ttest2(data_MC(1:11,:),data_MC(12:end,:),'Alpha',0.1); 
[hsMC,psMC] = ttest2(data_SMC(1:11,:),data_SMC(12:end,:),'Alpha',0.1);

% calcolo la media
mean_MC=[mean(data_MC(1:11,:)); mean(data_MC(12:end,:))];
mean_sMC=[mean(data_SMC(1:11,:)); mean(data_SMC(12:end,:))];

% calcolo la varianza
var_MC=[var(data_MC(1:11,:)); var(data_MC(12:end,:))];
var_sMC=[var(data_SMC(1:11,:)); var(data_SMC(12:end,:))];

%% alleno e testo i classificatori senza selezione di parametri
y=[zeros(11,1);ones(10,1)];
y_pred_sMC=zeros(21,1);
y_pred_MC=zeros(21,1);

for i=1:21
    temp_data=data_SMC;
    temp_y=y;
    temp_data(i,:)=[];
    temp_y(i)=[];
    mdl = fitcnb(temp_data,temp_y);
    y_pred_sMC(i)=round(predict(mdl,data_SMC(i,:)));
    
    temp_data=data_MC;
    temp_y=y;
    temp_data(i,:)=[];
    temp_y(i)=[];
    mdl = fitcnb(temp_data,temp_y);
    y_pred_MC(i)=round(predict(mdl,data_MC(i,:)));
end

% confusion matrixes
cm_sMC = confusionmat(y,y_pred_sMC);
cm_MC = confusionmat(y,y_pred_MC);

%% alleno e testo i classificatori con selezione di parametri
y_pred_sMC_sel=zeros(21,1);
y_pred_MC_sel=zeros(21,1);

for i=1:21
    temp_data=data_SMC(:,find(hsMC==1));
    temp_y=y;
    temp_data(i,:)=[];
    temp_y(i)=[];
    mdl = fitcnb(temp_data,temp_y);
    y_pred_sMC_sel(i)=round(predict(mdl,data_SMC(i,find(hsMC==1))));
    
    temp_data=data_MC(:,find(hMC==1));
    temp_y=y;
    temp_data(i,:)=[];
    temp_y(i)=[];
    mdl = fitcnb(temp_data,temp_y);
    y_pred_MC_sel(i)=round(predict(mdl,data_MC(i,find(hMC==1))));
end

% confusion matrixes
cm_sMC_sel = confusionmat(y,y_pred_sMC_sel);
cm_MC_sel = confusionmat(y,y_pred_MC_sel);
