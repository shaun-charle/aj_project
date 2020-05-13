# Run time-series analysis for total sales_volume forcast

### A. First you will need to install docker

*Windows*:

* If you have a windows version older than windows 10 then download docker toolbox from this [link](https://github.com/docker/toolbox/releases/download/v19.03.1/DockerToolbox-19.03.1.exe)
* Install docker from this [link](https://download.docker.com/win/stable/Docker%20Desktop%20Installer.exe);
* Open a terminal window (Command Prompt or PowerShell, but not PowerShell ISE).
* Run the command `docker --version` to ensure that you have a supported version of Docker:

*Mac*:

1. Install docker from this [link](https://download.docker.com/mac/stable/Docker.dmg);
2. Open a terminal window.
3. Run the command `docker --version` in your terminal to ensure that you have a supported version of Docker:

*Linux*:
1. Run the following commands in your terminal
```sh
$ sudo apt-get update
$ sudo apt-get install docker-ce docker-ce-cli containerd.io
```
2. Run the command `docker --version` in your terminal to ensure that you have a supported version of Docker:

### B. Pull and RUN the docker-image

Run the following command in your terminal:

```sh
$docker run -p3838:3838 shaun_charle/time_series_app:latest
```

### C. Use the application

Go to your browser and type the following URL: 

`localhost:3838`