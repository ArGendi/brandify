import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:tabe3/constants.dart';
import 'package:tabe3/cubits/add_product/add_product_cubit.dart';
import 'package:tabe3/cubits/products/products_cubit.dart';
import 'package:tabe3/view/screens/products/add_product_screen.dart';
import 'package:tabe3/view/widgets/product_card.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ProductsCubit.get(context).getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My products"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<ProductsCubit, ProductsState>(
          builder: (context, state) {
            if(state is LoadingProductsState){
              return Center(child: CircularProgressIndicator(color: mainColor,),);
            }
            else{
              return Visibility(
                visible: ProductsCubit.get(context).products.isNotEmpty,
                replacement: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset(
                        "assets/animations/request.json",
                        width: 300,
                      ),
                      //SizedBox(height: 20,),
                      Text("No products, Add now")
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    TextField(
                      onChanged: (value) {
                        ProductsCubit.get(context).filterProducts(value);
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 10.0),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey[600],
                        ),
                        hintText: "Search",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 15,
                                crossAxisSpacing: 15,
                                childAspectRatio: 0.75),
                        itemBuilder: (_, i) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ProductCard(
                                      product: ProductsCubit.get(context)
                                          .filteredProducts[i]),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                ProductsCubit.get(context)
                                    .filteredProducts[i]
                                    .name
                                    .toString(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          );
                        },
                        itemCount: ProductsCubit.get(context)
                            .filteredProducts
                            .length,
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ProductsCubit.get(context).filteredProducts 
            = ProductsCubit.get(context).products;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BlocProvider(
                        create: (context) => AddProductCubit(),
                        child: AddProductScreen(),
                      )));
        },
        label: Text("Add product"),
        icon: Icon(Icons.add),
      ),
    );
  }
}
