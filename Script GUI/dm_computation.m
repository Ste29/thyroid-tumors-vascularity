
% funzione per calcolare la distance metric su un cluster di vasi

function [dm, counter] = dm_computation(ccl, dimensioni)

dm=0;
counter=0; % contatore per mediare tutto

numPixels = cellfun(@numel,ccl.PixelIdxList);
for kk=1:ccl.NumObjects
    
    % considero una sola struttura per volta
    iso_vessel=zeros(dimensioni);
    iso_vessel(ccl.PixelIdxList{kk})=1; % vaso isolato
    EP = bwmorph3(iso_vessel,'endpoints');
    [xEP,yEP,zEP]=ind2sub(size(EP),find(EP)); % indici 3D degli end-points
    

    
    D1 = zeros(numPixels(kk), length(xEP));
    % per ognuno degli endpoint trovati
    for ii=1:length(xEP) % cicli per misurare tutti i path
        mask1=zeros(size(EP)); % calcolo della path length
        mask1(xEP(ii),yEP(ii),zEP(ii))=1;
        D = bwdistgeodesic(logical(iso_vessel), logical(mask1),...
            'quasi-euclidean');
        D1(:, ii) = D(~isnan(D));
    end
    for n = 1:size(D1, 2)-1
        for jj = n+1:size(D1, 2)
            Dfin = D1(:,n) + D1(:,jj);
            Dfin = round(Dfin * 8) / 8;
            path_length = min(Dfin);
            linear_distance=sqrt((xEP(n)-xEP(jj))^2+(yEP(n)-yEP(jj))^2+...
                (zEP(n)-zEP(jj))^2);
            if counter==0
                % Se è il primo giro inizializzo dm
                dm=(path_length/linear_distance);
                counter=counter+1;
            else
                % Se no moltiplico cosa mi ero calcolato per quante volte
                % mi ero già fatto il conto e sommo la nuova istanza, poi
                % divido per counter + 1 (1 è la nuova istanza)
                dm=((dm*counter)+(path_length/linear_distance))/(counter+1);
                counter=counter+1;
            end
        end
    end
    
    clear D1  % cancello la variabile per poterla reinizializzare
    clear EP
    clear xEP
    clear yEP
    clear zEP
end
end

