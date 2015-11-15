<?php


$mysqli = mysqli_connect("localhost","root","powerkk","jkdatabase");
$get ="SELECT * FROM store_order";
$result =mysqli_query($mysqli,$get);
printf("result : %d\n",mysqli_num_rows($result));
?>
