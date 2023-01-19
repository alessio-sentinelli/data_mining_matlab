disp('-------------------------------------------------------------------')

% 1) leggere un insieme di immagini 

data = importdata('oli.txt');
data = struct2cell(data);
data = data{1,1};

% 2) visualizzazione dataset

figure;
for i = 1:9
    foto = data(i,1:end-1); % foto (senza label)
    size(data(i,end)); %  foto (label)
    subplot(3,3,i);
    image(255*reshape(foto,[64,64])');
    colormap(gray)
end

% 3) preprocessing

t = 10; 
trains = data(mod(1:size(data,1),t)~=1,:);
tests = data(mod(1:size(data,1),t)==1,:);

train = trains(:,1:end-1);
train_class = trains(:,end)';

test = tests(:,1:end-1);
test_class = tests(:,end);

% 4) autofacce

UCell = repmat({[]},1,41);
for i = 1:40 % per ogni persona
    UCell{1} = rep(train(1:9,:),10);
    UCell{i+1} = rep(train(9*i+1:9*i+9,:),10);
end

figure;
for i = 1:6
    eig_face = UCell{i}(:,2);
    subplot(2,3,i);
    image(255*255*reshape(eig_face,[64,64])');
    colormap(gray)
end

figure;
for i = 2:9
    eig_face = UCell{1}(:,i);
    subplot(3,3,i);
    image(255*255*reshape(eig_face,[64,64])');
    colormap(gray)
end

% 5) test

c = fit(UCell);
for k = 1:41
    testing(test(k,:),c);
end 



% FUNZIONI-----------------------------------------------------------------

function U = rep(train, k) 
    [U, ~, ~] = svds(double(train)', k);
end

function clf = fit(Us)
    for i = 1:41
        clf{i} = Us{i} * Us{i}';
    end
end 

function results = testing(test_image,clf)
    results = cell(1,41); 
    z = test_image;
    [I, ~] = predictVect(z, clf);% funzione predictVect
end

function [i, errMin] = predictVect(v,clf)
    errors(41) = 0;
    for j = 1 : 41
        errors(j) = errore(v,j-1, clf); % funzione errore
    end
    figure;
    ax = nexttile();
    xt = [1:41];
    plot(ax, errors);
    xticks(ax, xt);
    [errMin,i] = min(errors);
    i = i - 1;
    fprintf('individuo nr: ')
    disp(i+1)
end

function err = errore(z,i,clf)
    mat = clf{i+1}; z = double(z'); 
    err = norm(z - mat*z);
end