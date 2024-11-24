# Introduction

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

1. add private network
1. have multiple SPN for different jobs - one for creating the infra, another for deploying the api - potentially this one could be owned by the devs
1. Add monitoring on agents
1. Add cost alerts
1. AKS with autoscaling, or running a container instance agent

## NOTES

### Known Limitations

    Azure Devops provider does not allow to create resources on the org level, so when the agent pools are created, they later are not removed when running `terraform destroy`. This means that after a destroy, there should be a command to remove the agent pools from the org. This should be scripted, but due to time constraints it was not yet.
