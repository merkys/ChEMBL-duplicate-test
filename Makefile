InChI-duplicates.tab: chembl_13_chemreps.txt
	cut -f 1,4 $< | tail -n +2 | sort -k2.2 | uniq -f 1 --all-repeated=separate > $@
