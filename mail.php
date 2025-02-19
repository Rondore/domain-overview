<?php
require_once('functions.php');
$selector = getDomainPart('selector');
if($selector === False){
    echo system("./mail.sh $domain");
}else{
    echo system("./mail.sh $domain $selector");
}
