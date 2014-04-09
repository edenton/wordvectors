clear all;
fid = fopen('../python/wordnet/fruit_words.txt');

words_to_keep = {};
line = fgetl(fid);
while line ~= -1
    line = strrep(line, ' ', '');
    line = strsplit(line, ',');
    words_to_keep = {words_to_keep{:}, line{:}};
    line = fgetl(fid);
end
fclose(fid);



fid_word = fopen('/misc/vlgscratch3/FergusGroup/rahul/vectors/GoogleNewsWords.txt');
fid_vec = fopen('/misc/vlgscratch3/FergusGroup/rahul/vectors/GoogleNewsVec.txt');
iii = [];
words = {};
vectors = [];
i = 1;
word = fgetl(fid_word);
vec = fgetl(fid_vec);
while word ~= -1
	if mod(i, 10000) == 0
		fprintf('------------ %d  (%d) ------------\n', i, sum(iii));
	end

	if (sum(ismember(words_to_keep, word)) || sum(ismember(words_to_keep, word(1:end-1)))) && length(word) > 1
        %fprintf('Found word (%d): %s\n',i, line);
        iii(i) = 1;
		words{end+1} = word;
		vec = strsplit(vec, ' ');
		vectors(end+1, :) = cellfun(@str2num, vec);
    else
        iii(i) = 0;
    end
	i = i + 1;
	word = fgetl(fid_word);
	vec = fgetl(fid_vec);

end
    
fclose(fid);

    
    
