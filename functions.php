<?php

function isDomain($domain){
    return preg_match('/^[a-z0-9.\-_]+$/i', $domain);
}

function isIp($ip){
    return filter_var($ip, FILTER_VALIDATE_IP);
}

$domain = false;
$ip = false;
if($ipRequest){
    $ip = $_REQUEST['ip'];
    if(!isIp($ip))
        die($ip . ' - Bad IP');
}else{
    $domain = $_REQUEST['url'];
    if(!isDomain($domain))
        die($domain . ' - Bad domain');
}

function myExec($execText){
    $output = array();
    exec($execText, $output);
    $output = implode("\n", $output);
    $output = trim($output);
    return $output;
}

function getDnsArray($domain, $type, $key, $autority){
    $retval = array();
    $values = dns_get_record($domain, $type, $autority);
    foreach($values as $v){
        array_push($retval, $v[$key]);
    }
    return $retval;
}

function getMxArray($domain, $autority){
    $retval = array();
    $values = dns_get_record($domain, DNS_MX, $autority);
    foreach($values as $v){
        array_push($retval, array( $v['target'], $v['pri'] ) );
    }
    return $retval;
}

function printDnsValue($label, $values){
    echo "$label:\n";
    foreach($values as $v){
        echo "$v\n";
    }
    echo "\n";
}

function getDomainPart($name){
    if(!isset($_REQUEST["$name"]) || strlen($_REQUEST["$name"]) == 0) return False;
    $part = $_REQUEST["$name"];
    if(!isDomain($part))
        die($part . ' - Bad domain part');
    return $part;
}
