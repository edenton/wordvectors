all:
	pdflatex proposal.tex
	bibtex proposal
	pdflatex proposal.tex
	open proposal.pdf

clean:
	rm *.aux *.brf *.pdf *.log *.bbl *.blg *.dvi *.ps *.out
