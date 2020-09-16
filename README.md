# thyroid-tumors-vascularity

## Table of contents
* [General info](#general-info)

# General info
To start the gui just open [gui](https://github.com/Ste29/thyroid-tumors-vascularity/blob/master/Script%20GUI/GUI_BDS3.mlapp), then select a folder in [data](https://github.com/Ste29/thyroid-tumors-vascularity/tree/master/Data).
The original project consisted of a dataset of 21 patients, with hundred of images per patient. The original volumes are transformed into a set of interconnected single‐voxel skeletons, so as to facilitate capturing blood vessels morphology. The quantitative information of vasculature was computed by automatically extracting seven features from these minimal skeletons.

Using the gui it is possible to select a VOI (volume of interest) and than calculate features on the selected volume. Lastly, starting from the features a simple classifier is used to recognize patients affected by tumors.
