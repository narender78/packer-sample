packer-sample
=============

This is an example setup for building AMIs using [Packer](https://www.packer.io/).

Packer is used to build two EBS-backed AMIs: PV and HVM.

Ubuntu 14.04 was used to test that everything here works.  Nothing is specific to Ubuntu, but package names, file paths, etc may be different if you are not using Ubuntu or Debian.

# Using
1. Install [Packer](https://www.packer.io/) on your machine
1. Customize `ec2-build.sh` to fit your bootstrap requirements. This bootstrap ties into the previous presentation using [Masterless Puppet](https://github.com/shanemeyers/puppet-sample).
1. Set up variables in the top section of `packer.json` to match your environment.
  - AMIs used here were taken from [Ubuntu 14.04 Released AMIs](http://cloud-images.ubuntu.com/releases/14.04/release/)
1. Run packer: `packer build packer.json`
