<?php

$mysqli = mysql_connect('localhost','root','powerkk');
mysql_select_db('jkdatabase',$mysqli);

$display_block ="<h1>jk coffee store</h1>
<p>Select a category to see its items.</p>";


$get_cats_sql = "SELECT id, cat_title, cat_desc FROM store_categories ORDER BY cat_title";
$get_cats_res= mysql_query ($get_cats_sql);



if (mysql_num_rows($get_cats_res)<1) {
	$display_block = "<p><em>Sorry, no categories.</em></p>";
} else {
	while($cats = mysql_fetch_array($get_cats_res)){
		$cat_id = $cats['id'];
		$cat_title = strtoupper(stripslashes($cats['cat_title']));
		$cat_desc = stripslashes($cats['cat_desc']);

		$display_block .="<p><strong><a href=\"".$_SERVER["PHP_SELF"]."?cat_id=".$cat_id."\">".$cat_title."</a></strong><br/>".$cat_desc."</p>";


if(isset($_GET["cat_id"])){
if($_GET["cat_id"] == $cat_id) {
$get_items_sql = "SELECT id, item_title, item_price FROM store_items WHERE cat_id = '".$cat_id."' ORDER BY item_title";
$get_items_res = mysql_query($get_items_sql) ;

		if (mysql_num_rows ($get_items_res)<1) {
			$display_block = "<p><em>Sorry, no items in this category.</em></p>";
		} else {
			$display_block .= "<ul>";
			while($items=mysql_fetch_array($get_items_res)){
				$item_id = $items['id'];
				$item_title=stripslashes($items['item_title']);
				$item_prices = $items['item_price'];

				$display_block .="<li><a href=\"showitem.php?item_id=".$item_id."\">".$item_title."</a></strong>(\$".$item_price.")</li>";
			}

			$display_block .= "</ul>";
		}

		mysql_free_result($get_items_res);
	}
}
}
}
mysql_free_result ($get_cats_res);
mysql_close($mysqli);

?>

<html>
<head>
<title>My Categorires</title>
</head>
<body>
<?php echo $display_block; ?>
</body>
</html>


