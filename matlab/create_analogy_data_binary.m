%% Given two vector offsets, are they analogical?

Load training data
clear all;
fid = fopen('/misc/vlgscratch3/FergusGroup/rahul/vectors/GoogleNewsVec.bin', 'rb');
X = fread(fid, [3000000, 300], 'single');
X = X'; % D x N
fclose(fid);

load generated_mats/all_google_words.mat

load generated_mats/analog_question_indices.mat;
Nq = size(analog_question_indices, 1);
data = [];
targets = [];
rp = randperm(size(X, 2));
for n = 1 : Nq
    indices = analog_question_indices(n, :);
    % A - B, C - D
    data(end+1,:) = [X(:, indices(1)) - X(:, indices(2)); X(:, indices(3)) - X(:, indices(4))];
    targets(end+1) = 1;
    
    % B - A, D - C
    data(end+1, :) = [X(:, indices(2)) - X(:, indices(1)); X(:, indices(4)) - X(:, indices(3))];
    targets(end+1) = 2;
    
    % A - D, C - B
    data(end+1, :) = [X(:, indices(1)) - X(:, indices(4)); X(:, indices(3)) - X(:, indices(2))];
    targets(end+1) = 0;
    
    % D - A, B - C
    data(end+1, :) = [X(:, indices(4)) - X(:, indices(1));  X(:, indices(2)) - X(:, indices(3))];
    targets(end+1) = 0;
    
    % Three randomly choosen ones from all vectors
    data(end+1, :) = [X(:, rp(12*n)) - X(:, rp(12*n-1)); X(:, rp(12*n-2)) - X(:, 12*n-3)];
    data(end+1, :) = [X(:, rp(12*n-4)) - X(:, rp(12*n-5)); X(:, rp(12*n-6)) - X(:, 12*n-7)];
    data(end+1, :) = [X(:, rp(12*n-8)) - X(:, rp(12*n-9)); X(:, rp(12*n-10)) - X(:, 12*n-11)];
    targets(end+1) = 0;
    targets(end+1) = 0;
    targets(end+1) = 0;
    
    if (mod(n, 1000) == 0)
        fprintf('%d\n', n);
    end
end



X=data;
Y=targets;

save('analogy-multi-class.mat','X','Y');