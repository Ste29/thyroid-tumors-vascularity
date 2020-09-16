
% funzione per il pre-filtraggio delle immagini 

function J=image_filtering(I)

% modifica contrasto --> metto a 0 i pizel sotto una certa intensità (0.2) e a 1
% quelli sopra ad un'altra (0.7)
I=imadjust(I,[0.2 0.7],[0 1],1);

% apertura e chiusura con un elemento strutturale a disco
SE = strel('disk',2,4);
I= imdilate(I,SE);
I = imerode(I,SE);

J=I;

end