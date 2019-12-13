# Stacks

## Attributions

Code originally by [Kevin McAnoy](https://github.com/mcanoy/ocp-examples/tree/master/codeready-workspaces)

## Deploying CodeReady Workspaces on OpenShift Container Platform

At the time of writing, the version targeted for CodeReady Workspaces was 1.2. 

More details can be found here:
https://access.redhat.com/documentation/en-us/red_hat_codeready_workspaces/1.2/
https://developers.redhat.com/products/codeready-workspaces/overview

### OpenShift Container Platform v4

CodeReady Workspaces are made available as an Operator based deployment that you can subscribe to through the Operator Lifecycle Manager. Please see the "Installing CodeReady Workspaces From Operator Hub" in the official [Administration Guide](https://access.redhat.com/documentation/en-us/red_hat_codeready_workspaces/1.2/html/administration_guide/index) for further details.

### OpenShift Container Platform v3

Start by downloading the deployment script from the [Red Hat Developer Portal](https://developers.redhat.com) - i.e.: at the time of writing, this was a file named: `codeready-workspaces-1.2.1.GA-operator-installer.tar.gz`. 

Unpack the .tar.gz file:
```
> tar -xzf codeready-workspaces-1.2.1.GA-operator-installer.tar.gz
```

Check the local `README.adoc` in the unpacked directory for more details - including the **Prerequisites** section. In our case, we are using an OpenShift Container Platform v3.11 with valid Let's Encrypt Certificates enabled. CodeReady Workspaces were deployed with the following command (which uses a custom project name, enables oauth with OCP and ensure it's tls enabled for secure connections):

```
> ./deploy.sh -d -p=do500-workspaces -o -s --public-certs
```

<p class="tip">
<b>NOTE</b> - The installation takes about 10-15 minutes - depending on network and cluster speeds. 
</p>

## Custom Multi-Container Stack

This custom stack is intended for use in the DO500 course offered by Red Hat Training. The materials are available on GitHub. Since the technology is constantly changing this stack may fall out of date quickly.

- A shell script is provided to add the [raw config file](do500-raw-config.json). Modify the environment variables.
- An ansible playbook is also provided in the same manner as the shell script if you are more into that.

The tech stack and the [Dockerfile](Dockerfile) used to build it is included. The stack includes RHEL7 UBI, NPM, Ansible, Mongo DB and the OC client.

<p class="tip">
<b>NOTE</b> - The rhel7.repo file needs to be edited to point to a valid repository when building.
</p>

## Install the Code Ready Workspaces stack and factory

This requires a running Code Ready Workspaces install in OpenShift.

Update the [ansible inventory hosts file](playbook/stack-hosts) with your SSO/Keycloak admin credentials and URLs matching your OpenShift Container Platform cluster:

```
cr_host_url="https://codeready-workspaces.apps.cluster.example.com"
cr_sso_url="https://keycloak-workspaces.apps.cluster.example.com/auth/realms/codeready/protocol/openid-connect/token"
cr_user="admin"
cr_password="admin"
```

Run the playbook
```
ansible-playbook -i playbook/stack-hosts playbook/stack.yml
```

## Use the factory to create a workspace

Browse to the Code Ready Workspace factory URL link provided after running the ansible playbook to launch your workspace in OpenShift:

```
  "href": "https://codeready-workspaces.apps.cluster.example.com/f?name=DO500%20Template&user=admin"
```

## Use the nightwatch tests to pre-load the factory

Speed up the time in the classroom by pre-running the workspace generation. Amend the `url` and the `lab` number in the `create-ws.js` file.

Run the test file in the following loop to pre-head 14 CRW:

```
npm i
for i in {01..14};do export LAB_NUMBER="lab$i"; echo "I is $LAB_NUMBER"; npx nightwatch create-ws.js; done
```


## Limit the number of workspaces able to be created by a user

Edit the `custom` configmap that is created within your do500-workspaces project and add

```
oc edit configmap custom -n do500-workspaces

  CHE_LIMITS_USER_WORKSPACES_COUNT: "2"
  CHE_LIMITS_USER_WORKSPACES_RUN_COUNT: "1"
```

This will allow a user to create up to 2 workspaces at one time, while only having the ability to run one at a time.

## Create a plugin registry (Workaround)

We build our own che plugin registry prior to commit for Che7 & CRW 1.2 (which is a breaking change for now and will be removed in future versions).

```
oc new-app --name=che-plugin-registry -f https://raw.githubusercontent.com/eclipse/che-plugin-registry/92c7499aeaa8030bf7f3e0dcab660007de028d00/openshift/che-plugin-registry.yml \
           -p IMAGE="quay.io/rht-labs/che-plugin-registry" \
           -p IMAGE_TAG="latest" \
           -p PULL_POLICY="IfNotPresent"
```

Then update the ConfigMap

```
oc edit configmap custom -n do500-workspaces

  CHE_WORKSPACE_PLUGIN__REGISTRY__URL: http://che-plugin-registry.apps.cluster.example.com

oc scale deployment/codeready --replicas=0
oc scale deployment/codeready --replicas=1
```

If using OpenShift 4.X also add PVC wait workaround to ConfigMap

```
oc edit configmap custom -n che
   CHE_INFRA_KUBERNETES_PVC_WAIT__BOUND: 'false'
```
