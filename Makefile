SHELL = bash

.PRECIOUS: smiles/chembl_13.Ismi smiles/chembl_13.Usmi

all: Ismi-duplicates.tab Usmi-duplicates.tab InChI-duplicates.tab

InChI-duplicates.tab: inputs/chembl_13_chemreps.txt
	cut -f 1,4 $< | tail -n +2 | sort -k2.2 | uniq -f 1 --all-repeated=separate > $@

smiles/chembl_13.%smi chembl_13.%smi.err: inputs/chembl_13.sdf
	obabel $< -osmi -Osmiles/chembl_13.$*smi -a $* 2> smiles/chembl_13.$*smi.err

%-duplicates.tab: smiles/chembl_13.%
	paste <(grep ^CHEMBL inputs/chembl_13.sdf) $< | sed 's/\t$$//' | sort -k2.2 | uniq -f 1 --all-repeated=separate > $@

inputs/%:
	cd inputs && wget https://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/releases/chembl_13/$*.gz
	cd inputs && gunzip $*.gz
	chmod -w $@
