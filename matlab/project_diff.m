%Load Data
clear all;
load generated_mats/all_google_words.mat
fid = fopen('/misc/vlgscratch3/FergusGroup/rahul/vectors/GoogleNewsVec.bin', 'rb');

N = 3000000;
vecdim = 300;
X = fread(fid, [N vecdim], 'single');



%Get interesting indices

%the number of principle components we expect to see
k = 3;

%Return the indices in the word vectors corresponding to k sections in the
%question reasoning task. A fifth of the vectors returned contain noise.
%idx returned has size N_small,1

%It randomly samples vectors from up to k different sections in the
%analogical reasoning test

idx_final = getIndicesFromAnalogicalReasoning(k,2000);
%idx = randi(N,N_small,1);


%Generate all pairs
X_sub = X(idx_final,:);

N_small = size(X_sub,1);
%preallocate for speed
X_pairs = zeros(N_small*N_small,vecdim);

t = 1;
for i=1:N_small
    for j=i+1:N_small
        X_pairs(t,:) = X_sub(i,:)-X_sub(j,:);
        t = t +1;
        X_pairs(t,:) = X_sub(j,:)-X_sub(i,:);
        t = t+1;
        %if t>size(X_pairs,1)
        %	fprintf('Error. Out of bounds impending..t = %d',t);
        %end
    end
end
X_pairs = X_pairs(1:t-1,:);
X_pairs = bsxfun(@rdivide,X_pairs,exp(-100)+sqrt(sum(X_pairs.^2,2)) );
kmeans_idx = kmeans(X_pairs,k);

[U, S, V] = svds(X_pairs,3);

proj = U*S;
save('./generated_mats/proj_3d_pairs.mat','proj','kmeans_idx');


