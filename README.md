[![Travis-CI Build
Status](https://travis-ci.org/Johanna-Mestorf-Academy/sdsanalysis.svg?branch=master)](https://travis-ci.org/Johanna-Mestorf-Academy/sdsanalysis)
[![license](https://img.shields.io/badge/license-GPL%202-B50B82.svg)](https://github.com/nevrome/sdsanalysis/blob/master/LICENSE)

# sdsanalysis

sdsanalysis is the backbone of the [sdsbrowser](https://github.com/Johanna-Mestorf-Academy/sdsbrowser) webapp. To learn more about it's role for this webapp please check the [For developers](https://github.com/Johanna-Mestorf-Academy/sdsbrowser#for-developers) section in the README over there. 

Beyond that sdsanalysis can be employed to analysis SDS stone artefact data in R. It offers two major functionalities for this purpose:

#### **Download available SDS datasets**

<img align="right" style="padding-left:20px; padding-bottom:10px;" src="https://raw.githubusercontent.com/Johanna-Mestorf-Academy/sdsbrowser/master/inst/sds_logo/colour/Logo_SDS_colour_300dpi.png" width = 270>

sdsanalysis offers -- among others -- the following functions to access available SDS data:

- `get_available_datasets()`: Get a list of datasets that can be directly downloaded with sdsanalysis
- `get_type_options(dataset_names)`: Get the types of data that are available for one/multiple datasets (single - *Einzelaufnahme*, multi - *Sammelaufnahme*)
- `get_single_artefact_data(dataset_names)` / `get_multi_artefact_data(dataset_names)`: Download one/multiple datasets as a dataframe/a list of dataframes
- `get_description(dataset_names)`: Download description text of one/multiple datasets
- `get_site(dataset_names)`: Get site names of one/multiple datasets
- `get_coords(dataset_names)`: Get site coordinates of one/multiple datasets
- `get_dating(dataset_names)`: Get period information of one/multiple datasets
- `get_creator(dataset_names)`: Get author of one/multiple datasets

#### **Decoding the alphanumerical coding scheme of SDS**

SDS traditionally provides a set of predefined values for each variable. That's not just convenience: It theoretically also allows for a high degree of comparability between different datasets. This predefined values/categories are encoded with a simple and minimalistic alphanumerical scheme. That's a technological rudiment both from the time when the systems that served SDS as an inspiration were created and when most stone tool analysis was made without a computer in reach. 

The encoding has the big disadvantage that it's not immediately human readable. If you try to understand an SDS dataset you're forced to constantly look up new variables in the [SDS publications](https://github.com/Johanna-Mestorf-Academy/sdsbrowser#references). That makes it very difficult to get a fast overview of an SDS dataset. 

sdsanalysis offers functions to quickly decode the cryptic codes in the SDS tables and replace them with human readable descriptions. This is implemented with hash tables to enable high-speed transformation even for datasets with thousands of artefacts.
