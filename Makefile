InChI-duplicates.tab: chembl_13_chemreps.txt
	cut -f 1,4 $< | tail -n +2 | sort -k2.2 | uniq -f 1 --all-repeated=separate > $@

%-duplicates.tab: chembl_13.%
	sort -k2.2 $< | uniq -f 1 --all-repeated=separate > $@

inputs/%:
	cd inputs && wget https://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/releases/chembl_13/$*.gz
	cd inputs && gunzip $*.gz
	chmod -w $@
