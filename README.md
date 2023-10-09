# Odoo kubernetes development environment with Tilt.dev
## Why ?
I love Kubernetes, but when its time to develop. It becomes complicated !  
You always need to copy from local to your container…  
Some solutions exists:  
    - [Okteto](https://okteto.com)  
    - [Tilt](https://tilt.dev)  

Here I choosed Tilt.  

# How ?
- install Tilt for [your plaform](https://github.com/tilt-dev/tilt/releases)  
- edit Tiltfile by replacing *kubernetesOCI* with your own Kubernetes context
- copy `sample_values.yaml` to `_values.yaml` and edit it for your needs. Probably the most important changes are the different hostnames and passwords.  
- run `tilt up`  
- browse http://localhost:10350/ for watching the deployement
- browse the host you configured in `_values.yaml` for your odoo deployement
  
# My module
- **this is a template**
- because odoo doesn't like starting with bugged modules, the first deployement is manual.  
- on [ Tilt UI ](http://localhost:10350/r/odoo-dev/overview) Hit **push module**
- now in odoo refresh the App list and (without the App filter) you can find **my_module**