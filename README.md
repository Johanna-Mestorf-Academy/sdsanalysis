[![Travis-CI Build
Status](https://travis-ci.org/Johanna-Mestorf-Academy/sdsanalysis.svg?branch=master)](https://travis-ci.org/Johanna-Mestorf-Academy/sdsanalysis)
[![license](https://img.shields.io/badge/license-GPL%202-B50B82.svg)](https://github.com/nevrome/sdsanalysis/blob/master/LICENSE)

# sdsanalysis

sdsanalysis is the backbone of the [sdsbrowser](https://github.com/Johanna-Mestorf-Academy/sdsbrowser) webapp. To learn more about it's role for this webapp please check the [For developers](https://github.com/Johanna-Mestorf-Academy/sdsbrowser#for-developers) section in the README over there. 

Beyond that sdsanalysis can be employed to analysis SDS stone artefact data in R. It offers two major functionalities for this purpose:

#### **Download available SDS datasets** `?sdsdownload`

<img align="right" style="padding-left:20px; padding-bottom:10px;" src="https://raw.githubusercontent.com/Johanna-Mestorf-Academy/sdsbrowser/master/inst/sds_logo/colour/Logo_SDS_colour_300dpi.png" width = 270>

sdsanalysis offers functions to access openly available SDS datasets. It contains a [reference table](https://github.com/Johanna-Mestorf-Academy/sdsanalysis/blob/master/data-raw/dataset_metadata_list.csv) with information about data mostly collected by students and researchers at the Institute of Pre- and Protohistoric Archaeology at Kiel University. That data can be downloaded directly into R with sdsanalysis.

- `get_available_datasets`: Get a list of datasets that can be directly downloaded with sdsanalysis
- `get_type_options`: Get the types of data that are available for one/multiple datasets (single - *Einzelaufnahme*, multi - *Sammelaufnahme*)
- `get_single_artefact_data` / `get_multi_artefact_data`: Download one/multiple datasets as a dataframe/a list of dataframes
- `get_description`: Download description text of one/multiple datasets
- `get_site`: Get site names of one/multiple datasets
- `get_coords`: Get site coordinates of one/multiple datasets
- `get_dating`: Get period information of one/multiple datasets
- `get_creator`: Get author of one/multiple datasets

#### **Decoding the alphanumerical coding scheme of SDS** `?sdsdecoding`

SDS traditionally provides a set of predefined values for each variable. That's not just convenience: It theoretically also allows for a high degree of comparability between different datasets. This predefined values/categories are encoded with a simple and minimalistic alphanumerical scheme. That's a technological rudiment both from the time when the systems that served SDS as an inspiration were created and when most stone tool analysis was made without a computer in reach. 

The encoding has the big disadvantage that it's not immediately human readable. If you try to understand a SDS dataset you're forced to constantly look up new variables in the [SDS publications](https://github.com/Johanna-Mestorf-Academy/sdsbrowser#references). That makes it very difficult to get a fast overview.

sdsanalysis offers functions to quickly decode the cryptic codes in the SDS tables and replace them with human readable descriptions. This is implemented with hash tables to enable high-speed transformation even for datasets with thousands of artefacts. The hash tables are compiled from two reference tables for [variables](https://github.com/Johanna-Mestorf-Academy/sdsanalysis/blob/master/data-raw/variable_list.csv) and [variable values](https://github.com/Johanna-Mestorf-Academy/sdsanalysis/blob/master/data-raw/variable_values_list.csv).

- `lookup_everything`: Wizard function. Enter a [SDS data.frame](https://github.com/Johanna-Mestorf-Academy/sdsbrowser#a-new-dataset) and receive a decoded version. This function employs the ones below and some more helpers to make the decoding process as simple as possible
- `lookup_vars`: 
  **In:** character vector with variable IDs (e.g. *FB1_23, FB2_56*)
  **Out:** character vector with short variable names (*menge_rinde, dorsal_praep*)
- `lookup_var_complete_names`: 
  **In:** character vector with short variable names (*menge_rinde, dorsal_praep*)
  **Out:** character vector with long variable names  
 (e.g. *Art der Dorsalflaechenpraeparation, Menge der Rinde und natuerlichen Sprungflaeche*)
- `lookup_var_types`: 
  **In:** character vector with short variable names (*menge_rinde, dorsal_praep*)
  **Out:** character vector with variable data types (e.g. *character, numeric*)
- `apply_var_types`: 
  **In:** encoded variable vector (SDS data.frame column) + respective variable short name
  **Out:** encoded variable vector with corrected data type
*apply* instead of *lookup*, because in this case the result of an other lookup is 
used to manipulate the input vector.
- `lookup_attrs`: 
  **In:** variable vector (SDS data.frame column) + respective variable short name
  **Out:** decoded variable vector
- `lookup_attr_types`: 
  **In:** encoded variable vector (SDS data.frame column) + respective variable short name
  **Out:** character vector with semantic type (e.g. *normal, unknown*)
- `apply_attr_types`: 
  **In:** encoded variable vector (SDS data.frame column) + respective variable short name
  **Out:** encoded variable vector with the correct values set to NA based on the semantic 
 type
- `lookup_IGerM_category`: 
  **In:** decoded IGerM vector
  **Out:** IGerM category or subcategory vector 
