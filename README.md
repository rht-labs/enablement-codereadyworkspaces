# Stacks

## Attributions

Code originally by [Kevin McAnoy](https://github.com/mcanoy/ocp-examples/tree/master/codeready-workspaces)

## Deploying CodeReady Workspaces on OpenShift Container Platform

At the time of writing, the version targeted for CodeReady Workspaces was 2.0

More details can be found here:
- https://access.redhat.com/documentation/en-us/red_hat_codeready_workspaces/2.0/
- https://developers.redhat.com/products/codeready-workspaces/overview

### OpenShift Container Platform v4

CodeReady Workspaces are made available as an Operator based deployment that you can subscribe to through the Operator Lifecycle Manager. Please see the "Installing CodeReady Workspaces From Operator Hub" in the official [Installation Guide](https://access.redhat.com/documentation/en-us/red_hat_codeready_workspaces/2.0/html-single/installation_guide/index) for further details.

OR from the cli run:
```
# Create 'crw' Project and Deploy Operator
oc apply -f deploy/create-crw.yaml

# Create an instance of checluster.org.eclipse.che "codeready-workspaces"
oc apply -f deploy/org_v1_che_cr.yaml
```

<p class="tip">
<b>NOTE</b> - Use file - org_v1_che_cr_insecure.yaml - if you have self signed router certificates.
<p> You will also need to manually accept SSL self signed certs in your browser for all routes in your workspace namespace else you will not be able to open a terminal or workspace without error.</p>
</p>

### OpenShift Container Platform v3

Install guide
- https://www.eclipse.org/che/docs/che-7/installing-che-on-openshift-3-using-the-operator

Download the `crwctl` helper from here and puth on PATH:
- https://developers.redhat.com/products/codeready-workspaces/download
- https://github.com/redhat-developer/codeready-workspaces-chectl/releases

```
wget https://github.com/redhat-developer/codeready-workspaces-chectl/releases/download/20191122111826/crwctl-linux-x64.tar.gz
tar xzvf crwctl-linux-x64.tar.gz
export PATH=$PATH:<path to crwctl/bin>
```

Create Project and Deploy Operator and Instance using crwctl:
```
oc new-project crw --display-name="CRW" --description='CRW'
crwctl server:start --platform=openshift --installer=operator --che-operator-cr-yaml=org_v1_che_cr.yaml --chenamespace crw --k8spodreadytimeout=600000 --k8spodwaittimeout=600000
```

<p class="tip">
<b>NOTE</b> - crwctl is finnicky about the size of your ~/.kube/config. If you recieve an error like:
<p>Error: contexts[518].context.cluster is missing</p>
<p> move your kube config aside, relogin to cluster and try install command again
</p>

## Custom Multi-Container Stack

This custom stack is intended for use in the DO500 course offered by Red Hat Training. The materials are available on GitHub. Since the technology is constantly changing this stack may fall out of date quickly.

The tech stack and the [Dockerfile](Dockerfile) used to build it is included. The stack includes RHEL7 UBI, NPM, Ansible, Mongo DB and the OC client.

<p class="tip">
<b>NOTE</b> - The rhel7.repo file needs to be edited to point to a valid repository when building.
</p>

## Use the devfile to create a workspace

Browse to the Code Ready Workspace factory URL link provided after installing CRW to launch your workspace in OpenShift:

```
https://codeready-workspaces.apps.cluster.example.com/f?url=https://raw.githubusercontent.com/rht-labs/enablement-codereadyworkspaces/master/do500-devfile.yaml"
```

## Use the nightwatch tests to pre-create the workspaces

Speed up the time in the classroom by pre-running the workspace generation. Amend the `url` and the `lab` number in the `create-ws.js` file.

Run the test file in the following loop to pre-head 14 CRW:

```
npm i
npm install chromedriver --save-dev
for i in {01..14};do export LAB_NUMBER="lab$i"; echo "I is $LAB_NUMBER"; npx nightwatch create-ws.js; done
```
