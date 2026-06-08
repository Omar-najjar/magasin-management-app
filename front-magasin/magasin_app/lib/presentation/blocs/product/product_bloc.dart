import 'package:flutter_bloc/flutter_bloc.dart';

import 'product_event.dart';
import 'product_state.dart';
import '../../../data/services/api_service.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {

  ProductBloc() : super(ProductInitial()) {

    on<LoadProducts>((event, emit) async {
      emit(ProductLoading());

      try {
        final products = await ApiService.getProducts();
        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductError("Erreur chargement produits"));
      }
    });

    on<AddProductEvent>((event, emit) async {
      try {
        await ApiService.addProduct(event.product);

        // Reload produits
        final products = await ApiService.getProducts();
        emit(ProductLoaded(products));

      } catch (e) {
        emit(ProductError("Erreur ajout produit"));
      }
    });

    // UPDATE
on<UpdateProductEvent>((event, emit) async {
  try {
    await ApiService.updateProduct(event.id, event.product);
    final products = await ApiService.getProducts();
    emit(ProductLoaded(products));
  } catch (e) {
    emit(ProductError("Erreur update"));
  }
});

// DELETE
on<DeleteProductEvent>((event, emit) async {
  try {
    await ApiService.deleteProduct(event.id);
    final products = await ApiService.getProducts();
    emit(ProductLoaded(products));
  } catch (e) {
    emit(ProductError("Erreur suppression"));
  }
});

// SEARCH
on<SearchProductEvent>((event, emit) async {
  emit(ProductLoading());

  try {
    final products = await ApiService.searchProducts(event.query);
    emit(ProductLoaded(products));
  } catch (e) {
    emit(ProductError("Erreur recherche"));
  }
});
  }
}