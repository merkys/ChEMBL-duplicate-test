SHELL = bash

SMI_DIR = smiles/

SMI_SWITCHES = I U

SMI_LISTS 	  = $(SMI_SWITCHES:%=$(SMI_DIR)/chembl_13.%smi)
SMI_LISTS_ERR = $(SMI_LISTS:%=%.err)

SMI_DUPLICATE_LISTS  = $(SMI_SWITCHES:%=%smi-duplicates.tab)
INCHI_DUPLICATE_LIST = InChI-duplicates.tab

.PRECIOUS: $(SMI_LISTS)

all: $(SMI_DUPLICATE_LISTS) $(INCHI_DUPLICATE_LIST)

$(INCHI_DUPLICATE_LIST): inputs/chembl_13_chemreps.txt
	cut -f 1,4 $< | tail -n +2 | sort -k2.2 | uniq -f 1 --all-repeated=separate > $@

$(SMI_DIR)/chembl_13.%smi chembl_13.%smi.err: inputs/chembl_13.sdf
	obabel $< -osmi -O$(SMI_DIR)/chembl_13.$*smi -a $* 2> $(SMI_DIR)/chembl_13.$*smi.err

%-duplicates.tab: $(SMI_DIR)/chembl_13.%
	paste <(grep ^CHEMBL inputs/chembl_13.sdf) $< | sed 's/\t$$//' | sort -k2.2 | uniq -f 1 --all-repeated=separate > $@

inputs/%:
	cd inputs && wget https://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/releases/chembl_13/$*.gz
	cd inputs && gunzip $*.gz
	chmod -w $@

distclean:
	rm -f $(SMI_LISTS) $(SMI_LISTS_ERR) $(SMI_DUPLICATE_LISTS) $(INCHI_DUPLICATE_LIST)
