ChEMBL duplicate test
=====================

This is an attempt to repeat the ChEMBL duplicate test as described in [O'Boyle (2012)](https://jcheminf.biomedcentral.com/articles/10.1186/1758-2946-4-22).

Running
-------

To run the workflow:

1. Ensure Open Babel v2.3.2 (the version used in the publication) is installed and executable using `obabel`.

2. Execute `make distclean` to cleanup precomputed results.

3. Execute `make` (`-j` should help to speed up a bit using parallel processes).

License
-------

[ChEMBL v13](https://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/releases/chembl_13/) (version used in the publication) data is downloaded on-the-fly and is licensed under CC-BY-SA 3.0 Unported.
The Makefile is CC0.
