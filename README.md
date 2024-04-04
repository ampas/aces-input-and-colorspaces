## ACES Input and Color Space Transforms ##

[![CLA assistant](https://cla-assistant.io/readme/badge/ampas/aces-input-and-colorspaces)](https://cla-assistant.io/ampas/aces-input-and-colorspaces)

This repository contains Color Space Conversion Transforms for use with ACES. 
The transforms found in this repository may have dependancies on code found in the
[`aces-core`](https://github.com/ampas/aces-dev) repository. In previous versions
of ACES, Input Transforms used the `IDT` token in the filename and TransformID.
In ACES 2 Input Tranforms use the `CSC` token to denote they may be used as
either Input Transforms, or as general Color Space Conversion Transforms.


### Important note to users ##
The repository includes two directories: `certified` and `contrib`. 

- The `certified` directory contains transforms provided by, or developed in
conjunction with, manufacturers. Although efforts are made to keep these
transforms up-to-date, users should always contact the manufacturer directly to
ensure they have the latest input transforms for their cameras.

- The `contrib` directory contains community-supplied transforms, provided as-is
and may not be optimal. The ACES team may have done minimal testing on these transforms, 
but please visit Feedback on [ACESCentral.com](https://community.acescentral.com) to 
review or leave feedback on these transforms.

### Note to camera manufacturers ##
If you would like Input Transforms for your cameras included in this repository, or would
like to update Input Transforms currently in the repository, please open a pull request. You
may also send an email to acessupport@oscars.org for assistance with Input Transform 
creation, Input Transform submission, or to include links to Input Transforms hosted on your site.


## License ##
This project is licensed under the terms of the [LICENSE](./LICENSE.md) agreement.

## Contributing ##
Thank you for your interest in contributing to our project. Before any
contributions can be accepted, we require contributors to sign a Contributor
License Agreement (CLA) to ensure that the project can freely use your
contributions. You can find more details and instructions on how to sign the CLA
in the [CONTRIBUTING.md](./CONTRIBUTING.md) file.

## Support ## 
For support, please visit [ACESCentral.com](https://acescentral.com)