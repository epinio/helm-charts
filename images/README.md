Build this image:

```
docker build -t epiniod --build-arg VERSION=1.0.0 .
```

(set the VERSION build arg to the version of the chart that this image should use)

Run it:

```
docker run --name epiniod -it --privileged -p 443:443 epiniod
```

Visit https://epinio.127.0.0.1.sslip.io in your browser
