# Makefile uses bashisms:
SHELL = bash

SMI_DIR = smiles

SMI_SWITCHES = I U

SMI_LISTS     = $(SMI_SWITCHES:%=$(SMI_DIR)/chembl_13.%smi)
SMI_LISTS_ERR = $(SMI_LISTS:%=%.err)

SMI_DUPLICATE_LISTS  = $(SMI_SWITCHES:%=%smi-duplicates.tab)
INCHI_DUPLICATE_LIST = InChI-duplicates.tab

CHEMBL_REPRESENTATIONS = inputs/chembl_13_chemreps.txt
CHEMBL_SDFS            = inputs/chembl_13.sdf

.PRECIOUS: $(SMI_LISTS)

all: $(SMI_DUPLICATE_LISTS) $(INCHI_DUPLICATE_LIST)

$(INCHI_DUPLICATE_LIST): $(CHEMBL_REPRESENTATIONS)
	cut -f 1,4 $< | tail -n +2 | sort -k2.2 | uniq -f 1 --all-repeated=separate > $@

$(SMI_DIR)/chembl_13.%smi chembl_13.%smi.err: $(CHEMBL_SDFS)
	obabel $< -osmi -O$(SMI_DIR)/chembl_13.$*smi -a $* 2> $(SMI_DIR)/chembl_13.$*smi.err

%-duplicates.tab: $(SMI_DIR)/chembl_13.%
	paste <(grep ^CHEMBL $(CHEMBL_SDFS)) $< | sed 's/\t$$//' | sort -k2.2 | uniq -f 1 --all-repeated=separate > $@

# Target to download input files from ChEMBL:
inputs/%:
	cd inputs && wget https://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/releases/chembl_13/$*.gz
	cd inputs && gunzip $*.gz
	chmod -w $@

# Cleaning up everything:
distclean:
	rm -f $(SMI_LISTS) $(SMI_LISTS_ERR) $(SMI_DUPLICATE_LISTS) $(INCHI_DUPLICATE_LIST)
	rm -f $(CHEMBL_REPRESENTATIONS) $(CHEMBL_SDFS)
