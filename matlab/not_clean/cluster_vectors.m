init();
X = importdata('../word2vec/vectors.txt');
words = importdata('../word2vec/vocab.txt');

for i = 1:length(words)
    if length(words{i}) > 2
        iii(i) = 1;
    else
        iii(i) = 0;
    end
end

words = words(iii == 1); words = words(2:end);
X = X(iii == 1, :); X = X(2:end, :);

lambda=0.001;
CMat = SparseCoefRecovery(X',0,'Lasso',lambda);