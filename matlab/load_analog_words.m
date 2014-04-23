to_keep = load('generated_mats/analog_word_indices.mat');
to_keep = to_keep.idx;

fname = '/misc/vlgscratch3/FergusGroup/rahul/vectors/GoogleNewsWords.txt';
 
fid = fopen(fname, 'r');

words = {};
line = fgetl(fid);
idx = 1;
counter = 1;
while line ~= -1
  if mod(counter, 50000) == 0
    fprintf(' ------------ %d (%d) -------------\n', counter, idx);
  end
  if any(to_keep == counter)
    words{idx} = line;     	
    idx = idx + 1;
  end
  counter = counter + 1;
  line = fgetl(fid);
end
fclose(fid);

save('generated_mats/analog_word_words.mat', 'words');
