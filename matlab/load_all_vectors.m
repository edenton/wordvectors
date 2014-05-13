fname = '/misc/vlgscratch3/FergusGroup/rahul/vectors/GoogleNewsVec.txt';
fname = '/misc/vlgscratch3/FergusGroup/rahul/vectors/GoogleNewsVec.txt';
fname = '/misc/vlgscratch3/FergusGroup/rahul/vectors/GoogleNewsVec.txt';
 
fid = fopen(fname, 'r');

N = 3000000;
D = 300;
X = zeros(N, D);
line = fgetl(fid); % ignore first line
line = fgetl(fid);
idx = 1;
counter = 1;
while line ~= -1
  if mod(idx, 10000) == 0
    fprintf(' ------------ %d (%d) -------------\n', counter, idx);
    %fid_out = fopen('generated_mats/all_word_vectors.mat', 'wb');
    %fwrite(fid_out, X);
    %fclose(fid_out);
  end
  line = str2double(strsplit(line, ' '));
  X(idx, :) = line;     	
  idx = idx + 1;
  line = fgetl(fid);
end
fclose(fid);

%fid_out = fopen('generated_mats/all_word_vectors.mat', 'wb');
%fid_out = fopen('generated_mats/all_word_vectors.mat', 'wb');
fid_out = fopen('generated_mats/all_word_vectors.mat', 'wb');
fwrite(fid_out, X);
fclose(fid_out);


