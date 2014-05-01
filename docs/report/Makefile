all:
	pdflatex report.tex
	bibtex report
	pdflatex report.tex
	open report.pdf

clean:
	rm *.aux *.brf *.pdf *.log *.bbl *.blg *.dvi *.ps *.out *.fdb_latexmk *.synctex.gz
