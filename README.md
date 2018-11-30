[![Travis-CI Build
Status](https://travis-ci.org/Johanna-Mestorf-Academy/sdsanalysis.svg?branch=master)](https://travis-ci.org/Johanna-Mestorf-Academy/sdsanalysis)
[![license](https://img.shields.io/badge/license-GPL%202-B50B82.svg)](https://github.com/nevrome/sdsanalysis/blob/master/LICENSE)

# sdsanalysis

sdsanalysis is the backbone of the [sdsbrowser](https://github.com/Johanna-Mestorf-Academy/sdsbrowser) webapp. To learn more about it's role for this webapp please check the [For developers](https://github.com/Johanna-Mestorf-Academy/sdsbrowser#for-developers) section in the README over there. 

<img align="right" style="padding-left:20px; padding-bottom:10px;" src="https://raw.githubusercontent.com/Johanna-Mestorf-Academy/sdsbrowser/master/inst/sds_logo/colour/Logo_SDS_colour_300dpi.png" width = 270>

Beyond that sdsanalysis can be employed to analysis SDS stone artefact data in R. It offers two major functionalities for this purpose:

#### **Download available SDS datasets**

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

