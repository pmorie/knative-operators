#!/bin/bash 

set -x

minishift openshift config set --target=kube --patch '{
    "admissionConfig": {
        "pluginConfig": {
            "ValidatingAdmissionWebhook": {
                "configuration": {
                    "apiVersion": "apiserver.config.k8s.io/v1alpha1",
                    "kind": "WebhookAdmission",
                    "kubeConfigFile": "/dev/null"
                }
            },
            "MutatingAdmissionWebhook": {
                "configuration": {
                    "apiVersion": "apiserver.config.k8s.io/v1alpha1",
                    "kind": "WebhookAdmission",
                    "kubeConfigFile": "/dev/null"
                }
            }
        }
    }
}'

# wait until the kube-apiserver is restarted
until oc login -u admin -p admin; do sleep 5; done;

oc project myproject
oc adm policy add-scc-to-user privileged -z default

# for the OLM console
oc adm policy add-cluster-role-to-user cluster-admin system:serviceaccount:kube-system:default
