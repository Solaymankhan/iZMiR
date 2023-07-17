
import 'package:izmir/consts/consts.dart';
import 'package:izmir/pages/cart_page_2.dart';

import '../model/product_model.dart';
import '../pages/admin_page.dart';
import '../pages/complains_page.dart';
import '../pages/message_book_page.dart';
import '../pages/liked_shops_page.dart';
import '../pages/my_orders_page.dart';
import '../pages/my_sales_page.dart';
import '../pages/notification_page_2.dart';
import '../pages/my_brands_page.dart';
import '../pages/returns_page.dart';
import '../pages/statistics_page.dart';

const banner_list=[img1,img2,img3,img4,img5,img6,img7,img8,img9,img10,img11,img12,
  img13,img14,img15,img16,img17,img18,img19,img20,img21,img22,img23,img24,img25,img26,img27,
  img28,img29];
const item_icon_list=[cosmetics_icon,glasess_icon,
  glasses2_icon,kids_icon,more_icon,more2_icon,
  pants_icon,perfume_icon,polo_icon,sari_icon,
  t_shirt_icon,shirt_icon,umbrella_icon];

var page_list=[
  cart_page_2(),my_orders_page(),returns_page(),liked_shops_page(),
  admin_page(),my_brands_page(),my_sales_page(),
];

final seasons_list=["All","Summer","Monsoon","Winter"];
final color_list=["1","2","3","4","5","6","7","8","9","10"];
final month_names=["January", "February", "March", "April", "May", "June", "July",
  "August", "September", "October", "November", "December"];
final division_list=["Dhaka","Chittogram","Sylhet","Rajshahi","Mymensingh","Khulna","Barishal","Rangpur"];

var district_list={"Dhaka":"1","Faridpur":"1","Gazipur":"1", "Gopalganj":"1",
  "Kishoreganj":"1", "Madaripur":"1", "Manikganj":"1", "Munshiganj":"1",
  "Narayanganj":"1","Narsingdi":"1", "Rajbari":"1","Shariyatpur":"1",
  "Tangail":"1","Bandarban":"2", "Brahmanbaria": "2","Chandpur": "2",
  "Chattogram": "2", "Cumilla": "2", "Cox’s Bazar": "2","Feni": "2",
  "Khagrachhari": "2","Lakshmipur": "2","Noakhali": "2","Rangamati": "2",
  "Habiganj":"3", "Moulvibazar":"3", "Sunamganj":"3","Sylhet":"3",
  "Bogura": "4", "Chapai Nawabganj": "4", "Joypurhat": "4", "Naogaon": "4",
  "Natore": "4", "Pabna": "4","Rajshahi": "4", "Sirajganj": "4","Jamalpur":"5", "Mymensingh":"5",
  "Netrakona":"5", "Sherpur":"5","Bagerhat":"6", "Chuadanga":"6", "Jashore":"6", "Jhenaidah":"6",
  "Khulna":"6", "Kushtia":"6", "Magura":"6", "Meherpur":"6", "Narail":"6","Satkhira":"6",
  "Barguna":"7", "Barishal":"7", "Bhola":"7","Jhalakathi":"7", "Patuakhali":"7", "Pirojpur":"7",
  "Dinajpur":"8", "Gaibandha":"8", "Kurigram":"8","Lalmonirhat":"8", "Nilphamari":"8",
  "Panchagarh":"8", "Rangpur":"8","Thakurgaon":"8"};

const item_name_list=["Cosmetics","Glasess",
  "Glasses2","Kids","More","More2",
  "Pants","Perfume","Polo","Sari",
  "T-shirt","Shirt","Umbrella"];


