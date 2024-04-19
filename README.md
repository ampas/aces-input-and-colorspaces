## ACES Input and Color Space Conversion Transforms ##

[![CLA assistant](https://cla-assistant.io/readme/badge/ampas/aces-input-and-colorspaces)](https://cla-assistant.io/ampas/aces-input-and-colorspaces)

This repository contains Color Space Conversion Transforms for use with ACES. The transforms found in this repository may have dependencies on code found in the [`aces-core`](https://github.com/ampas/aces-dev) repository. In previous versions of ACES, Input Transforms used the `IDT` token in the filename and TransformID. In ACES 2, Input Transforms use the `CSC` token to denote they may be used as either Input Transforms or as general Color Space Conversion Transforms.

### Important note to users ###
The transforms in this repository, except those under the `contrib` directory, have been supplied by, or developed in conjunction with, the manufacturer. They are provided as part of this repository for your convenience only. You should not assume the IDTs provided are the latest developed by the manufacturer. Every effort is made to keep these IDTs up-to-date, but users should *always* contact the manufacturer directly to confirm they have the latest IDTs for their camera.

The `contrib` directory contains community-supplied transforms, provided as-is and may not be optimal. The ACES team may have done minimal testing on these transforms, but please visit [ACESCentral.com](https://community.acescentral.com) to review or leave feedback on these transforms.

### Note to ACES Implementers ###

This repository is structured to support accurate implementation of ACES Input and Color Space Conversion Transforms. Understanding the layout and intended use of these transforms is crucial for effective integration into your systems.

#### Implementation Guidelines ####
- **Primary Transforms**: All transforms located in each of the subdirectories of the root directory, with the exception of the `contrib` directory, are essential and should be implemented in all ACES systems. These subdirectories contain the standardized, validated transforms necessary for maintaining compatibility and functionality across different platforms and devices.
- **Community Contributed Transforms**: The `contrib` directory contains additional, community-supplied transforms. These are considered optional and should be included at your discretion. They may provide useful extensions but vary in their testing and support. It is advisable to evaluate their reliability and suitability for your specific needs before integration.
- **Updates and Maintenance**: Ensure your system includes the most recent updates by regularly incorporating new and revised transforms from the main subdirectories, keeping in line with the latest ACES specifications and industry practices.

Following these guidelines ensures that ACES implementers can build robust, consistent systems capable of high-fidelity color management, while also recognizing the flexibility offered by community contributions.

### Note to camera manufacturers ###
If you would like IDTs for your cameras included in this repository, or would like to update IDTs currently in the repository, please open a pull request. You may also send an email to acessupport@oscars.org for assistance with IDT creation, IDT submission, or to include links to IDTs hosted on your site.

### License ###
This project is licensed under the terms of the [LICENSE](./LICENSE.md) agreement.

### Contributing ###
Thank you for your interest in contributing to our project. Before any contributions can be accepted, we require contributors to sign a Contributor License Agreement (CLA) to ensure that the project can freely use your contributions. You can find more details and instructions on how to sign the CLA in the [CONTRIBUTING.md](./CONTRIBUTING.md) file.

### Support ###
For support, please visit [ACESCentral.com](https://acescentral.com)
