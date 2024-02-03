# ClamAV

##  An Open-Source antivirus engine for detecting trojans, viruses, malware & other malicious threats.

[ClamAV](https://www.clamav.net/) is the open source standard for mail gateway scanning software.
 Originally developed by [Cisco Talos](https://github.com/Cisco-Talos/clamav-devel) it has been substantially modified by [Flowing](https://www.flowing.it/). This Helm Chart uses the [MailU](https://github.com/Mailu/Mailu) Docker image.


## Configuration

The configurable parameters of the ClamAV chart and
their descriptions can be seen in `values.yaml`. The [full documentation](https://www.clamav.net/documents/clam-antivirus-0-101-0-user-manual) contains more information about running ClamAV in docker.

> **Tip**: You can use the default [values.yaml](values.yaml)

## Memory Usage

ClamAV uses around 1 GB RAM.


# Virus Definitions

For ClamAV to work properly, both the ClamAV engine and the ClamAV Virus Database (CVD) must be kept up to date.

The virus database is usually updated many times per week.

Freshclam should perform these updates automatically. Instructions for setting up Freshclam can be found in the [ documentation](https://www.clamav.net/documents/clam-antivirus-0-101-0-user-manual) section.
If your network is segmented or the end hosts are unable to reach the Internet, you should investigate setting up a private local mirror. If this is not viable, you may use these direct [ download](https://www.clamav.net/downloads)