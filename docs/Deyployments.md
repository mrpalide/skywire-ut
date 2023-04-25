## Deployments

We currently run two instances of service deployments - production and test. Both run the full set of services in a k8s cluster defined in [k8s](k8s/) and [k8s-test](k8s-test/). Production is redeployed upon a PR to `master` that passes tests. Testing is redeployed upon a push to `develop`. Testing deployment can be modified for internal testing if necessary while production should not be altered without previous agreement. 

### Skywire Services

1. ```service-discovery``` https://github.com/SkycoinPro/skycoin-service-discovery

- stores info about skywire apps (services) like [vpn](https://sd.skywire.dev/api/services?type=vpn) and [skysocks](https://sd.skywire.dev/api/services?type=skysocks) and also if the visor is a public visor as [visor](https://sd.skywire.dev/api/services?type=visor)
- Any visor can retrive the info of a ```vpn```, ```skysocks``` or ```visor``` to connect to them

2. ```address-resolver``` https://github.com/SkycoinPro/skywire-services/tree/develop/pkg/address-resolver

- stores info of ```stcpr``` and ```sudph``` transport of a visor is the visor has a public IP
- ```stcpr``` is stored or ```bind``` via a normal http api over ```TCP```
- ```sudph``` is ```bind``` via ```UDP```, the ```ar``` listens on a ```UDP``` port and when the visor is ready it ```binds``` by sending a handshake to the ```ar```via ```UDP``` and after the initial handshake the visor keeps on sending a ```hearbeat``` packet every ```10``` seconds to keep the ```UDP``` connection alive
- it is also used to retrive data also called resolve of the stcpr and sudph of a visor in order to connect to it via the respective transports

3. ```network-monitor``` https://github.com/SkycoinPro/skywire-services/tree/develop/pkg/network-monitor

- it runs a ```lite``` version of a ```visor``` along with a ```lite vpn-client``` in order to check and keep track of visors.
- it is used to check if the ```stcpr``` and ```sudph``` entries in the ar are working or not and also the vpn entries in sd

4. ```node-visualizer``` https://github.com/SkycoinPro/skywire-services/tree/develop/pkg/node-visualizer

- it is used to visualise the visors and other data in the skywire network

5. ```transport-discovery``` https://github.com/SkycoinPro/skywire-services/tree/develop/pkg/transport-discovery

- whenever any type of transport is created between visor A and visor B a entry is saved here

6. ```route-finder``` https://github.com/SkycoinPro/skywire-services/tree/develop/pkg/route-finder

- it is used to find a route between two visors
- for example of visor A is connected to visor B via ```sudph``` and visor B is connected to visor C via ```stcpr``` and if visor A want's to connect to visor C then via route finder we can get a route ```A->B->C``` where ```B```is considered a ```hop``` so that connection will have ```one hop```; a route can also have ```0 hops``` if both the visors are directly connected via a transport

7. ```uptime-tracker``` https://github.com/SkycoinPro/skywire-services/tree/develop/pkg/uptime-tracker

- it is used to keep track of the uptimes of the visors; visors send a tcp request to the api every 5 mins to keep its status a online in the ```ut```

8. ```setup-node``` https://github.com/skycoin/skywire/tree/master/cmd/setup-node

- it is used to setup a connection between two ```vpns``` in visors via ```dmsg```

9. ```dmsg-discovery``` https://github.com/skycoin/dmsg

- it is used to keep a track of every dmsg-server and dmsg-client (visor) which includes which ```dmsg-client``` is connected to which ```dmsg-server```
- that means if ```visor A``` is connected to ```dmsg-server A``` and ```visor B``` is connected to ```dmsg-server A``` they can connect to each other easily via the ```dmsg-server A```; but if ```visor B``` is connected to ```dmsg-server B``` instead the ```visor A``` will have to get the info from ```dmsg-discovery``` and connect itself to ```dmsg-server B``` in order to connect to the ```visor B```

10. ```dmsg-server``` https://github.com/skycoin/dmsg

- it is used to connect connect ```dmsg-client A``` with ```dmsg-client B``` if both of them are connected to it acting as a sort of bridge between the two


### Production 

Production currently consists of 

- 6 instances of `dmsg.Server`
- 5 instances of `dmsg-discovery`
- 1 instances of `uptime-tracker`
- 2 instances of `service-discovery`
- one service of all other services

It is deployed to Linodes in a Singapore datacenter and is located behind 2 Linode NodeBalancers and a ```Traefik``` and ```nginx-ingress``` controller. 

The URLs of production can be found [here](https://github.com/skycoin/skywire/blob/master/pkg/skyenv/values.go#L9).

The dmsg services in production are defined [here](https://github.com/SkycoinPro/devops).

### Testing

Testing currently consists of one instance of all services. It does not use a loadbalancer. 

The URLs of testing can be found [here](https://github.com/skycoin/skywire/blob/master/pkg/skyenv/values.go#L20).

In order to access the testing deployment, you need to request a new kube config and switch configs before running `kubectl`. 


### Extra Services

Apart from Skywire Services, We have other supporting services deployed in our environements.

- Skycoin own dns server ( ```ns1.skycoin.com. 172.105.122.51``` , deployed in one of our linode server)

- Skycoin IP service (https://ip.skycoin.com , Deployed in production k8s cluster under ```geoip``` namespace)

- Utilities (Telegram bots for various puprposes, deployed in ```utilities``` namespace of production k8s )

- Whitelist and Auth Services (Running in production k8s under whitelist namespace )

- Coturn Server (Running in production k8s under coturn namespace)
  
  - 45.118.133.242:3478/3479
  - 192.53.173.68:3478/3479
  - 192.46.228.39:3478/3479
  - 192.53.113.106:3478/3479
  - 192.53.117.158:3478/3479
  - 192.53.114.142:3478/3479
  - 139.177.189.166:3478/3479
  - 192.46.227.227:3478/3479

- Monitoring using Prometheus and Grafana ( ```https://grafana.skycoin.com/login``` Deployed in Production k8s)

### Interacting with Environments

1. Setup environment for working with Kubernetes deployment.

- Ask DevOps for Kube-config, place it under ~/.kube/config

- [Kubectx](https://github.com/ahmetb/kubectx) is used for changing clusters when you are dealing with multiple clusters

    Commands:

    ```kubectx```: will list out the number of clusters you have

    ```kubens```: will list out the number of namespaces you have

    example: 
    ```
    (⎈ |default:default)➜  ~ kubectx                       
    skycoin-prod
    skycoin-test
    ```

- [Kube-ps1](https://github.com/jonmosco/kube-ps1) shows the current cluter to your Bash/Zsh prompt strings

    This will show you the current cluster you are dealing with and the default namespace 

    example: see the command promt ```cluster:namespace```

    ```
    (⎈ |default:default)➜  ~ kubectx skycoin-test
    Switched to context "skycoin-test".
    (⎈ |skycoin-test:default)➜  ~ 
    ```

- Use [Stern](https://github.com/wercker/stern) to scrap logs from multiple pods or entire namespace

- Use [fzf](https://github.com/bonnefoa/kubectl-fzf) utility for better productivity


2. Working with the Deployment.

    2.1 List Pods

    - ```Kubectl get pod -n $NAMESPACE```

    2.2 Get logs

    - ```Kubectl logs -n $NAMESPACE $POD_NAME```

    For continuous logs

    - ```Kubectl logs -n $NAMESPACE $POD_NAME -f```

    To pipe the logs with ```less```

    - ```Kubectl logs -n $NAMESPACE $POD_NAME | less```

    To store the logs (even to store continously, add -f) in file

    - ```Kubectl logs -n $NAMESPACE $POD_NAME -f > $FILE_NAME.log```

    2.3 Restart pods

    - ```Kubectl delete pod -n $NAMESPACE $POD_NAME```



    Note: Mostly the skywire services are in ```skywire``` namespace

### Docker registry

We keep docker images for both production and testing in DockerHub Registry. You can build an image manually with: 

- For ```Dmsg-Server```, ```Dmsg-Discovery``` and ```Skywire-Visor``` we are using ```skycoin``` ```Public``` DockerHub Registry.

- For other services, we use ```skycoinpro``` ```Private``` DockerHub Registry.

```
// assuming you are in skywire-services. replace test with latest if you want to push to prod.
docker build -f PATH_TO_DOCKERFILE -t skycoinpro/uptime-tracker:test . 
```

Afterwards you can push with:

```
//login with docker login before if needed
docker push skycoinpro/service-discovery
```
