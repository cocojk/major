<?php
session_start();

$mysqli = mysql_connect('localhost','root','powerkk');
mysql_select_db('jkdatabase',$mysqli);

//$display_block .="<form method=\"post\" action=\"order.php\">";

$display_block ="<h1>your shopping cart</h1>";


$get_cart_sql ="SELECT st.id, si.item_title, si.item_price, st.sel_item_qty, st.sel_table FROM store_shoppertrack AS st LEFT JOIN store_items AS si ON si.id = st.sel_item_id WHERE session_id = '".$_COOKIE["PHPSESSID"]."'";

$get_cart_res = mysql_query($get_cart_sql);

if($get_cart_res)
{
//printf("success \n");
}
else
{
printf("%s\n",mysql_error($mysqli));
}

$display_block .="<p><strong><a href=\"jkstore.php\">go to menu</strong></p>";
if (mysql_num_rows($get_cart_res) <1){
$display_block .="<p>you have no items in your cart. please <a href=\"jkstore.php\">continue to shop</a>!</p>";
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

while($cart_info=mysql_fetch_array($get_cart_res)){
$id = $cart_info['id'];
$item_title = stripslashes($cart_info['item_title']);
$item_price = $cart_info['item_price'];
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
<td align=\"center\"><a href=\"removefromcart.php?id=".$id."\">remove</a></td></tr>";
}

//$display_block .="</table>";

$display_block .="</table>
<form method=\"post\" action=\"order.php\">
<p><input type=\"submit\" value=\"order\"/></p>
</form>";

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
