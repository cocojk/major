<?php
$mysqli =mysqli_connect("localhost","root","powerkk","jkdata");

if(mysqli_connect_errno()){
printf("connect failed : %s\n",mysqli_connect_error());
exit();
}
else
{
printf("host information : %s \n",mysqli_get_host_info($mysqli));
}
?>
