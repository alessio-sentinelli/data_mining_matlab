disp('-------------------------------------------------------------------')
% 1) Leggere i dati

% Fisher iris dataset consiste di misure della lunghezza del sepalo, ampiezza del sepalo 
% , lunghezza del petalo, e ampiezza del petalo per 150 esemplari di iris. Ci sono 
% 50 esemplari per ognuna delle tre specie.

iris = load('fisheriris');

% 3) Definire il numero di clusters K
K = 3;

% 4) Iterare l' algoritmo fino a convergenza    
 
centers = centroid(iris.meas, K);
kmeans(K,iris.meas, centers) 

% 5) Ripetere cambiando k
K = 4
centers = centroid(iris.meas, K);
kmeans(K,iris.meas, centers) 


% FUNZIONI-----------------------------------------------------------------
% 2) Definire una funzione distanza
function d = euclidean_dist(x,y)
    d = sqrt(sum((x - y).^2));
end              

function c = centroid(dataset, K)
    c_list = [];
    r = round(size(dataset,1)*rand( 1, K ,'double'));
    c = dataset(r,:);
    c_list = [c_list; [c]];
    c = c_list;
end

function wc = wich_centroid(dist)
    [v a] = min(dist'); % a è l' argmin, quello che ci serve per selezionare il cluster di destinatione dell'elemento
    wc = a;
end

function nc = new_centroid(l, dataset)
    for k = 1:size(l')
        for j = 1:max(l)
            find(l==j)
            mean(dataset(find(l==j)))
        end   
    end
end

function plotData(data, centroids, distances, iter)
    ax = nexttile(); hold(ax); n = length(data(:,1)); K = length(centroids(:,1));
    colors = {'r','g','b','c','m','y','k'};
    for i = 1 : n
        scatter(ax, data(i,1), data(i,2), "MarkerEdgeColor", colors{distances(i)})
    end
    for k = 1 : K
        scatter(ax, centroids(k,1), centroids(k, 2),  "MarkerEdgeColor",'k', "MarkerFaceColor",colors{k})
    end
    title(ax, 'Iterazione '+string(iter))
end

function kmeans(K,dataset, centers) % algoritmo k means
    cardinality(K) =0;
    clusters = []; 
    for i = 1:100 
        centers_old = centers;
        distances = [];
        for j = 1:size(dataset,1) % per tutti gli elementi del dataset
            dist_row = [];
            for k = 1:K % per ogni centroide            
                d = euclidean_dist(centers(k,:),dataset(j,:));     
                dist_row = [dist_row , d];
            end
            [~,cluster] = min(dist_row);
            distances = [distances; cluster];
        end
        centers = centers * 0; cardinality = cardinality * 0;
        for j = 1 : size(dataset,1)
            centers(distances(j),:) = centers(distances(j),:) + dataset(j,:);
            cardinality(distances(j)) = cardinality(distances(j)) + 1;
        end
        for k = 1 : K
            centers(k,:) = centers(k,:) / cardinality(k);
        end
        if sum(centers_old - centers) == 0 % convergenza
            disp('Iterazione: '+string(i));
            plotData(dataset, centers, distances, i)
            break
        end    
    end
end
