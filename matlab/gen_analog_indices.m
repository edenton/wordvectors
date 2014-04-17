out_fname = 'analogy_related_word_indices.txt';
fname = '../word2vec/questions-words.txt';
fid = fopen(fname, 'r');

words = {};
line = fgetl(fid);
while line ~= -1
  line = fgetl(fid);
  line = strsplit(line, ' ');
  for w = 1 : length(line)
    if sum(ismember(words, line(w))) == 0
      words(end+1) = line(w);
    end
  end
  line = fgetl(fid);
end
fclose(fid);

fprintf('%d words found.\n', length(words));

system(sprintf('rm -f %s', out_fname));
for w = 1 : length(words)
  cmd = sprintf('../word2vec/my_distance %s /misc/vlgscratch3/FergusGroup/rahul/vectors/GoogleNews-vectors-negative300.bin %s', words{w}, out_fname);
  [~, ~] = system(cmd);
  if mod(w, 10) == 0
    fprintf('Computed neighbors for %d words.\n', w)
  end
  
end
