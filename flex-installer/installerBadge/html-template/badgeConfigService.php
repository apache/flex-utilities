<?php

$ch = curl_init($_GET["url"]);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
echo curl_exec($ch);
curl_close($ch);

?>