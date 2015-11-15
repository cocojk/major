<?php


$mysqli = mysql_connect('localhost','root','powerkk');
mysql_select_db('jkdatabase',$mysqli);

/*if($mysqli)
{

printf("success\n");
}
else
{
printf("%s\n",mysql_error($mysqli));
}
*/
if(isset($_GET["id"])){
$delete_item_sql = "DELETE FROM store_order WHERE id = '".$_GET["id"]."'";

$delete_item_res = mysql_query($delete_item_sql);

if($delete_item_res){

//printf("success\n");
}
else
{
printf("%s\n",mysql_error($mysqli));
}

//printf("success\n");
header("Location: seeorder.php");
exit;
} else{
//printf("error occur\n");
header("Location: store.php");
exit;
}

?>
