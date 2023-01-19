disp('-------------------------------------------------------------------')
% Riconoscimento caratteri

% 1) leggere un insieme di caratteri 
[trains, tests] = loadCaratteri(10); % chiama su inf per caricare tutto

% allena il classificatore
clf = fit(trains, 5);

% Testa i risultati
results = test(tests,clf);

% Plot Risultati
plotRes(results);



% FUNZIONI-----------------------------------------------------------------

function [trains, tests] = loadCaratteri(massimo)
    trains = {[],[],[],[],[],[],[],[],[],[]}; % train
    for i = 0 : 9
        fprintf(['\nCarico i train della cifra',char(string(i))]);
        n = min(length(dir(['train/train',char(string(i))])) - 2, massimo); % per vedere quanti caricarne 
        trains{i+1}(n,28*28) = 0; % inizializzo matrici vuote
        for j = 1 : n
            name = ['train/train',char(string(i)),'/',char(string(j)),'.png']; % path (cartella -> sottocartella -> file)
            img = imread(name); 
            trains{i+1}(j,:) = vettorizza(img); % funzione vettorizza
        end
    end
    tests = {[],[],[],[],[],[],[],[],[],[]}; % test
    for i = 0 : 9
        fprintf(['\nCarico i test della cifra',char(string(i))]);
        n = min(length(dir(['test/test',char(string(i))])) - 2, inf);
        tests{i+1}(n,28*28) = 0;
        for j = 1 : n
            name = ['test/test',char(string(i)),'/',char(string(j)),'.png'];
            img = imread(name);
            tests{i+1}(j,:) = vettorizza(img);
        end
    end
end

function v = vettorizza(M) % da matrice a vettore
    [b, h] = size(M); % dimensione matrice
    v(b*h) = 0; % vettore nullo
    for i = 0 : h - 1 
        for j = 1 : b
            v(i*b + j) = M(i+1,j); % vettore riempito con gli elementi della matrice
        end
    end
    v = uint8(v);
end

function clf = fit(trains, k) % SVD
    clf = {[],[],[],[],[],[],[],[],[],[]};
    for i = 1 : 10
        U = rappresentazione(trains{i},k);
        clf{i} = U'*U;
    end
end

function [U] = rappresentazione(train, k) % SVD
    [U, ~, ~] = svds(double(train)',k);
    U = U';
end

function results = test(tests,clf)
    results = [0,0,0,0,0,0,0,0,0,0];
    for i = 0 : 9
        n = length(tests{i+1}(:,1));
        fprintf(['\nTest cifra ',char(string(i)),'. Devo testare ',char(string(n)),' istanze.']);
        oks = 0;
        for j = 1 : n
            z = tests{i+1}(j,:);
            [I, ~] = predictVect(z, clf);% funzione predictVect
            if i == I; oks = oks + 1; end
        end
        results(i+1) = oks / n;
    end
end

function [i, errMin] = predictVect(v,clf) 
    errors(10) = 0;
    for j = 1 : 10
        errors(j) = errore(v,j-1, clf);
    end
    [errMin,i] = min(errors);
    i = i - 1;
end

function err = errore(z,i,clf)
    mat = clf{i+1};z = double(z');
    diff = z - mat*z;
    err = norm(diff);
end

function plotRes(results)
    figure;
    ax = nexttile;
    h = min(results); dh = h / 20;
    x = [-0.5,-0.5,.5,.5,1.5,1.5,2.5,2.5,3.5,3.5,4.5,4.5,5.5,5.5,6.5,6.5,7.5,7.5,8.5,8.5,9.5];
    resPlot = x;
    for i = 1 : length(resPlot)
        if ~mod(i,2)
            resPlot(i) = results(uint8(i/2));
        else
            resPlot(i) = 0;
        end
    end
    stairs(ax, x, resPlot, 'LineWidth',2);
    for i = 0 : 9
        text(ax,i-.1,.05,string(i));
        text(ax,i-.22,results(i+1)-dh,[char(string(uint8(100*results(i+1)))),'%']);
    end
end