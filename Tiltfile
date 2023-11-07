allow_k8s_contexts('kubernetesOCI')
datei=str(local("date -I| openssl dgst -sha1 -r | awk '{print $1}' | tr -d '\n'"))
sha1=str(local("cat Dockerfile | openssl dgst -sha1 -r | awk '{print $1}' | tr -d '\n'"))
Namespace='sandbox-odoo-dev'
ModuleName='iban_on_invoice_module'
ModulePath='./'+ModuleName
CacheRegistry='ttl.sh/sanbox-cache-dev-'+datei+'-cache'
Registry='ttl.sh/sanbox-odoo-dev-'+sha1
default_registry(Registry)

load('ext://helm_resource', 'helm_resource', 'helm_repo')
load('ext://namespace', 'namespace_create')
os.putenv ( 'NAMESPACE' , Namespace )
os.putenv ( 'MODULENAME', ModuleName )
os.putenv ('MODULEPATH', ModulePath)
os.putenv ( 'DOCKER_REGISTRY' , Registry ) 
os.putenv ( 'DOCKER_CACHE_REGISTRY' , CacheRegistry ) 
namespace_create(Namespace)
helm_repo('highcanfly', 'https://helm-repo.highcanfly.club/')

custom_build('odoo_bitnami_custom_tilted', './kaniko-build.sh', [
    ModuleName
], skips_local_docker = True,
    live_update = [
        sync(ModulePath, '/dev-addons/'+ModuleName),
        run("chmod ugo+rw -R /dev-addons")
    ])

helm_resource('odoo-dev',
    'highcanfly/odoo',
    namespace = Namespace,
    flags = ['--values=./_values.yaml', '--set', 'odoo.image.registry=ttl.sh'],
    image_deps = ['odoo_bitnami_custom_tilted'],
    image_keys=[('odoo.image.registry','odoo.image.repository', 'odoo.image.tag')],
    # port_forwards= '5678:5678',
)

k8s_resource(workload='odoo-dev', port_forwards='5678:5678')

load('ext://uibutton', 'cmd_button', 'location')

cmd_button(name='Push module',
           resource='odoo-dev',
           argv=['find', ModuleName , '-exec', 'touch', '{}','+'])

restore_pod_exec_script = '''
set -eu
# get k8s pod name from tilt resource name
POD_NAME="$(tilt get kubernetesdiscovery "odoo-dev" -ojsonpath='{.status.pods[0].name}')"
kubectl exec -n $Namespace "$POD_NAME" -- "/restore_database.sh"
'''
cmd_button('podexec',
        argv=['sh', '-c', restore_pod_exec_script],
        resource='odoo-dev',
        text='Restore DB',
        env=['Namespace='+Namespace]
)

killpython_pod_exec_script = '''
set -eu
# get k8s pod name from tilt resource name
POD_NAME="$(tilt get kubernetesdiscovery "odoo-dev" -ojsonpath='{.status.pods[0].name}')"
kubectl exec -n $Namespace "$POD_NAME" -- /bin/busybox killall python3
'''
cmd_button('killpython',
        argv=['sh', '-c', killpython_pod_exec_script],
        resource='odoo-dev',
        text='Kill python',
        env=['Namespace='+Namespace]
)

runodoo_pod_exec_script = '''
set -eu
# get k8s pod name from tilt resource name
POD_NAME="$(tilt get kubernetesdiscovery "odoo-dev" -ojsonpath='{.status.pods[0].name}')"
kubectl exec -n $Namespace "$POD_NAME" -- /opt/bitnami/scripts/odoo/run.sh
'''
cmd_button('runoddoo',
        argv=['sh', '-c', runodoo_pod_exec_script],
        resource='odoo-dev',
        text='Run Odoo',
        env=['Namespace='+Namespace]
)

initialrunodoo_pod_exec_script = '''
set -eu
# get k8s pod name from tilt resource name
POD_NAME="$(tilt get kubernetesdiscovery "odoo-dev" -ojsonpath='{.status.pods[0].name}')"
kubectl exec -n $Namespace "$POD_NAME" -- /opt/bitnami/scripts/odoo/entrypoint.sh /opt/bitnami/scripts/odoo/run.sh
'''
cmd_button('initialrunodoo',
        argv=['sh', '-c', initialrunodoo_pod_exec_script],
        resource='odoo-dev',
        text='Initial run Odoo',
        env=['Namespace='+Namespace]
)