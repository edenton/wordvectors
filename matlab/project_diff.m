%Load Data
clear all;
load generated_mats/all_google_words.mat
fid = fopen('/misc/vlgscratch3/FergusGroup/rahul/vectors/GoogleNewsVec.bin', 'rb');

N = 3000000;
S = 300;
X = fread(fid, [N S], 'single');

%Get interesting indices
%(for now, randomly subsample some indices)
N_small = 1000;

%the number of principle components we expect to see
k = 3;

%Return the indices in the word vectors corresponding to k sections in the
%question reasoning task. A fifth of the vectors returned contain noise.
%idx returned has size N_small,1

%It randomly samples vectors from up to k different sections in the
%analogical reasoning test

idx_final = getIndicesFromAnalogicalReasoning(k,N_small);
%idx = randi(N,N_small,1);


%Generate all pairs
X_sub = X(idx,:);

%preallocate for speed
X_pairs = zeros(N_small*N_small,S);

t = 1;
for i=1:N_small
    for j=i+1:N_small
        if mod(t,10000)==0
            fprintf('Processed <%d>\n',t);
        end 
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

[U, S, V] = svds(X_pairs_t,3);





