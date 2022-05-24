# NetBox Build-o-Matic
I frequently desire a fresh NetBox environment for testing new things or setting up various demos.  There are likely better, more modern programmatic, methods for achieving this same thing.  However, I was searching for a lowest common denominator that I could run in a freshly installed OS.  

My largest hurdle in rapidly acheiving this this was the NetBox build itself, not the OS.  Previously I had created a video that walks through these steps for a manual deployment ([viewable here](https://www.youtube.com/watch?v=Z5zhIiUKrBI)) and would frequently reference that video on new builds.  This encapsulates all of that into a few easy steps.  Caveat here, in order to be a good NetBox administrator I firmly believe it is important to understand the required steps... but I also wanted an easy button to deploy a new instance.

This is a basic series of linked bash scripts that will build and configure a new NetBox instance, on the newest version, per the official documentation.  Designed for and tested on a clean install of Ubuntu 20.04.4 LTS.

ymmv

## Quick Notes

 - The PostgreSQL password is statically coded as `verygoodpassword` and should be manually changed to meet your needs. 
 - The `PRIVATE_KEY` variable, which is required in `configuration.py` is randomly generated using the provided `generate_secret_key.py` script.  It is also automatically inserted into the correct location.  
 - The process will automatically create a NetBox superuser named `admin` with a password of `adminpass`.
 - The SSL cert is generated based on input in the `netbox-cert.conf` file.  Make changes here if required.  


## Executing the Script
After cloning the repo into the location of your choice, your home directory should be fine, run the following:

 - `sudo -i`
 - `cd (cloned directory)/netbox-config-o-matic`
 - `chmod u+x install.sh`
 - `./install.sh`

After launching the `./install.sh` script you'll be watching the full install process, step-by-step, until completed.  Once the install process has returned you to the bash prompt your NetBox environment will be up and running on TCP/443.  It can be accessed by browser at `https://<machine IP address>`

## Frequently Asked Questions

- Why didn't you use X, Y, or Z to accomplish this?
  - Because I didn't want to.
- Don't you think it would be better if you did X instead of Y?
  - Probably.
- If I released code this bad, I would be embarassed.
  - That's not a question. 

