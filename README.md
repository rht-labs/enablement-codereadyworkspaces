# Stacks

## Attributions

Code originally by [Kevin McAnoy](https://github.com/mcanoy/ocp-examples/tree/master/codeready-workspaces)

## Custom Multi-Container Stack

This custom stack is intended for use in the DO500 course offered by Red Hat Training. The materials are available on GitHub. Since the technology is constantly changing this stack should fall out of date quickly.

- A shell script is provided to add the [raw config file](do500-raw-config.json). Modify the environment variables.
- An ansible playbook is also provided in the same manner as the shell script if your more into that.

The tech stack and the [Dockerfile](Dockerfile) used to build it is included. The stack includes RHEL7 UBI, NPM, Ansible, Mongo DB and the OC client.

## Install the Code Ready Workspaces stack and factory

This requires a running Code Ready Workspaces install in OpenShift.

Update the [ansible hosts file](playbook/roles/stack-hosts) with your SSO/Keycloak admin credentials and URL
```
cr_host_url="https://codeready-workspaces.apps.cluster.rht-labs.com"
cr_sso_url="https://keycloak-workspaces.apps.cluster.rht-labs.com/auth/realms/codeready/protocol/openid-connect/token"
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
  "href": "https://codeready-workspaces.apps.cluster.rht-labs.com/f?name=DO500%20Template&user=admin"
```