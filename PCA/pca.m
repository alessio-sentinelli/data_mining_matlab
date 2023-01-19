disp('-------------------------------------------------------------------')
txt = scegliDataset();
A = readmatrix(txt); % leggi da file

% 1) standardizza i dati con la funzione zscore 
% il primo passo della PCA è normalizzare i dati a media 0 
Z = zscore(A); % standardizza

% 2) matrice di correlazione, individuare automaticamente valori con correlazione significativa
% il secondo passo della PCA è calcolare la matrice di correlazione
R = corrcoef(Z); % calcola matrice di correlazione e' anche di covarianza perché ho normalizzato
[massimi, minimi] = notevoliDetect(R); % individuare correlazioni significative

% 3) determina le componenti principali (CP) per la matrice di correlazione dei dati, valuta il numero minimo di CP
% il terzo passo della PCA è trovare le coppie autovalore autovettore della matrice di covarianza e ordinarle per autovalori decrescenti 
[V,D] = eig(R); % autovalori e autovettori
[d,ind] = sort(diag(D),"descend"); % in ordine decrescente
Ds = D(ind,ind); 
Vs = V(:,ind); % le colonne di Vs sono le Componenti Prinicipali (ordinate)

% Calcola k
% scegliere il numero di dimensioni da conservare
k = findK(Ds)



% FUNZIONI-----------------------------------------------------------------
function txt = scegliDataset()
    choise = input('Scegli un dataset\n  1) Bodies\n  2) Houses\n');
    switch choise
        case 1
            txt = 'Bodyfat_txt.txt';
        case 2
            txt = 'houses_txt.txt';
    end
end

function [massimi, minimi] = notevoliDetect(R)
    n = length(R); 
    massimi = []; minimi = []; kM = 1; km = 1;
    for i = 1 : n - 1
        for j = i + 1 : n
            if abs(R(i,j)) > 0.85
                massimi(:,kM) = [i;j;R(i,j)];
                kM = kM+1;
            elseif abs(R(i,j)) < 0.15
                minimi(:,km) = [i;j;R(i,j)];
                km = km+1;
            end
        end
    end
end

function k = findK(D)
    n = length(D);
    mode = input(['In che modo vuoi determinare k?\n',...
        '  1) k massimo \n  2) 80% Varianza\n  3) Media Autovalori (Kaiser)\n']);
    tr = trace(D);
    somma = 0; k = 0;
    media = mean(diag(D));
    switch mode
        case 1
            cond = "k < n";
        case 2
            cond = "somma / tr < 0.8";
        case 3
            cond = "D(k+1,k+1) >= media";
    end
    while eval(cond)
        k = k + 1;
        somma = somma + D(k,k);
    end
end
