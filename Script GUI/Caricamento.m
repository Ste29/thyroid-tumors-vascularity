classdef Caricamento < handle
    
    properties
        states
        volume_logical_MC
        volume_logical_SMC
        volume_MC
        volume_SMC
        cartellaMC
        cartellaSMC
    end
    
    
    methods
        % Costruttore della classe
        function carica = Caricamento()
            cartella1 = uigetdir();
            c1 = 0;  % flag per capire se cartella 1 è MC o SMC
            if cartella1 == 0
                carica.states = "Seleziona una cartella con file PDUS";
                quit cancel  % Stop esecuzione se nessuna cartella è selezionata
            else
                % verifica che la cartella selezionata sia valida
                endout = regexp(cartella1,filesep,'split');
                controllo = strfind(endout{end}, "PD");
                if ~isempty(controllo)  % Se è una cartella valida
                    number = regexp(endout{end},"_",'split');
                    f = [];
                    for i = 1:length(endout)-1
                        f = fullfile(f,endout{i});
                    end
                    
                    % Metodo automatico per selezionare la cartella
                    % con/senza mezzo di contrasto appartenente allo stesso
                    % paziente della prima cartella selezionata
                    for i = 1:length(number)
                        contrasto = strfind(number{i},"MC");
                        if ~isempty(contrasto)
                            if ~isempty(strfind(number{i},"SMC"))
                                number{i} = "MC";
                                c1 = 1;  % è SMC
                            else
                                number{i} = "SMC";
                            end
                        end
                    end
                    
                    fine = number{1};
                    for i = 2:length(number)
                        fine = sprintf('%s_%s', fine, number{i});
                    end
                    cartella2 = fullfile(f,fine);
                    if c1 == 1
                        carica.cartellaSMC = cartella1;
                        carica.cartellaMC = cartella2;
                    else
                        carica.cartellaSMC = cartella2;
                        carica.cartellaMC = cartella1;
                    end
                    
                else  % se la cartella non è valida
                    carica.states = "Seleziona una cartella con file PDUS";
                end
            end
        end
        
        function creaVol(carica)
            % --------------------------------------
            % Creazione dei volumi
            % --------------------------------------
            paths = {carica.cartellaSMC; carica.cartellaMC};
            volume = cell(2,1);
            for i=1:2
                path = paths{i};
                % Variabile usata per sapere se si sta visualizzando
                % un'immagine per la prima volta, in caso sia così viene
                % inizializzata imgs
                count = 0;
                
                [Data]=dir(path);
                for j = 1:length(Data)
                    [~,~,ext] = fileparts(Data(j).name);
                    % Controllo sull'estensione per evitare i file diversi da
                    % quelli che ci si aspetta in input
                    if ext == ".jpg"
                        nome_img = sprintf('%s\\%s', path, Data(j).name);
                        img = im2double(imread(nome_img));
                        if count == 0
                            volume{i} = zeros(size(img,1), size(img,2));
                            vol{i} = zeros(size(img,1), size(img,2), ...
                                size(img,3));
                        end
                        count = count + 1;
                        vol{i}(:,:,:, count) = img;
                        
                        % Applicazione della routine di filtraggio per
                        % estrarre il colore
                        img=image_filtering(img);
                        colore = zeros(size(img,1), size(img,2));
                        colore(img(:,:,3)>img(:,:,1)+0.1 & ...
                            img(:,:,3)>img(:,:,2)+0.1 | ...
                            img(:,:,2)>img(:,:,1)+0.4) = 1;
                        volume{i}(:,:,count) = colore;
                   
                    end
                end
            end
            carica.volume_logical_SMC = volume{1};
            carica.volume_logical_MC = volume{2};
            carica.volume_SMC = vol{1};
            carica.volume_MC = vol{2};
        end
        
        
    end
end
