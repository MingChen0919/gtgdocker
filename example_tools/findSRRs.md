
# The tool: Find-SRRs

The Find-SRRs tool is a perl script which can be found here: https://raw.githubusercontent.com/statonlab/Finding-SSRs/master/findSSRs_altered.pl.

# Launch GTG and Galaxy

Get a copy of `launch_dev_env.sh` to your local computer

```
wget https://raw.githubusercontent.com/MingChen0919/gtgdocker/master/launch_dev_env.sh
```

Run `launch_dev_env.sh`

```
sh launch_dev_env.sh
```

This will start the GTG app, a Galaxy instance, and creates a workspace with three folders within it.

```
gtg_dev_dir
├── database
├── galaxy_tool_repository
└── shed_tools
```

# Create initial XML

We will wrap `findSSRs_altered.pl` as an Aurora Galaxy Tool. 

* Click **Create Tool XML** and Fill the **XML file name** field with `rmarkdown_report.xml`
* Select Aurora Galaxy Tool and click **Save**

![](images/create_tool_xml.png)

# Add components to XML

## Add requirement components

This tool requires three perl modules - Getopt::Long, Bio::SeqIO, and Excel::Writer::XLSX - as well as Primer3. We create a requirement component for each of these four components. We can find the dependencies and their version numbers in [bioconda](https://anaconda.org/bioconda/repo).

* perl-getopt-long (2.50)
* perl-bioperl (1.7.2)
* perl-excel-writer-xlsx (0.98)
* primer3 (2.4.1a)

![](images/add_requirements_components.png)

## Add input components

The `Find SRRs` only has two inputs. We create input component for each.

```
# Usage: findSSRs.pl <arguments>
#
# The list of arguments includes:
#
# -f|--fasta_file <fasta_file>
# Required.  The file of the sequences to be searched.
#
# -m|--masked_file <masked_fasta_file>
# Required.  A soft-masked version of the fasta file (soft masked means low
# complexity sequences are in lower case bases.)
```

### The `fasta_file` input

Add a **tool->inputs->param(type: data)** component because this input takes a file path.

![](images/fasta_file_input.png)

Edit input attributes

![](images/fasta_file_input_attributes.png)


### The `masked_file` input

Add a **tool->inputs->param(type: data)** component because this input takes a file path.

![](images/masked_file_input.png)

Edit input attributes

![](images/masked_file_input_attributes.png)

