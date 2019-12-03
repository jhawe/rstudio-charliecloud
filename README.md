# Run Rstudio from within charliecloud container

This repository simply contains a [dockerfile](https://docs.docker.com/engine/reference/builder/) and some scripts/infos to make [Rstudio server](https://rstudio.com/products/rstudio/) work with [charliecloud](https://github.com/hpc/charliecloud) containers.

Please note that this repo is more of a documentation of the process and is to some degree specific to the system I use it for.
You hence may need to adjust some parts of the scripts to work with your setup/HPC environment.

The main idea behind this strategy is to fake authenticate users for rstudio using a randomly generated password (compare [this charliecloud issue](https://github.com/hpc/charliecloud/issues/569)).

> NOTE: Scripts were in part adapted from https://github.com/OSC/bc_osc_rstudio_server

Apart from the main dockerfile, this approach uses two more scripts:

---------
[scripts/rstudio_auth.sh](scripts/rstudio_auth.sh)

This is the 'fake authentication' script provided to the Rstudio server during startup to help authenticating users.
In essence, the script checks whether the supplied user-name corresponds to the current user's name and checks whether the supplied password matches the value of an environment variable, `RSTUDIO_PASSWORD`, which is set in [scripts/start_rstudio.sh](scripts/start_rstudio.sh).

---------
[scripts/start_rstudio.sh](scripts/start_rstudio.sh)

This script prepares the necessary environment (generates password and sets environment variable, sets path to authentication script, prepares secure-cookie file) and runs the Rstudio server. It further provides some additional output to the user, such as the generated random password as well as the address to the server (in case of a SLURM based HPC system).

NOTE: The `$SLURMD_NODENAME` variable is used since the `$HOSTNAME` was not available on the system I was testing on. It might suffice for you to simple substitute these two variables to fix the address displayed to the user.

---------

The above two scripts are copied to the `/bin/` directory in the charliecloud image containing the Rstudio server (compare e.g. [dockerfiles/r3.6.1_rstudio_server](dockerfiles/r3.6.1_rstudio_server)).

If you prepared the image tar-ball accordingly you can start the server simply by calling:

`ch-run <path-to-image> -- start_rstudio <port>`

e.g.: `ch-run r3.6.1_rstudio_server.tar.gz -- start_rstudio 8181`

Note that the port you choose (`8181` in the example above) needs to be accessible on the machine you want to run the server.


# Additional scripts

I put a script for convenient creation of charliecloud images from docker in this respository: [scripts/export_images.sh](scripts/export_image.sh)

This script can be used (if you run it on a machine running docker) to build, create and export a dockerfile to ultimately create a charliecloud tar-ball image.

-------
To check whether everything is working well, start the Rstudio server and try to execute the following simple R script:

```{r}
# load toy data
data(cars)
print(summary(cars))

# create linear model
lm <- lm(dist~speed, cars)
# plot linear model results
plot(lm, 1)
```

If you use e.g. the rocker/verse image as in this repo, the following lines should also work:

```{r}
# load tidyverse packages
library(tidyverse)

# load toy data
data(cars)

# plot using ggplot
ggplot(cars, aes(x=dist, y=speed)) + 
  geom_point() + 
  geom_smooth()
```
