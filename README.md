<!-- SPDX-License-Identifier: Apache-2.0 -->
<!-- Copyright Contributors to the ACES Project. -->

# ACES Input and Color Space Conversion Transforms

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![CLA
assistant](https://cla-assistant.io/readme/badge/ampas/aces-input-and-colorspaces)](https://cla-assistant.io/ampas/aces-input-and-colorspaces)

This repository provides Color Space Conversion Transforms for use with ACES.
Some transforms may require code from the
[`aces-core`](https://github.com/ampas/aces-dev) repository. 

In earlier versions of ACES, Input Transforms used the `IDT` token in filenames
and TransformIDs. In ACES 2, the `CSC` token is used, indicating that a
transform may function either as an Input Transforms or as a general CSC.

## Input Transforms
Input Transforms, i.e. CSCs converting _to_ ACES2065-1, included here are
supplied manufacturers or derived from manufacturer-published documentation.
They are provided for convenience only and may not represent the latest
recommendations from the manufacturer. While efforts are made to maintain
accuracy, users should confirm with the manufacturer that they are using the
most current IDTs for their camera.

## Contributing

ACES depends on community participation. Developers, manufacturers, and end
users are encouraged to contribute code, bug fixes, documentation, and other
technical artifacts.

All contributors must have a signed Contributor License Agreement (CLA) on file
to ensure that the project can freely use your contributions. 

See [CONTRIBUTING.md](./CONTRIBUTING.md) for more details.

## Governance

This repository is a submodule of the ACES project, hosted by the ASWF. Details
about how the project operates can be found in the
[GOVERNANCE.md](https://github.com/ampas/aces/blob/main/GOVERNANCE.md) file in
the top-level ACES repository.

## Reporting Issues

To report a problem with Output Transfoms, please open an
[issue](https://github.com/ampas/aces-input-and-colorspaces/issues).

If the issue is senstive in nature or a security related issue, please do not
report in the issue tracker. Instead refer to [SECURITY.md](SECURITY.md) for
more information about the project security policy.

## License

The ACES Project is licensed under the [Apache 2.0 license](./LICENSE).