# Introduction

TODO: the steps that need to be done:

## Write terraform for the following

    * azure devcenter + project
    * az ad service principle,
    * add service connection to az devops, ( I'm not 100% sure this can be done other than in the UI - esp with custom settings. )
    * managed devops pool
    * bonus points: 
        * create an image for the agent that will have az cli, docker and terraform 
        * add subnets and vnets, private endpoint to ACR
        * everything should be parametrized.

Outcome should work like this:
locally starting a script (or better, terraform code) to stand up the services named above. This stands up the infra, first jobs are ready to go in azure devops

## What would be a better, more scalable solution

1. AKS with autoscaling, or running a container instance agent
1. have multiple SPN for different jobs - one for creating the infra, another for deploying the api - potentially this one could be owned by the devs
1. add private network
1. Add storage account for TF State

## NOTES

Azure devops pool needs to be created in azure portal, this will be automatically picked up by azure devops. It cannot be done in Europe West, so I had to change the region to West UK or something similar.
