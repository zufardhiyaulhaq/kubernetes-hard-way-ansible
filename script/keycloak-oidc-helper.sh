#!/bin/bash

# script for getting Keycloak OIDC credential for kubeconfig
# please change the variable below

read -p "cluster name: " CLUSTER_NAME

KEYCLOAK_USERNAME=<KEYCLOAK-OIDC-USERNAME>
KEYCLOAK_PASSWORD=<KEYCLOAK-OIDC-PASSWORD>
KEYCLOAK_URL=https://<KEYCLOAK-OIDC-URL>:<KEYCLOAK-OIDC-PORT>
KEYCLOAK_REALM=<KEYCLOAK-OIDC-REALM>
KEYCLOAK_CLIENT_ID=<KEYCLOAK-OIDC-CLIENT-ID>
KEYCLOAK_CLIENT_SECRET=<KEYCLOAK-OIDC-CLIENT-SECRET>

if [ "${KEYCLOAK_USERNAME}" = "" ];then
	read -p "username: " KEYCLOAK_USERNAME
fi
if [ "${KEYCLOAK_PASSWORD}" = "" ];then
	read -sp "password: " KEYCLOAK_PASSWORD
fi

KEYCLOAK_TOKEN_URL=${KEYCLOAK_URL}/auth/realms/${KEYCLOAK_REALM}/protocol/openid-connect/token 

echo
echo "# Getting a token ..."

TOKEN=`curl -s ${KEYCLOAK_TOKEN_URL} \
  -d grant_type=password \
  -d response_type=id_token \
  -d scope=openid \
  -d client_id=${KEYCLOAK_CLIENT_ID} \
  -d client_secret=${KEYCLOAK_CLIENT_SECRET} \
  -d username=${KEYCLOAK_USERNAME} \
  -d password=${KEYCLOAK_PASSWORD} -k`

RET=$?
if [ "$RET" != "0" ];then
	echo "# Error ($RET) ==> ${TOKEN}";
	exit ${RET}
fi

ERROR=`echo ${TOKEN} | jq .error -r`
if [ "${ERROR}" != "null" ];then
	echo "# Failed ==> ${TOKEN}" >&2
	exit 1
fi

ID_TOKEN=`echo ${TOKEN} | jq .id_token -r`
REFRESH_TOKEN=`echo ${TOKEN} | jq .refresh_token -r`

echo ""
echo "# Set user ${KEYCLOAK_USERNAME} in .kube/config ..."
kubectl config set-credentials ${KEYCLOAK_USERNAME} \
    --auth-provider=oidc \
    --auth-provider-arg=idp-issuer-url=${KEYCLOAK_URL}/auth/realms/${KEYCLOAK_REALM} \
    --auth-provider-arg=client-id=${KEYCLOAK_CLIENT_ID} \
    --auth-provider-arg=client-secret=${KEYCLOAK_CLIENT_SECRET} \
    --auth-provider-arg=refresh-token=${REFRESH_TOKEN} \
    --auth-provider-arg=id-token=${ID_TOKEN} \
    --auth-provider-arg=extra-scopes=user_groups

echo ""
echo "# Change user in ${CLUSTER_NAME} to ${KEYCLOAK_USERNAME}"
kubectl config set-context ${CLUSTER_NAME} --cluster ${CLUSTER_NAME} --user ${KEYCLOAK_USERNAME}

echo ""
echo "# Change context to ${CLUSTER_NAME}"
kubectl config use-context ${CLUSTER_NAME}

echo ""
echo "# Please create RBAC for specific user or group for OIDC"
