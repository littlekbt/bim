[![Build Status](https://travis-ci.org/littlekbt/bim.svg?branch=master)](https://travis-ci.org/littlekbt/bim)

# Bim

Bim is cli command to operate BIG-IP.  

※Support ssl certificate operation and sync operation now.

## Requirement
- Ruby 2.3.0 +

## Installtion

```sh
$ gem install bim
```

local install
```sh
$ git clone https://github.com/littlekbt/bim.git
$ cd bim
$ bundle
$ gem build bim.gemspec
$ gem install --local bim-x.x.x.gem
```

## Setup
all commands needs three environment vriables.

- `BIGIP_HOST`: set bigip host
- `BIGIP_USER_ID`: set bigip admin userid
- `BIGIP_PASSWD`: set bigip admin password

if you want to use `--test` option, set TEST_VS vriable.
- `TEST_VS`: set test virtual server

## Features
There are many features for deployment SSL Certificate from CLI to BIGIP.

#### Metadata
- get active host in the device group  
- get group name that BIGIP_HOST belongs

#### Virtual Server
- get virutal server list and detail configuration

#### Sync
- execute sync action  
- get sync state

#### SSL
- upload key and certificate  
- create ssl client profile  
- replace old ssl client profile to new ssl client profile

## Usage

```sh
$ bim [SUB COMMAND] [ARGS]
```
### Command-line Usage

#### Metadata

```sh
# output active devices in the device group that BIGIP_HOST belongs.
$ bim meta actives

# output device group name.
$ bim meta device_groups
```

#### Virtual Server

```sh
# output virtual server list
$ bim vs list

# output one of the virtual server list
$ bim vs detail Virtual_Server_Name
```

#### Sync

```sh
# sync BIGIP_HOST configuration to GROUP.
$ bim sync GROUP

# output sync state.  
$ bim sync state
```

#### SSL

```sh
# output bundles
$ bim ssl bundles

# output ssl profiles(property: certficate, private key, bundle)
$ bim ssl profiles

# output specified ssl profile
$ bim ssl detail SSL Profile Name

# upload and create_ssl_profile and replace.
$ bim ssl deploy OLD_SSL_PROFILE_NAME NEW_SSL_PROFILE_NAME PRIVATE_KEYFILE CERTIFICATE_FILE CHAIN

# set `--test` option, deploy to only virtual server specified by TEST_VS environment vriable.
$ TEST_VS=test_virtual_server bim deploy example.com.20160606 example.com.20170606 /path/to/example.com.key.20170606 /path/to/example.com.crt.20170606 chain --test

# upload private key and certificate.
$ bim ssl upload CERTIFICATE_PROFILE_NAME PRIVATE_KEYFILE(absolute path) CERTIFICATE_FILE(absolute path)

# upload private key.
$ bim ssl upload_key CERTIFICATE_PROFILE_NAME PRIVATE_KEYFILE(absolute path)

# upload certificate.
$ bim ssl upload_crt CERTIFICATE_PROFILE_NAME CERTIFICATE_FILE(absolute path)

# create ssl profile.
$ bim ssl create_profile SSL_PROFILE_NAME CHAIN

# replace virtual server's ssl profile using OLD_SSL_PROFILE_NAME to NEW_SSL_PROFILE_NAME.
$ bim ssl replace OLD_SSL_PROFILE_NAME NEW_SSL_PROFILE_NAME

# can use `--test` option the same as deploy.
$ TEST_VS=test_virtual_server bim replace OLD_SSL_PROFILE_NAME NEW_SSL_PROFILE_NAME --test
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Author
Littlekbt
