<?php

$mysqli = mysql_connect('localhost','root','powerkk');
mysql_select_db('jkdatabase',$mysqli);
$display_block ="<h1>Item Detail </h1>";

$get_item_sql = "SELECT c.id as cat_id, c.cat_title, si.item_title, si.item_price, si.item_desc FROM store_items AS si LEFT JOIN store_categories AS c on c.id = si.cat_id WHERE si.id = '".$_GET["item_id"]."'";

$get_item_res = mysql_query($get_item_sql);
/*
if($get_item_res) {
printf("success \n");
}
else
{
printf("error : %s\n",mysqli_error($mysqli));
}*/

if(mysql_num_rows($get_item_res)<1) {
$display_block .="<p><em>Invalid item selection.</em></p>";
} else {
while($item_info = mysql_fetch_array($get_item_res))
{
$cat_id = $item_info['cat_id'];
$cat_title = strtoupper(stripslashes($item_info['cat_title']));
$item_title = stripslashes($item_info['item_title']);
$item_price = $item_info['item_price'];
$item_desc = stripslashes($item_info['item_desc']);

}



$display_block .="<p><strong><em>You are viewing:</em><br/><a href=\"jkstore.php?cat_id=".$cat_id."\">".$cat_title."</a>&gt; ".$item_title."</strong></p>
<table cellpadding=\"3\" cellspacing=\"3\">
<tr>
<td valign=\"middle\" align=\"center\">
<td valign=\"middle\"><p><strong>Description:</strong><br/>".$item_desc."</p>
<p><strong>Price:</strong> \$".$item_price."</p>
<form method=\"post\" action=\"addtocart.php\">";

mysql_free_result($get_item_res);

/*
$get_colors_sql ="SELECT item_color FROM store_item_color WHERE item_id = '".$_GET["item_id"]."' ORDER BY item_color";
$get_colors_res = mysql_query($mysqli,$get_colors_sql) or die ("error");

if($get_colors_res)
{
printf("success\n");
}
else
{
printf("error : %s\n",mysql_error($mysqli));
}


if(mysql_num_rows($get_colors_res)>0){
$display_block .="<p><strong>Available Colors:</strong><br/><select name=\"sel_item_color\">";

while($colors = mysql_fetch_array($get_colors_res)){
$item_color = $colors['item_color'];
$display_block .="<option value=\"".$item_color."\">".$item_color."</option>";
}


$display_block .="<select>";
}

mysql_free_result($get_colors_res);

$get_sizes_sql = "SELECT item_size FROM store_item_size WHERE item_id=".$_GET["item_id"]." ORDER BY item_size";
$get_sizes_res = mysql_query($get_sizes_sql) or die ("error");

if($get_sizes_res)
{
printf("success\n");
}
else
{
printf("error : %s\n",mysql_error($mysqli));
}

}

if(mysql_num_rows($get_sizes_res)>0){
$display_block .="<p><strong>Available sizes:</strong><br/><select name=\"sel_item_size\">";

while ($sizes=mysql_fetch_array($get_sizes_res)){
$item_size = $sizes['item_size'];
$display_block .="<option value=\"".$item_size."\">".$item_size."</option>";
}
}


$display_block .="</select>";

mysql_free_result($get_sizes_res);
 
*/


$display_block .="<p><strong>Select Quantity:</strong><select name=\"sel_item_qty\">";





for($i=1; $i<11; $i++) {
$display_block .="<option value=\"".$i."\">".$i."</option>";
}
$display_block .="</select>";

$display_block .="<p><strong>select table :</strong><select name=\"sel_table\">";
for($i=1; $i<11; $i++){
$display_block .="<option value=\"".$i."\">".$i."</option>";
}



$display_block .="</select><input type=\"hidden\" name=\"sel_item_id\"value=\"".$_GET["item_id"]."\"/><p><input type=\"submit\" name=\"submit\" value=\"Add to cart\"/></p>

</form>
</td>
</tr>
</table>";
}

mysql_close($mysqli);
?>
<html>
<head>
<title>My store</title>
</head>
<body>
<?php echo $display_block; ?>
</body>
</html>





