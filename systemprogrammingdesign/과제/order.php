<?php
session_start();

$mysqli = mysql_connect('localhost','root','powerkk');
mysql_select_db('jkdatabase',$mysqli);

$get_cart_sql ="INSERT INTO store_order (cat_desc,sel_table,sel_item_qty,sel_item_price) SELECT si.item_title, st.sel_table, st.sel_item_qty, si.item_price FROM store_shoppertrack AS st LEFT JOIN store_items AS si ON si.id = st.sel_item_id WHERE session_id = '".$_COOKIE["PHPSESSID"]."'";

$get_cart_res = mysql_query($get_cart_sql);

if($get_cart_res)
{
//printf("success \n");
}
else
{
printf("%s\n",mysql_error($mysqli));
}

$delete_item_sql ="DELETE FROM store_shoppertrack WHERE session_id='".$_COOKIE["PHPSESSID"]."'";

$delete_item_res =mysql_query($delete_item_sql);
if($delete_item_res)
{
//printf("sucess");
}
else
{
printf("%s\n",mysql_error($mysqli));
}

header("Location: showcart.php");
exit;
?>
