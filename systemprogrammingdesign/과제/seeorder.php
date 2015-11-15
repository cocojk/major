<?php

$mysqli = mysql_connect('localhost','root','powerkk');
mysql_select_db('jkdatabase',$mysqli);

$get_order_sql = "SELECT * FROM store_order ORDER BY sel_table";
$get_order_res = mysql_query($get_order_sql);

if($get_order_res)
{
}
else
{
printf("%s\n",mysql_error($mysqli));
}
//printf("row num : %d, field num : %d\n",mysqli_num_rows($get_order_res),mysqli_num_fields($get_order_res));

if (mysql_num_rows($get_order_res) <1){
$display_block .="<p>no order.  <a href=\"store.php\">before menu</a>!</p>";
} else {
$display_block .="<table celpadding=\"3\" cellspacing=\"2\" border=\"1\" width=\"98%\">
<tr>
<th>title</th>
<th>price</th>
<th>qty</th>
<th>table</th>
<th>total price</th>
<th>action</th>
</tr>";

while($cart_info=mysql_fetch_array($get_order_res)){
$id = $cart_info['id'];
$item_title = $cart_info['cat_desc'];
$item_price = $cart_info['sel_item_price'];
$item_qty = $cart_info['sel_item_qty'];
$table =$cart_info['sel_table'];
$total_price = sprintf("%.02f",$item_price*$item_qty);

$display_block .="
<tr>
<td align=\"center\">$item_title<br></td>
<td align=\"center\">$item_price<br></td>
<td align=\"center\">$item_qty<br></td>
<td align=\"center\">$table<br></td>
<td align=\"center\">\$ $total_price</td>
<td align=\"center\"><a href=\"removeorder.php?id=".$id."\">remove</a></td></tr>";
}

}

?>

<html>
<head>
<title>my store</title>
</head>
<body>
<?php echo $display_block; ?>
</body>
</html>
