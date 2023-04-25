# Integration test environments

## Table of contents

- [Integration test environments](#integration-test-environments)
  - [Table of contents](#table-of-contents)
  - [Overview](#overview)
  - [Dependencies](#dependencies)
  - [Setup](#setup)
  - [Teardown environment](#teardown-environment)


## Overview

The integration test environment simulates a very basic Skywire network locally by docker containers. It contains all Skywire services and three Skywire visors (nodes). You can use all of the basic functionality of Skywire locally and test changes made to the code with it before pushing. 

## Dependencies
Install the following dependencies: 
1. `docker`
2. [`lazydocker`](https://github.com/jesseduffield/lazydocker)

## Setup
### **Clone**
Clone the following repositories into adjacent directories before proceeding  
- [Skywire](https://github.com/skycoin/skywire)  
- [Service Discovery](https://github.com/SkycoinPro/skycoin-service-discovery)   
- [dmsg](https://github.com/skycoin/dmsg)  
- [skywire-utilities](https://github.com/skycoin/skywire-utilities)  

### **Build**
To build all the binaries required for the integration environment, move to `skywire-services` directory and run:
  ```bash
  $ make integration-env-build
  ```
  Starting env do too by build command.
  
  Run `lazydocker` to check all container status/logs and whole of the service functionality.

  Run the hypervisorUI at [localhost:8000](https://localhost:8000) and the Skychat UI at `localhost:8001` and `localhost:8002` to send messages between the visors.

### **Other Command**
  To Stop env run:
  ```
  $ make integration-env-stop
  ```
  To Start env again run:
  ```
  $ make integration-env-start
  ```
  And to Clean env run:
  ```
  $ make integration-env-clean
  ```

### **lazydocker Usage**
On lazydocker, for stop/restart a container, choose it from list, and press `x` on keyboard. Then choose `restart` or `stop` from menu. If you choosed `stop`, for starting container again use `restart`.