List<product_model> product_data_from_server=[
  product_model(id: 123,
      product_img: banner_list[0],
      product_description:  "sadfajof dfjaoij adoifj sdadifj oiddescription",
      product_price: "1500",
      product_discount: "15%",
      m_size:"15",
      l_size:"15",
      xl_size:"15"
  ),
  product_model(id: 123,
      product_img: banner_list[1],
      product_description:  "sadfajof dfjaoij adoifj sdadifj oiddescription",
      product_price: "1500",
      product_discount: "15%",
      m_size:"15",
      l_size:"15",
      xl_size:"15"
  ), product_model(id: 123,
      product_img: banner_list[2],
      product_description:  "sadfajof dfjaoij adoifj sdadifj oiddescription",
      product_price: "1500",
      product_discount: "15%",
      m_size:"15",
      l_size:"15",
      xl_size:"15"
  ), product_model(id: 123,
      product_img: banner_list[3],
      product_description:  "sadfajof dfjaoij adoifj sdadifj oiddescription",
      product_price: "1500",
      product_discount: "15%",
      m_size:"15",
      l_size:"15",
      xl_size:"15"
  ), product_model(id: 123,
      product_img: banner_list[4],
      product_description:  "sadfajof dfjaoij adoifj sdadifj oiddescription",
      product_price: "1500",
      product_discount: "15%",
      m_size:"15",
      l_size:"15",
      xl_size:"15"
  ), product_model(id: 123,
      product_img: banner_list[5],
      product_description:  "sadfajof dfjaoij adoifj sdadifj oiddescription",
      product_price: "1500",
      product_discount: "15%",
      m_size:"15",
      l_size:"15",
      xl_size:"15"
  ), product_model(id: 123,
      product_img: banner_list[6],
      product_description:  "sadfajof dfjaoij adoifj sdadifj oiddescription",
      product_price: "1500",
      product_discount: "15%",
      m_size:"15",
      l_size:"15",
      xl_size:"15"
  ), product_model(id: 123,
      product_img: banner_list[7],
      product_description:  "sadfajof dfjaoij adoifj sdadifj oiddescription",
      product_price: "1500",
      product_discount: "15%",
      m_size:"15",
      l_size:"15",
      xl_size:"15"
  ), product_model(id: 123,
      product_img: banner_list[8],
      product_description:  "sadfajof dfjaoij adoifj sdadifj oiddescription",
      product_price: "1500",
      product_discount: "15%",
      m_size:"15",
      l_size:"15",
      xl_size:"15"
  ), product_model(id: 123,
      product_img: banner_list[9],
      product_description:  "sadfajof dfjaoij adoifj sdadifj oiddescription",
      product_price: "1500",
      product_discount: "15%",
      m_size:"15",
      l_size:"15",
      xl_size:"15"
  ), product_model(id: 123,
      product_img: banner_list[10],
      product_description:  "sadfajof dfjaoij adoifj sdadifj oiddescription",
      product_price: "1500",
      product_discount: "15%",
      m_size:"15",
      l_size:"15",
      xl_size:"15"
  ), product_model(id: 123,
      product_img: banner_list[11],
      product_description:  "sadfajof dfjaoij adoifj sdadifj oiddescription",
      product_price: "1500",
      product_discount: "15%",
      m_size:"15",
      l_size:"15",
      xl_size:"15"
  ), product_model(id: 123,
      product_img: banner_list[12],
      product_description:  "sadfajof dfjaoij adoifj sdadifj oiddescription",
      product_price: "1500",
      product_discount: "15%",
      m_size:"15",
      l_size:"15",
      xl_size:"15"
  ), product_model(id: 123,
      product_img: banner_list[13],
      product_description:  "sadfajof dfjaoij adoifj sdadifj oiddescription",
      product_price: "1500",
      product_discount: "15%",
      m_size:"15",
      l_size:"15",
      xl_size:"15"
  ), product_model(id: 123,
      product_img: banner_list[14],
      product_description:  "sadfajof dfjaoij adoifj sdadifj oiddescription",
      product_price: "1500",
      product_discount: "15%",
      m_size:"15",
      l_size:"15",
      xl_size:"15"
  ), product_model(id: 123,
      product_img: banner_list[15],
      product_description:  "sadfajof dfjaoij adoifj sdadifj oiddescription",
      product_price: "1500",
      product_discount: "15%",
      m_size:"15",
      l_size:"15",
      xl_size:"15"
  ), product_model(id: 123,
      product_img: banner_list[16],
      product_description:  "sadfajof dfjaoij adoifj sdadifj oiddescription",
      product_price: "1500",
      product_discount: "15%",
      m_size:"15",
      l_size:"15",
      xl_size:"15"
  ), product_model(id: 123,
      product_img: banner_list[17],
      product_description:  "sadfajof dfjaoij adoifj sdadifj oiddescription",
      product_price: "1500",
      product_discount: "15%",
      m_size:"15",
      l_size:"15",
      xl_size:"15"
  ), product_model(id: 123,
      product_img: banner_list[18],
      product_description:  "sadfajof dfjaoij adoifj sdadifj oiddescription",
      product_price: "1500",
      product_discount: "15%",
      m_size:"15",
      l_size:"15",
      xl_size:"15"
  ), product_model(id: 123,
      product_img: banner_list[19],
      product_description:  "sadfajof dfjaoij adoifj sdadifj oiddescription",
      product_price: "1500",
      product_discount: "15%",
      m_size:"15",
      l_size:"15",
      xl_size:"15"
  ), product_model(id: 123,
      product_img: banner_list[20],
      product_description:  "sadfajof dfjaoij adoifj sdadifj oiddescription",
      product_price: "1500",
      product_discount: "15%",
      m_size:"15",
      l_size:"15",
      xl_size:"15"
  ), product_model(id: 123,
      product_img: banner_list[21],
      product_description:  "sadfajof dfjaoij adoifj sdadifj oiddescription",
      product_price: "1500",
      product_discount: "15%",
      m_size:"15",
      l_size:"15",
      xl_size:"15"
  ), product_model(id: 123,
      product_img: banner_list[22],
      product_description:  "sadfajof dfjaoij adoifj sdadifj oiddescription",
      product_price: "1500",
      product_discount: "15%",
      m_size:"15",
      l_size:"15",
      xl_size:"15"
  ), product_model(id: 123,
      product_img: banner_list[23],
      product_description:  "sadfajof dfjaoij adoifj sdadifj oiddescription",
      product_price: "1500",
      product_discount: "15%",
      m_size:"15",
      l_size:"15",
      xl_size:"15"
  ), product_model(id: 123,
      product_img: banner_list[24],
      product_description:  "sadfajof dfjaoij adoifj sdadifj oiddescription",
      product_price: "1500",
      product_discount: "15%",
      m_size:"15",
      l_size:"15",
      xl_size:"15"
  ), product_model(id: 123,
      product_img: banner_list[25],
      product_description:  "sadfajof dfjaoij adoifj sdadifj oiddescription",
      product_price: "1500",
      product_discount: "15%",
      m_size:"15",
      l_size:"15",
      xl_size:"15"
  ), product_model(id: 123,
      product_img: banner_list[26],
      product_description:  "sadfajof dfjaoij adoifj sdadifj oiddescription",
      product_price: "1500",
      product_discount: "15%",
      m_size:"15",
      l_size:"15",
      xl_size:"15"
  ), product_model(id: 123,
      product_img: banner_list[27],
      product_description:  "sadfajof dfjaoij adoifj sdadifj oiddescription",
      product_price: "1500",
      product_discount: "15%",
      m_size:"15",
      l_size:"15",
      xl_size:"15"
  ), product_model(id: 123,
      product_img: banner_list[28],
      product_description:  "sadfajof dfjaoij adoifj sdadifj oiddescription",
      product_price: "1500",
      product_discount: "15%",
      m_size:"15",
      l_size:"15",
      xl_size:"15"
  ),
];