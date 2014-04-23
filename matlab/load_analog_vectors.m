to_keep = load('generated_mats/analog_word_indices.mat');
to_keep = to_keep.idx;

fname = '/misc/vlgscratch3/FergusGroup/rahul/vectors/GoogleNewsVec.txt';
 
fid = fopen(fname, 'r');

N = 3000000;
D = 300;
X = zeros(length(to_keep), D);
line = fgetl(fid); % ignore first line
line = fgetl(fid);
idx = 1;
counter = 1;
while line ~= -1
  if mod(counter, 50000) == 0
    fprintf(' ------------ %d (%d) -------------\n', counter, idx);
  end
  if any(to_keep == counter)
    line = str2double(strsplit(line, ' '));
    X(idx, :) = line;     	
    idx = idx + 1;
  end
  counter = counter + 1;
  line = fgetl(fid);
end
fclose(fid);

save('generated_mats/analog_word_vectors.mat', 'X');

