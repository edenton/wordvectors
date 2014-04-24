fname_in = '/misc/vlgscratch3/FergusGroup/rahul/vectors/GoogleNews-vectors-negative300.txt';
fname_out = '/misc/vlgscratch3/FergusGroup/denton/GoogleNews-vectors-negative300-numonly.txt';
 
fid_in = fopen(fname_in, 'r');
fid_out = fopen(fname_out, 'w');

line = fgets(fid_in); % ignore first line
line = fgets(fid_in);
idx = 1;
while line ~= -1
  if mod(idx, 10000) == 0
    fprintf(' ------------ %d -------------\n', idx);
  end
  st = regexp(line, ' ');
  fprintf(fid_out, line(st+1:end));
  idx = idx + 1;
  line = fgets(fid_in);
end
fclose(fid_in);
fclose(fid_out);
