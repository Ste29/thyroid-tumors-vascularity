
% funzione per l'estrazione di skeleton e centerline, partendo da un volume
% composto da immagini pre-processate (vedi image_filtering.m)

classdef skelskel < handle
    
    properties
        skeleton
        centerline
    end
    
    methods
        

        function obj=skelskel(volume)

        % --------------------------------------
        % filtro di vesselness e skeletonization
        % --------------------------------------
        skeleton = vesselness3D(logical(volume), 5, [1;1;1], 1, true); % vesselness su volume di partenza
        skeleton = bwskel(logical(skeleton)); % estrazione dello skeleton
        obj.skeleton = vesselness3D(skeleton, 5, [1;1;1], 1, true); % vesselness su volume "skeletonizzato"

        % ------------------
        % "pulizia" skeleton
        % ------------------
        CC = bwconncomp(obj.skeleton);
        numPixels = cellfun(@numel,CC.PixelIdxList);
        idx=find(numPixels<11000);  % tutte le strutture con meno di 11000 pixel connessi vengono eliminate
        for i=1:length(idx)
            obj.skeleton(CC.PixelIdxList{idx(i)})=0;
        end

        % ----------
        % centerline
        % ----------
        obj.centerline=bwskel(logical(obj.skeleton)); % centerline

        end
    end
end