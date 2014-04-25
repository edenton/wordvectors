
f = open('questions-words.txt')
f_out = open('questions-words.txt');
for l in f:
	line = l.strip()
	if ":" in line:
		f_out.close()
		f_out = open('questions-'+line.split(":")[1].strip()+'.sec','w')	
	else:
		f_out.write(line+"\n")

f_out.close()
f.close()

