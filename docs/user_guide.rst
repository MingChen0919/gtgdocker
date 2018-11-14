User's Guide
============


Launching GTG
--------------

Docker
~~~~~~

```
wget https://raw.githubusercontent.com/MingChen0919/gtgdocker/master/launch_dev_env.sh
sh launch_dev_env.sh
```

This script will launch a docker container running the GTG app and another container running
a Galaxy instance. Login to the Galaxy instance with username **admin** and password **admin**
so that you can install tools from tool shed.

After running this script, you should see the following directories in your current directory:

```
gtg_dev_dir/
├── database
├── galaxy_tool_repository
└── shed_tools
```

Drupal Site
~~~~~~~~~~~~

If you want to add the galaxy tool generator to an existing Drupal site....



Build Tool XML
---------------


GTG provides three ways to build a Galaxy XML file:

* Aurora Galaxy Tool: this option starts with an template file for developing an Aurora Galaxy Tool.
* Uploaded XML: starts with an uploaded XML.
* From scratch: builds XML from scratch.


.. image:: /_static/images//create-tool-xml.png


Start from scratch
~~~~~~~~~~~~~~~~~~~~~~~~

For comparison with another software for Galaxy tool development `planemo <https://planemo.readthedocs.io/en/latest/> `_, I am going to use `an example <https://planemo.readthedocs.io/en/latest/writing_standalone.html>`_ from the planemo use cases. In this example we are going to use GTG to build this `seqtk_seq_2.xml <https://raw.githubusercontent.com/MingChen0919/gtgdocker/master/seqtk_seq_2.xml>`_ file.

0. Initialize an XML
^^^^^^^^^^^^^^^^^^^^^^^^


* Click **Create Tool XML**
* Enter `seqtk_seq_2.xml` into **XML file name**
* Select **From scratch** and click **Save**

.. image:: /_static/images/init_seqtk.png


1. Create **tool** component, which is the root component.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

```
<tool id="seqtk_seq" name="Convert to FASTA (seqtk)" version="0.1.0">
```

.. image:: /_static/images/root_component.png

Edit tool component attributes

.. image:: /_static/images/tool_attributes.png


2. Create **tool->requirements** component.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: shell

  <requirements>
          <requirement type="package" version="1.2">seqtk</requirement>
  </requirements>

Add **tool->requirements** component

.. image:: /_static/images/tool_requirements.png

Edit **tool->requirements** component attributes. However, this component does not have any attributes.

.. image:: /_static/images/tool_requirements_attributes.png

Add **tool->requirements->requirement** component

.. image:: /_static/images/tool_requirements_seqtk.png

Edit **tool->requirements->requirement** component attributes.

.. image:: /_static/images/tool_requirements_seqtk_attributes.png

3. Create **tool->command** component
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: shell

    <command detect_errors="exit_code"><![CDATA[
        seqtk seq -a '$input1' > '$output1'
    ]]></command>


Add **tool->command** component

.. image:: /_static/images/tool_command.png

Edit **tool->command** component attributes.

.. image:: /_static/images/tool_command_attributes.png

The **XML value** field in the above web form is used to collect the shell script for the command section. However,
there is an easier way to input shell script into the tool XML file. Go to the **gtg_dev_dir/galaxy_tool_repository** and create
a ``.sh`` file. Put the shell script into this file, the content will be automatically integrated into the web form field when the XML webform page is being viewed (see the image below). The ``.sh`` file should have exact the same base name as the XML file. For example, in this example, the XML file is ``seqtk_seq_2.xml``, then the ``.sh`` file should be ``seqtk_seq_2.xml``.

.. image:: /_static/images/view_update_xml.png


4. Create **tool->inputs** component
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


.. code-block:: shell

      <inputs>
        <param type="data" name="input1" format="fastq" />
    </inputs>

Add **tool->inputs** component

.. image:: /_static/images/tool_inputs.png

Edit **tool->inputs** component attributes

In this example, we don't need to edit any attributes for this component.

.. image:: /_static/images/tool_inputs_attributes.png

Add **tool->inputs->param(type: data)** component

.. image:: /_static/images/tool_inputs_input_param_data.png

Edit **tool->inputs->param(type: data)** component attributes

.. image:: /_static/images/tool_inputs_input_param_data_attributes.png

5. Create **tool->outputs** component
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: shell

    <outputs>
        <data name="output1" format="fasta" />
    </outputs>

Add **tool->outputs** component

.. image:: /_static/images/tool_outputs.png

Edit **tool->outputs** component attributes

In this example, we don't need to edit any attributes for this component.

.. image:: /_static/images/tool_outputs_attributes.png

6. Create **tool->tests** component
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: shell

      <tests>
        <test>
            <param name="input1" value="2.fastq"/>
            <output name="output1" file="2.fasta"/>
        </test>
    </tests>

Add **tool->tests** component

.. image:: /_static/images/tool_tests.png

Edit **tool->tests** component attributes

This component does not have attributes

.. image:: /_static/images/tool_tests_attributes.png

Add **tool->tests->test** component

.. image:: /_static/images/tool_tests_test.png

Edit **tool->tests->test** component attributes

This component does not have attributes

.. image:: /_static/images/tool_tests_test_attributes.png

Add **tool->tests->test->param** component

.. image:: /_static/images/tool_tests_test_param.png

