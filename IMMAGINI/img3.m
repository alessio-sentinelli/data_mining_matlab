disp('-------------------------------------------------------------------')
% 1) Leggere i dati

txt = sceglifoto();
X = imread(txt);
image(X); % visualizza matrice come immagine
X; % visualizza matrice come numeri
X_g = rgb2gray(X); % converte l' immagine in scala di grigi
image(X_g);
X_g;

% 2) Compressione immagini con SVD

K = 20

[X_c, S, S_cut] = compressioneSVD(K, X_g);


subplot(1,2,1), imshow(X_g)
subplot(1,2,2), imshow(X_c)

disp('Il fattore di compressione vale')
fattore_compressione(X_g, K)
disp('L errore relativo vale')
errore_relativo(X_g, X_c, S, S_cut)

% FUNZIONI-----------------------------------------------------------------
function [mat_c, S, S_cut] = compressioneSVD(k, img)
    img = double(img)/255; % i pixel dell'immagine vanno normalizzati
    [U,S,V] = pagesvd(img); % SVD
    S_cut = S;
    for i = 1:length(diag(S)) % approssima la matrice S
        if i > k
            S(i,i) = 0; % gli autovalori dopo il k-esimo sono posti a 0
        end 
    end
    for i = 1:length(diag(S_cut)) % serve per l'errore relativo
        if i <= k
            S_cut(i,i) = 0; % gli autovalori fino al k-esimo sono posti a 0
        end        
    end
    mat_c = U*S*V';
end

function txt = sceglifoto() % per scegliere l'immagine su cui operare
    choise = input('Scegli una foto\n  1) gallo\n  2) cavallo\n');
    switch choise
        case 1
            txt = 'gallo_c.jpg';
        case 2
            txt = 'horse.jpg';
    end
end

function c = fattore_compressione(mat1, k) % fattore di compressione
    c = k * (size(mat1,1) + size(mat1,2) + 1) / (size(mat1,1)*size(mat1,2));
end

function err = errore_relativo(mat, mat_app, S, S_cut) 
    choise = input('Scegli un metodo\n  1) frobenius\n  2) valori principali\n'); % scelta del metodo per calcolare l'errore relativo
    switch choise
        case 1 % utilizzando la norma di frobenius sulle matrici
            mat = double(mat)/255;
            m_d = mat-mat_app;
            d = norm(m_d,"fro");
            m = norm(mat,"fro");
            err = d/m;
        case 2 % considerando i valori singolari
            S2 = S.^2;
            S2_cut = S_cut.^2;
            sum1 = sum(diag(S2_cut));
            sum2 = sum(diag(S2));            
            err = (sum1/sum2)^(0.5);
    end    
end
