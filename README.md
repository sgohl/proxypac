# proxypac
Proxy Auto Configuration Dynamic Generator Service

## Background

Usually, Browsers let you set a proxy with the possibility to **exclude** destination hosts by a list or pattern.
Sometimes this is not enough and you actually want the opposite: Only use proxy for **specific** destination hosts.

For this purpose, browsers provide a way to set a *Automatic proxy configuration URL*

Then you might want to provide a way to let users set the proxy to use themselves. For example, in my case, developers have their own servers with a squid installed. That way, development domains can all resolve to `127.0.0.1` and be the same for everybody.

You may also want to serve different destination domains for different groups of people

## Features

This http-service is a dynamic generator of such proxy-auto-configuration featuring:

- set proxy (ip) via HTTP ``GET`` arg `?ip=` -> (default `proxy`)
- set proxy (port) via HTTP ``GET`` arg `?port=` -> (default `3128`)
- set domain config via HTTP ``GET`` arg `?conf=` (txt-file in `config/`)

## How it works

The response generated by this service looks like this

```
function FindProxyForURL( url, host ) 
{

    var proxyserver = "${IP}:${PORT}";

    var proxylist = new Array(
        'example.org',
        'example.net',
    );

    for (var i = 0; i < proxylist.length; i++)
    {
        var value = proxylist[i];
        
        if (shExpMatch(host, value))
        {
            return "PROXY "+proxyserver;
        }
    }

    return "DIRECT";
}
```

The webserver used in front of this service is https://github.com/msoap/shell2http  
it calls the sh-script `pac.sh` that generates this response, while injecting the variables and the domain list (`var proxylist`) in a while-loop.


## Environment variables

These variables can either be changed by building your own image or at container-start:

- CONFDIR (default = `/config`)
- PORT (for the webserver) (default = `8080`)
- DEFAULTCONFIG (default = `default` -> `${CONFDIR}/default.txt`)
- ROUTE (default `/`)

## Quick Start

```
docker run --pull=always --name proxypac --rm -p 8080:8080 ghcr.io/sgohl/proxypac:main
```

goto: http://localhost:8080/?ip=192.168.123.456


## Fallback proxy via `/etc/hosts`

In case the user does not set the HTTP `GET` arg `?ip=` 
the service responds per default with `proxy`

That way - if you prefer - you can set the IP of the `proxy` via `/etc/hosts` (or `c:\windows\system32\drivers\etc\hosts`) 

```
192.168.123.456 proxy
```