Edit **tool->tests->test->param** component attributes

.. image:: /_static/images/tool_tests_test_param_attributes.png

Add **tool->tests->test-output** component

.. image:: /_static/images/tool_tests_test_output.png

Edit **tool->tests->test-output** component attributes

.. image:: /_static/images/tool_tests_test_output_attributes.png


7. Create **tool->help** component
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: shell

  <help><![CDATA[

  Usage:   seqtk seq [options] <in.fq>|<in.fa>
  Options: -q INT    mask bases with quality lower than INT [0]
           -X INT    mask bases with quality higher than INT [255]
           -n CHAR   masked bases converted to CHAR; 0 for lowercase [0]
           -l INT    number of residues per line; 0 for 2^32-1 [0]
           -Q INT    quality shift: ASCII-INT gives base quality [33]
           -s INT    random seed (effective with -f) [11]
           -f FLOAT  sample FLOAT fraction of sequences [1]
           -M FILE   mask regions in BED or name list FILE [null]
           -L INT    drop sequences with length shorter than INT [0]
           -c        mask complement region (effective with -M)
           -r        reverse complement
           -A        force FASTA output (discard quality)
           -C        drop comments at the header lines
           -N        drop sequences containing ambiguous bases
           -1        output the 2n-1 reads only
           -2        output the 2n reads only
           -V        shift quality by '(-Q) - 33'
           -U        convert all bases to uppercases
           -S        strip of white spaces in sequences
      ]]></help>



Add **tool->help** component

.. image:: /_static/images/tool_help.png

Edit **tool->help** component attributes

.. image:: /_static/images/tool_help_attributes.png


8. Create **tool->citations** component
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: shell

  <citations>
          <citation type="bibtex">
  @misc{githubseqtk,
    author = {LastTODO, FirstTODO},
    year = {TODO},
    title = {seqtk},
    publisher = {GitHub},
    journal = {GitHub repository},
    url = {https://github.com/lh3/seqtk},
  }</citation>
      </citations>


Add **tool->citations** component

.. image:: /_static/images/tool_citations.png

Edit **tool->citations** component attributes

This component does not have attributes

.. image:: /_static/images/tool_citations_attributes.png

Add **tool->citations->citation** component

.. image:: /_static/images/tool_citations_citation.png

Edit **tool->citations->citation** component attributes

.. image:: /_static/images/tool_citations_citation_attributes.png


9. View the complete XML file
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Now you have created all the components for building the `seqtk_seq_2.xml <https://raw.githubusercontent.com/MingChen0919/gtgdocker/master/seqtk_seq_2.xml>`_ file, you can view the XML page to see how it look like on GTG. Of course, you can view the XML page
any time you want. It doesn't have to be after you have added all the components.

.. image:: /_static/images/complete_components.png

Below is the XML page.

.. image:: /_static/images/xml_page_view.png


Build tool repository
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


You have just created the ``seqtk_seq_2.xml`` file in GTG. However, this file is not in the ``gtg_dev_dir/galaxy_tool_repository`` directory yet.
We need to the XML file into it, and any other non-XML files if there is any.

Click the **Build Tool Repository** tab and select any XML files that you want to add to the ``gtg_dev_dir/galaxy_tool_repository`` directory. And then click the `Update XMLs in galaxy_tool_directory folder`. **This is also the button that you use to add an updated XML to the directory**.

.. image:: /_static/images/build_tool_repository.png

You should be able to see the ``seqtk_seq_2.xml`` file in the ``gtg_dev_dir`` directory.

.. image:: /_static/images/gtg_dev_dir.png


### Add non-XML files

If this tool requires any other non-XML files (for example, test files, scripts, etc.), you can add them directory to the `gtg_dev_dir/galaxy_tool_repository` directory.


### Publish tool to Test ToolShed

Once we have the XML file(s) and all other non-XML files in the `gtg_dev_dir/galaxy_tool_repository`, we can publish the tool to Test ToolShed or ToolShed with GTG.

First, we need to add the API key.

.. image:: /_static/images/api_key.png

Then we can publish the tool through the interface below.

.. image:: /_static/images/publish_tool.png

### Install and test Tool in Galaxy

The next step would be to install and test the tool in the connected Galaxy instance. If the tool needs more work, you can use GTG to update the XML file.

The following interface is used to link the tool in GTG with the same tool installed in Galaxy so that the update will be automatically synced to Galaxy for testing.

.. image:: /_static/images/sync_tool.png

Everytime you update XML file in Galaxy, you will need to restart Galaxy to integrate the updates. Below is the command to restart Galaxy.

.. code-block:: shell

  docker exec -it gtg_galaxy sh -c 'supervisorctl restart galaxy:'

You expect to see the following stdout.

.. code-block:: shell

  galaxy:galaxy_nodejs_proxy: stopped
  galaxy:handler0: stopped
  galaxy:handler1: stopped
  galaxy:galaxy_web: stopped
  galaxy:galaxy_nodejs_proxy: started
  galaxy:galaxy_web: started
  galaxy:handler0: started
  galaxy:handler1: started

More examples
--------------

* [findSSRs tool](https://github.com/MingChen0919/gtgdocker/blob/master/example_tools/findSRRs/findSRRs.md): an example for developing [Aurora Galaxy Tools](https://github.com/statonlab/aurora-galaxy-tools).
