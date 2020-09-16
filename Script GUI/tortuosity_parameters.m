
% funzione per il calcolo di parametri di tortuosità ed architettura

function [n_alberi,n_ramif,DM,DF,VVD]=tortuosity_parameters(centerline,skeleton)

% -----------------------------------
% parametri tortuosità e architettura
% -----------------------------------

Ccl = bwconncomp(centerline);

% numero di alberi vascolari
n_alberi=Ccl.NumObjects;

% numero di ramificazioni
BRP = bwmorph3(centerline,'branchpoints');
n_ramif=length(find(BRP));

% distance metric
[DM, ~] = dm_computation(Ccl, size(centerline));

% dimensione frattale
sizeV=size(skeleton);
VBF=skeleton;
idx=sizeV>512;
if sum(idx)>0
    M=max(sizeV(idx));
    scale=512/M;
    VBF = imresize3(VBF,scale);
end
[n,r] = boxcount(logical(VBF)); % applica il metodo del box counting
DF=polyfit(log(1./r),log(n),1); % la dimensione frattale è la pendenza (per r che tende a 0) del grafico plot(log(1/r),log(n))
DF=DF(1);

% vascular volume density
VVD=sum(sum(sum(logical(skeleton))))/(sizeV(1)*sizeV(2)*sizeV(3));

end