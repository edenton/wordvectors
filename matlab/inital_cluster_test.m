clear all;
fid = fopen('../python/wordnet/temp_words.txt');
all_words = importdata('/misc/vlgscratch3/FergusGroup/rahul/vectors/GoogleNewsWords.txt'); %'../word2vec/vocab.txt');

words_to_keep = {};
line = fgetl(fid);
while line ~= -1
    line = strrep(line, ' ', '');
    line = strsplit(line, ',');
    words_to_keep = {words_to_keep{:}, line{:}};
    line = fgetl(fid);
end
fclose(fid);

iii = [];
for i = 1:length(all_words)
    if sum(ismember(words_to_keep, all_words{i}))
        fprintf('Found word : %s', all_words{i});
        iii(i) = 1;
    else
        iii(i) = 0;
    end
end
    


    
    
