class API{
  static const hostConnect ="http://172.16.55.101/api_luna";
  static const hostConnectUser ="$hostConnect/user";
  static const hostConnectAdmin ="$hostConnect/admin";
  static const hostConnectItem ="$hostConnect/items";
  static const hostConnectFlower ="$hostConnect/flower";
  static const hostAddToCart ="$hostConnect/cart";
  static const hostFavoriteProduct ="$hostConnect/favorite";
  static const hostOrderProduct ="$hostConnect/order";
  static const hostImages ="$hostConnect/transaction_image/";

  // signup user
static const signUp = "$hostConnect/user/signup.php";
static const validateEmail = "$hostConnect/user/validate_email.php";
static const signIn= "$hostConnect/user/login.php";
static const adminSignIn= "$hostConnect/admin/login.php";
static const adminReadOrder= "$hostConnect/admin/read_order.php";
static const updateUser= "$hostConnectUser/update_user.php";

  static const upLoadItems= "$hostConnectItem/upload.php";
  static const forYouFlowerItems= "$hostConnectFlower/foryou.php";
  static const tagFlowerItems= "$hostConnectFlower/tag.php";
  static const newFlowerItems= "$hostConnectFlower/all.php";
  static const bestSellFlowerItems= "$hostConnectFlower/bestsell.php";
  static const addToCart= "$hostAddToCart/add.php";
  static const getCart= "$hostAddToCart/read.php";
  static const deleteCart= "$hostAddToCart/delete.php";
  static const updateCart= "$hostAddToCart/update.php";
  static const addFavoriteProduct= "$hostFavoriteProduct/add.php";
  static const deleteFavoriteProduct= "$hostFavoriteProduct/delete.php";
  static const validateFavoriteProduct= "$hostFavoriteProduct/validate_favorite.php";
  static const readFavoriteProduct= "$hostFavoriteProduct/read.php";
  static const searchProduct= "$hostConnectItem/search.php";
  static const addOrderProduct= "$hostOrderProduct/add.php";
  static const readOrderProduct= "$hostOrderProduct/read.php";
  static const updateOrderProduct= "$hostOrderProduct/update_status.php";
  static const readHistoryOrderProduct= "$hostOrderProduct/read_history.php";
  static const readUser= "$hostConnectUser/read_user.php";

}