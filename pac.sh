#!/bin/sh

if [[ -z ${IP} ]]
then

    IP="proxy"

fi

if [[ -z ${PORT} ]]
then

    PORT=3128

fi

if [[ -z ${CONF} ]]
then

    CONF=${DEFAULTCONFIG}

fi

CONF=${CONFDIR}/${CONF%.txt}.txt

echo "
function FindProxyForURL( url, host ) 
{

    var proxyserver = \"${IP}:${PORT}\";

    var proxylist = new Array(
"

while read DOMAIN
do

    [ -z "$DOMAIN" ] && continue

    echo "        '${DOMAIN}',"

done < ${CONF}

echo "    );"

echo "
    for (var i = 0; i < proxylist.length; i++)
    {
        var value = proxylist[i];
        
        if (shExpMatch(host, value))
        {
            return \"PROXY \"+proxyserver;
        }
    }

    return "DIRECT";
}
"

