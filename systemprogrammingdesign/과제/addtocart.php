<?php
session_start();


$mysqli = mysql_connect('localhost','root','powerkk');
mysql_select_db('jkdatabase',$mysqli);


if(isset($_POST["sel_item_id"])){
$get_iteminfo_sql = "SELECT item_title FROM store_items WHERE id= '".$_POST["sel_item_id"]."'";

$get_iteminfo_res = mysql_query($get_iteminfo_sql);

if($get_iteminfo_res)
{
//printf("sucess \n");
}
else
{
printf("%s \n",mysql_error($mysqli));
}


if(mysql_num_rows($get_iteminfo_res) <1){
$display_block .="<p><strong><em>no exist menu:</em><br/><a href=\"jkstore.php\">back jkstore</strong></p>";
} else {
while($item_info = mysql_fetch_array($get_iteminfo_res)) {
$item_title = stripslashes($item_info['item_title']);
}
//printf("success\n");




$addtocart_sql = "INSERT INTO store_shoppertrack (session_id, sel_item_id, sel_item_qty,sel_table) VALUES ('".$_COOKIE["PHPSESSID"]."','".$_POST["sel_item_id"]."','".$_POST["sel_item_qty"]."','".$_POST["sel_table"]."')";

$addtocart_res = mysql_query($addtocart_sql);

/*
if($addtocart_res)
{
$showcart_sql ="SELECT session_id,sel_item_id,sel_item_qty,sel_item_size,sel_item_color from store_shoppertrack";
$showcart_res = mysql_query($showcart_sql);
if($showcart_res)
{
if(mysql_num_rows($showcart_res)>1){
printf("exist");

}

}
else
{
printf("%s\n",$mysql_error($mysqli));
}

}
else
{
printf("%s\n",mysql_error($mysqli));
}
*/

header("Location: showcart.php");
exit;



} 

}
?>
<html>
<head>
<title>add to cart</title>
</head>
<body>
<?php echo $display_block; ?>
</body>
</html>
