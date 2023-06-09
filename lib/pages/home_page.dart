import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:s12_products/pages/pages.dart';
import 'package:s12_products/services/auth_service.dart';
import '../models/models.dart' show Product;
import '../services/services.dart' show ProductsService;
import '../widgets/widgets.dart' show ProductCard;

class HomePage extends StatelessWidget {

  static const String routeName = 'home_page';

	const HomePage({super.key});

	@override
	Widget build(BuildContext context) {

		final ProductsService productsService = Provider.of<ProductsService>(context);
		final AuthService authService = Provider.of<AuthService>(context);

		if (productsService.isLoading) {
			return const LoadingPage();
		}

  	return Scaffold(
			appBar: AppBar(
				title: const Text('Products',
					style: TextStyle(color: Colors.white)
				),
				actions: [
					IconButton(
						padding: const EdgeInsets.only(right: 4),
						onPressed: () async {
							await authService.logout();
							Navigator.pushReplacementNamed(context, LoginPage.routeName);
						},
						icon: const Icon(Icons.logout_outlined)
					)
				],
			),
    	body: ListView.builder(
				padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
				itemCount: productsService.products.length,
				itemBuilder: (_, index) => GestureDetector(
					onTap: () {
						productsService.selectedProduct = productsService.products[index].copy();
						Navigator.pushNamed(context, ProductPage.routeName);
					},
					child: ProductCard(product: productsService.products[index])
				)
			),
			floatingActionButton: FloatingActionButton(
				onPressed: () {
					productsService.selectedProduct = Product(
							name: '',
							price: 0,
							isAvailable: true
					);
					Navigator.pushNamed(context, ProductPage.routeName);
				},
				child: const Icon(Icons.add,
					color: Colors.white,
				)
			)
		);
	}

}