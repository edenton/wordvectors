%Load Data : Do once
clear all;
load generated_mats/all_google_words.mat
fid = fopen('/misc/vlgscratch3/FergusGroup/rahul/vectors/GoogleNewsVec.bin', 'rb');

N = 3000000;
vecdim = 300;
X = fread(fid, [N vecdim], 'single');



%Restart from here if needed
clearvars -except X N vecdim words
%the number of principle components we expect to see
load('./generated_mats/analog_question_indices.mat')
loc{1}='./qwSections/questions-capital-common-countries.sec';
loc{2}='./qwSections/questions-capital-world.sec';
loc{3}='./qwSections/questions-city-in-state.sec';
loc{4}='./qwSections/questions-currency.sec';
loc{5}='./qwSections/questions-family.sec';
loc{6}='./qwSections/questions-gram1-adjective-to-adverb.sec';
loc{7}='./qwSections/questions-gram2-opposite.sec';
loc{8}='./qwSections/questions-gram3-comparative.sec';
loc{9}='./qwSections/questions-gram4-superlative.sec';
loc{10}='./qwSections/questions-gram5-present-participle.sec';
loc{11}='./qwSections/questions-gram6-nationality-adjective.sec';
loc{12}='./qwSections/questions-gram7-past-tense.sec';
loc{13}='./qwSections/questions-gram8-plural.sec';
loc{14}='./qwSections/questions-gram9-plural-verbs.sec';
sections = [1];

%Return the indices in the word vectors corresponding to k sections in the
%question reasoning task. A fifth of the vectors returned contain noise.
%idx returned has size N_small,1

%It randomly samples vectors from up to k different sections in the
%analogical reasoning test

idx_final = getIndicesFromAnalogicalReasoning(sections,2000);
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
        idx_values(t,1) = idx_final(i);
        idx_values(t,2) = idx_final(j);
        t = t +1;
        X_pairs(t,:) = X_sub(j,:)-X_sub(i,:);
        idx_values(t,1) = idx_final(j);
        idx_values(t,2) = idx_final(i);
        t = t+1;

        %if t>size(X_pairs,1)
        %	fprintf('Error. Out of bounds impending..t = %d',t);
        %end
    end
end
X_pairs = X_pairs(1:t-1,:);
idx_values = idx_values(1:t-1,:);
X_pairs = bsxfun(@rdivide,X_pairs,exp(-100)+sqrt(sum(X_pairs.^2,2)) );
%kmeans_idx = kmeans(X_pairs,k);

[U, S, V] = svds(X_pairs,3);

proj_all = U*S;

%computing distances as the sum of dot products from eigenvectors
i = 1;
dist_from_evec = zeros(5,1);
for t=1:size(X_pairs,1)
    a = X_pairs(t,:)*V(:,1);
    b = X_pairs(t,:)*V(:,2);
    c = X_pairs(t,:)*V(:,3);
    dist_from_evec(t) = abs(a+b+c);
    %dist_from_evec(t) = abs(a)+abs(b)+abs(c);
end

thr = min(median(dist_from_evec),mean(dist_from_evec));
i = 1;
idx_cluster = zeros(5,3);
for t=1:size(X_pairs,1)
    if dist_from_evec(t)<=0.1
        idx_cluster(i,1)=dist_from_evec(t);
        idx_cluster(i,2)=idx_values(t,1);
        idx_cluster(i,3)=idx_values(t,2);
        proj(i,:) = proj_all(t,:);
        i = i + 1;
    end
end
proj = proj(1:i-1,:);
save('./generated_mats/proj_3d_pairs.mat','proj','idx_cluster');
idx_sample = [1:size(proj,1)]';
for i=1:size(idx_sample,1)
    fprintf('Dist: %.4f W_1 - W_2 : %s - %s\n',idx_cluster(idx_sample(i),1),words{idx_cluster(idx_sample(i),2)},words{idx_cluster(idx_sample(i),3)});
end


%Code to compute which of the three eigenvectors the pairs are closest to
i = 1;
idx_cluster = zeros(5,1);
for t=1:size(X_pairs,1)
    [m,idx] = min([ abs(X_pairs(t,:)*V(:,1)) abs(X_pairs(t,:)*V(:,2)) abs(X_pairs(t,:)*V(:,3))]);
    idx_cluster(i)=abs(m);
    i = i+1;
end

med = median(abs(idx_cluster));
i = 1;
idx_cluster = zeros(5,3);
for t=1:size(X_pairs,1)
	[m,idx] = max([X_pairs(t,:)*V(:,1) X_pairs(t,:)*V(:,2) X_pairs(t,:)*V(:,3)]);
    if abs(m)<=med
        idx_cluster(i,1)=idx;
        idx_cluster(i,2)=idx_values(t,1);
        idx_cluster(i,3)=idx_values(t,2);
        idx_cluster(i,4)=abs(m);
        proj(i,:) = proj_all(t,:);
        i = i + 1;
    end
end
proj = proj(1:i-1,:);

idx_sample = randi(size(idx_cluster,1),10000,1);
idx_sample = find(idx_cluster(:,1)==3);
for i=1:size(idx_sample,1)
    fprintf('Evec: %d Dist: %.4f W_1 - W_2 : %s - %s\n',idx_cluster(idx_sample(i),1),idx_cluster(idx_sample(i),4),words{idx_cluster(idx_sample(i),2)},words{idx_cluster(idx_sample(i),3)});
end

%Consider the following


save('./generated_mats/proj_3d_pairs.mat','proj','idx_cluster','idx_values');


