classdef voiManager < handle

    properties (Access = private)
        fullVols  % Volume intero, ci sono sia skel che centerline
        coord_CN
        coord_ON
        
    end
    
    properties (Access = public)
        skel_ON
        skel_CN
        CC_ON
        CC_CN
        cl_ON
        cl_CN
    end
    
    methods
        function obj = voiManager(fullVols, ROI_CN, ROI_ON, z, h_roi)
            % fullVol = intero volume img3D
            % ROI_CN = centrale nel nodulo
            % ROI_ON = esterna nel nodulo
            % z = fetta centrale della roi (fetta in cui è stato fatto
            % apply)
            % h_roi = altezza della roi, verranno prese tot fette in alto e
            % tot in basso (faccio h/2 in basso e h/2 in alto)
            obj.fullVols = fullVols;
            % gestione casi limite per non uscire dal volume
            if z < h_roi + 1
                z = h_roi + 1;
            end

            if z > size(fullVols.skeleton,3) - h_roi
                z = size(fullVols.skeleton,3) - h_roi;
            end
            % Creazione coord roi
            % Position = [xmin, ymin, width, height] dove xmin e ymin sono 
            % il pt alto a sx
            obj.coord_CN = floor([get(ROI_CN,"Position"), z, h_roi]);
            obj.coord_ON = floor([get(ROI_ON,"Position"), z, h_roi]);  
            
            % gestione casi limite roi:
            if obj.coord_CN(1) < 1
                obj.coord_CN(1) = 1;
                
            elseif obj.coord_CN(1) + obj.coord_CN(4) > ...
                    size(fullVols.skeleton, 2)
                differenza = (obj.coord_CN(1) + obj.coord_CN(4)) - ...
                    size(fullVols.skeleton, 2);
                obj.coord_CN(1) = obj.coord_CN(1) - differenza;
            end
            
            if obj.coord_CN(2) < 1
                obj.coord_CN(2) = 1;
            elseif obj.coord_CN(2) + obj.coord_CN(3) > ...
                    size(fullVols.skeleton, 1)
                differenza = (obj.coord_CN(2) + obj.coord_CN(3)) - ...
                    size(fullVols.skeleton, 1);
                obj.coord_CN(2) = obj.coord_CN(2) - differenza;
            end
            
            if obj.coord_ON(1) < 1
                obj.coord_ON(1) = 1;
            elseif obj.coord_ON(1) + obj.coord_ON(4) > ...
                    size(fullVols.skeleton, 2)
                differenza = (obj.coord_ON(1) + obj.coord_ON(4)) - ...
                    size(fullVols.skeleton, 2);
                obj.coord_ON(1) = obj.coord_ON(1) - differenza;
            end
            
            if obj.coord_ON(2) < 1
                obj.coord_ON(2) = 1;
            elseif obj.coord_ON(2) + obj.coord_ON(3) > ...
                    size(fullVols.skeleton, 1)
                differenza = (obj.coord_ON(2) + obj.coord_ON(3)) - ...
                    size(fullVols.skeleton, 1);
                obj.coord_ON(2) = obj.coord_ON(2) - differenza;
            end
        end
        
        function [vol_CN, vol_ON] = voi(obj, volume)
%             display(size(volume))  % restituisce: y, x, z
%             display(obj.coord_CN(2))  % y, in alto
%             display(obj.coord_CN(2)+obj.coord_CN(3))  % y, in basso
%             display(obj.coord_CN(1))  % x, a sx
%             display(obj.coord_CN(1)+obj.coord_CN(4))  % x, a dx
%             display(obj.coord_CN(5)-obj.coord_CN(6))
%             display(obj.coord_CN(5)+obj.coord_CN(6))
            
            vol_CN = volume(...
                obj.coord_CN(2):obj.coord_CN(2)+obj.coord_CN(4), ...
                obj.coord_CN(1):obj.coord_CN(1)+obj.coord_CN(3), ...:, ...
                obj.coord_CN(5)-obj.coord_CN(6):obj.coord_CN(5)+obj.coord_CN(6));
            
            vol_ON = volume(...
                obj.coord_ON(2):obj.coord_ON(2)+obj.coord_ON(4), ...
                obj.coord_ON(1):obj.coord_ON(1)+obj.coord_ON(3), ...:, ...
                obj.coord_ON(5)-obj.coord_ON(6):obj.coord_ON(5)+obj.coord_ON(6));
        end
        
        function computeVoi(obj)
            [obj.skel_CN, obj.skel_ON] = obj.voi(obj.fullVols.skeleton);           
            [obj.cl_CN, obj.cl_ON] = obj.voi(obj.fullVols.centerline);
            obj.CC_CN = bwconncomp(obj.cl_CN);
            obj.CC_ON = bwconncomp(obj.cl_ON);
        end
        
    end
    
end