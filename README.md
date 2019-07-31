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

Check the `README.adoc` for more details - including the Prerequisites section. In our case, we are using an OpenShift Container Platform v3.11 with valid Let's Encrypt Certificates enabled. CodeReady Workspaces were deployed with the following command (which uses a custom project name, enables oauth with OCP and ensure it's tls enabled for secure connections):

```
> ./deploy.sh -d -p=do500-workspaces -o -s --public-certs
```

<p class="tip">
<b>NOTE</b> - The installation takes about 10-15 minutes - depending on network and cluster speeds. 
</p>

## Custom Multi-Container Stack

This custom stack is intended for use in the DO500 course offered by Red Hat Training. The materials are available on GitHub. Since the technology is constantly changing this stack should fall out of date quickly.

- A shell script is provided to add the [raw config file](do500-raw-config.json). Modify the environment variables.
- An ansible playbook is also provided in the same manner as the shell script if your more into that.

The tech stack and the [Dockerfile](Dockerfile) used to build it is included. The stack includes RHEL7 UBI, NPM, Ansible, Mongo DB and the OC client.

## Install the Code Ready Workspaces stack and factory

This requires a running Code Ready Workspaces install in OpenShift.

Update the [ansible hosts file](playbook/stack-hosts) with your SSO/Keycloak admin credentials and URL

```
cr_host_url="https://codeready-workspaces.apps.cluster.example.com"
cr_sso_url="https://keycloak-workspaces.apps.cluster.example.com/auth/realms/codeready/protocol/openid-connect/token"
cr_user="admin"
cr_password="admin"
```

Run the playbook
```
ansible-playbook -i stack-hosts stack.yml
```

## Use the factory to create a workspace

Browse to the Code Ready Workspace factory URL link provided after running the ansible playbook to launch your workspace in OpenShift

```
  "href": "https://codeready-workspaces.apps.cluster.example.com/f?name=DO500%20Template&user=admin"
```
